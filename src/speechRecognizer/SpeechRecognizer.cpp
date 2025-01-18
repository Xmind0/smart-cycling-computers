#include "SpeechRecognizer.h"
#include <QDebug>
#include <QFile>

SpeechRecognizer::SpeechRecognizer(QObject *parent)
    : QObject(parent)
    , m_recording(false)
    , m_sessionValid(false)
    , m_waitingForConnection(false)
{
    // 打印所有可用的音频输入设备
    qDebug() << "Available audio input devices:";
    for (const QAudioDevice &device : QMediaDevices::audioInputs()) {
        qDebug() << " - " << device.description();
    }

    QAudioFormat format;
    format.setSampleRate(16000);
    format.setChannelCount(1);
    format.setSampleFormat(QAudioFormat::Int16);

    QAudioDevice inputDevice = QMediaDevices::defaultAudioInput();
    if (!inputDevice.isFormatSupported(format)) {
        qWarning() << "Default format not supported, trying to use nearest format";
        format = inputDevice.preferredFormat();
    }

    qDebug() << "Using audio format:"
             << "\nSample rate:" << format.sampleRate()
             << "\nChannels:" << format.channelCount()
             << "\nSample format:" << format.sampleFormat()
             << "\nBytes per frame:" << format.bytesPerFrame();

    m_buffer = new QBuffer(this);
    m_buffer->open(QIODevice::ReadWrite);

    m_audioSource = new QAudioSource(inputDevice, format, this);
    m_audioSource->setBufferSize(32768);

    // 监控音频状态
    connect(m_audioSource, &QAudioSource::stateChanged,
            this, [this](QAudio::State state) {
                qDebug() << "Audio state changed:" << state;
                if (state == QAudio::StoppedState && m_audioSource->error() != QAudio::NoError) {
                    qDebug() << "Audio error:" << m_audioSource->error();
                }
            });

    // WebSocket 连接和错误处理
    connect(&m_webSocket, &QWebSocket::connected,
            this, &SpeechRecognizer::onConnected);

    connect(&m_webSocket, &QWebSocket::textMessageReceived,
            this, &SpeechRecognizer::onTextMessage);

    connect(&m_webSocket, &QWebSocket::errorOccurred,
            this, [this](QAbstractSocket::SocketError error) {
                qDebug() << "WebSocket error:" << error << m_webSocket.errorString();
            });

    connect(&m_webSocket, &QWebSocket::stateChanged,
            this, [this](QAbstractSocket::SocketState state) {
                qDebug() << "WebSocket state changed:" << state;
            });
}

void SpeechRecognizer::startRecording()
{
    if (m_recording) return;

    qDebug() << "Starting recording...";

    // 添加音频设备检查
    QAudioDevice inputDevice = QMediaDevices::defaultAudioInput();
    if (!inputDevice.isNull()) {
        qDebug() << "Using audio device:" << inputDevice.description();
    } else {
        qDebug() << "No audio input device found!";
        return;
    }

    // 重置所有状态
    m_text.clear();
    emit textChanged();
    m_buffer->buffer().clear();
    m_buffer->seek(0);
    m_sessionValid = false;
    m_firstFrame = true;
    m_waitingForConnection = true;
    m_frameStatus = STATUS_FIRST_FRAME;
    m_bufferReady = false;
    m_processedPosition = 0;

    // 设置录音状态
    m_recording = true;
    emit recordingChanged();

    // 启动音频采集
    m_audioSource->start(m_buffer);

    // 启动定时器监控音频数据
    m_timer.disconnect();
    connect(&m_timer, &QTimer::timeout, this, [this]() {
        if (!m_recording) return;

        int availableData = m_buffer->size() - m_processedPosition;
        
        if (!m_bufferReady && availableData >= MIN_BUFFER_SIZE) {
            m_bufferReady = true;
            qDebug() << "Buffer ready with size:" << availableData;
            
            // 缓冲区准备好后，开始WebSocket连接
            QString url = QString("wss://iat-api.xfyun.cn/v2/iat?authorization=%1&date=%2&host=%3")
                              .arg(generateAuthorization())
                              .arg(QDateTime::currentDateTimeUtc().toString("ddd, dd MMM yyyy HH:mm:ss") + " GMT")
                              .arg("iat-api.xfyun.cn");

            qDebug() << "Connecting to WebSocket URL:" << url;
            m_webSocket.open(QUrl(url));
            return;
        }

        if (m_bufferReady && m_sessionValid) {
            if (m_firstFrame) {
                sendFirstFrame();
            } else if (availableData >= FRAME_SIZE) {
                sendAudioData();
            }
        }
    });
    
    m_timer.setInterval(40);
    m_timer.start();
}

void SpeechRecognizer::stopRecording()
{
    if (!m_recording) {
        return;
    }

    qDebug() << "Stopping recording...";
    m_recording = false;
    emit recordingChanged();

    m_timer.stop();

    if (m_webSocket.state() == QAbstractSocket::ConnectedState) {
        QJsonObject json;
        QJsonObject audioData;
        audioData["status"] = STATUS_LAST_FRAME;
        audioData["format"] = "audio/L16;rate=16000";
        audioData["encoding"] = "raw";
        audioData["audio"] = "";
        json["data"] = audioData;

        QString message = QJsonDocument(json).toJson();
        m_webSocket.sendTextMessage(message);
        qDebug() << "Sent final end frame";

        QTimer::singleShot(1000, this, [this]() {
            qDebug() << "Closing WebSocket connection after delay";
            m_webSocket.close();
        });
    }
    m_audioSource->stop();
}

void SpeechRecognizer::onConnected()
{
    qDebug() << "WebSocket connected successfully";
    m_waitingForConnection = false;
    m_sessionValid = true;

    QTimer::singleShot(100, this, [this]() {
        if (m_recording) {
            sendFirstFrame();
        }
    });
}

void SpeechRecognizer::onTextMessage(const QString &message)
{
    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8(), &error);

    if (error.error != QJsonParseError::NoError) {
        qDebug() << "JSON parse error:" << error.errorString();
        return;
    }

    QJsonObject obj = doc.object();
    qDebug() << "Received WebSocket message:" << message;

    int code = obj["code"].toInt();
    if (code != 0) {
        qDebug() << "Error response, code:" << code
                 << "message:" << obj["message"].toString();
        stopRecording();
        return;
    }

    QJsonObject data = obj["data"].toObject();
    QJsonObject result = data["result"].toObject();

    if (result.contains("ws")) {
        QJsonArray words = result["ws"].toArray();
        QString text;
        for (const QJsonValue &word : words) {
            QJsonArray cw = word.toObject()["cw"].toArray();
            for (const QJsonValue &item : cw) {
                text += item.toObject()["w"].toString();
            }
        }

        if (!text.isEmpty()) {
            m_text += text;
            qDebug() << "Recognized text:" << text;
            emit textChanged();
        }
    }

    int status = data["status"].toInt();
    if (status == 2) {
        qDebug() << "Received final response";
        stopRecording();
    }
}

void SpeechRecognizer::sendAudioData()
{
    if (!m_recording || !m_sessionValid) {
        return;
    }

    int availableData = m_buffer->size() - m_processedPosition;
    
    if (availableData < FRAME_SIZE) {
        if (availableData > 0) {
            m_buffer->seek(m_processedPosition);
            QByteArray remainingData = m_buffer->read(availableData);
            m_processedPosition += availableData;
            
            QJsonObject json;
            QJsonObject data;
            data["status"] = STATUS_LAST_FRAME;
            data["format"] = "audio/L16;rate=16000";
            data["encoding"] = "raw";
            data["audio"] = QString(remainingData.toBase64());
            json["data"] = data;

            QString message = QJsonDocument(json).toJson();
            qDebug() << "Sending last frame with size:" << remainingData.size();
            m_webSocket.sendTextMessage(message);
        }
        stopRecording();
        return;
    }

    m_buffer->seek(m_processedPosition);
    QByteArray frameData = m_buffer->read(FRAME_SIZE);
    m_processedPosition += FRAME_SIZE;

    const int16_t* samples = reinterpret_cast<const int16_t*>(frameData.constData());
    int sampleCount = frameData.size() / 2;
    bool hasValidData = false;
    
    for (int i = 0; i < sampleCount; ++i) {
        if (samples[i] != 0) {
            hasValidData = true;
            break;
        }
    }

    if (!hasValidData) {
        return;
    }

    QJsonObject json;
    QJsonObject data;
    data["status"] = STATUS_CONTINUE_FRAME;
    data["format"] = "audio/L16;rate=16000";
    data["encoding"] = "raw";
    data["audio"] = QString(frameData.toBase64());
    json["data"] = data;

    QString message = QJsonDocument(json).toJson();
    m_webSocket.sendTextMessage(message);
}

QString SpeechRecognizer::generateAuthorization()
{
    const QString API_KEY = "6dd68bc1427ff1fcdd6de992a57b80cc";      // 需要修改自己的API_KEY
    const QString API_SECRET = "ZmE5OTJlODA0MDcxMzY0MmY2ODVhYTg0";  // 需要修改自己的API_SECRET

    QString dateStr = QDateTime::currentDateTimeUtc().toString("ddd, dd MMM yyyy HH:mm:ss") + " GMT";

    QString signStr = QString("host: iat-api.xfyun.cn\n"
                              "date: %1\n"
                              "GET /v2/iat HTTP/1.1")
                          .arg(dateStr);

    QByteArray signature = QMessageAuthenticationCode::hash(
                               signStr.toUtf8(),
                               API_SECRET.toUtf8(),
                               QCryptographicHash::Sha256
                               ).toBase64();

    QString authStr = QString(R"(api_key="%1", algorithm="hmac-sha256", )"
                              R"(headers="host date request-line", signature="%2")")
                          .arg(API_KEY, signature);

    return authStr.toUtf8().toBase64();
}

void SpeechRecognizer::sendFirstFrame()
{
    int availableData = m_buffer->size() - m_processedPosition;
    
    qDebug() << "Attempting to send first frame:"
             << "\nBuffer size:" << m_buffer->size()
             << "\nProcessed position:" << m_processedPosition
             << "\nAvailable data:" << availableData;

    if (availableData < FRAME_SIZE) {
        qDebug() << "Not enough data for first frame, waiting...";
        return;
    }

    m_buffer->seek(m_processedPosition);
    QByteArray firstFrameData = m_buffer->read(FRAME_SIZE);
    m_processedPosition += FRAME_SIZE;

    const int16_t* samples = reinterpret_cast<const int16_t*>(firstFrameData.constData());
    int sampleCount = firstFrameData.size() / 2;
    bool hasValidData = false;
    
    for (int i = 0; i < sampleCount; ++i) {
        if (samples[i] != 0) {
            hasValidData = true;
            break;
        }
    }

    if (!hasValidData) {
        qDebug() << "First frame contains no valid audio data, waiting...";
        return;
    }

    QJsonObject json;

    QJsonObject common;
    common["app_id"] = "59425c36";  // 需要修改自己的app_id
    json["common"] = common;

    QJsonObject business;
    business["language"] = "zh_cn";
    business["domain"] = "iat";
    business["accent"] = "mandarin";
    business["vad_eos"] = 10000;
    business["dwa"] = "wpgs";
    business["pd"] = "game";
    business["ptt"] = 1;
    business["rlang"] = "zh-cn";
    business["vinfo"] = 1;
    business["nunum"] = 1;
    business["speex_size"] = 70;
    business["nbest"] = 1;
    business["wbest"] = 1;
    json["business"] = business;

    QJsonObject data;
    data["status"] = STATUS_FIRST_FRAME;
    data["format"] = "audio/L16;rate=16000";
    data["encoding"] = "raw";
    data["audio"] = QString(firstFrameData.toBase64());
    json["data"] = data;

    QString message = QJsonDocument(json).toJson();
    qDebug() << "Sending first frame with config:" << message;
    m_webSocket.sendTextMessage(message);

    m_frameStatus = STATUS_CONTINUE_FRAME;
    m_firstFrame = false;
    m_sessionValid = true;
} 
