#ifndef SPEECHRECOGNIZER_H
#define SPEECHRECOGNIZER_H

#include <QObject>
#include <QWebSocket>
#include <QAudioSource>
#include <QDateTime>
#include <QMessageAuthenticationCode>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QBuffer>
#include <QTimer>
#include <QMediaDevices>
#include <QAudioDevice>

namespace {
constexpr int FRAME_SIZE = 12800;  // 每帧音频大小 (16k采样率 * 40ms * 2字节)
}

class SpeechRecognizer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text NOTIFY textChanged)
    Q_PROPERTY(bool recording READ recording NOTIFY recordingChanged)

public:
    explicit SpeechRecognizer(QObject *parent = nullptr);
    QString text() const { return m_text; }
    bool recording() const { return m_recording; }

public slots:
    void startRecording();
    void stopRecording();


signals:
    void textChanged();
    void recordingChanged();

private slots:
    void onConnected();
    void onTextMessage(const QString &message);
    void sendAudioData();

private:
    QString generateAuthorization();
    void sendFirstFrame();

    QWebSocket m_webSocket;
    QAudioSource *m_audioSource;
    QBuffer *m_buffer;
    QTimer m_timer;
    QString m_text;
    bool m_recording;
    bool m_firstFrame;
    bool m_sessionValid;
    bool m_waitingForConnection;
    qint64 m_startTime;

    enum FrameStatus {
        STATUS_FIRST_FRAME = 0,
        STATUS_CONTINUE_FRAME = 1,
        STATUS_LAST_FRAME = 2
    };

    FrameStatus m_frameStatus;
    static constexpr int MIN_BUFFER_SIZE = FRAME_SIZE * 2;
    bool m_bufferReady = false;
    qint64 m_processedPosition = 0;
};

#endif // SPEECHRECOGNIZER_H 
