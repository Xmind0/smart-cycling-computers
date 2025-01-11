#include "httputils.h"

HttpUtils::HttpUtils(QObject *parent) : QObject(parent)
{
    manager = new QNetworkAccessManager(this);
    // 设置线程池最大线程数
    m_threadPool.setMaxThreadCount(5);
}

HttpUtils::~HttpUtils()
{
    m_threadPool.waitForDone();
}

void HttpUtils::get(const QString &url, const QString &requestId)
{
    // 创建工作线程并启动
    NetworkWorker *worker = new NetworkWorker(BASE_URL + url, requestId, this);
    worker->setAutoDelete(true);
    m_threadPool.start(worker);
}

// 网络工作线程实现
HttpUtils::NetworkWorker::NetworkWorker(const QString &url, const QString &requestId, HttpUtils *parent)
    : QObject(nullptr), m_url(url), m_requestId(requestId), m_parent(parent)
{
}

void HttpUtils::NetworkWorker::run()
{
    // 在新线程中创建网络管理器
    QNetworkAccessManager manager;
    QNetworkRequest request;
    request.setUrl(QUrl(m_url));
    
    // 创建事件循环以等待响应
    QEventLoop loop;
    QNetworkReply *reply = manager.get(request);
    
    // //打印线程id
    // qDebug() << "线程ID:" << QThread::currentThreadId();

    // 连接完成信号到事件循环
    QObject::connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    
    // 等待请求完成
    loop.exec();

    if (reply->error() == QNetworkReply::NoError) {
        QString response = QString::fromUtf8(reply->readAll());
        
        // 使用 QMetaObject::invokeMethod 在主线程中发送信号
        QMetaObject::invokeMethod(m_parent, "replySignal",
                                Qt::QueuedConnection,
                                Q_ARG(QString, m_requestId),
                                Q_ARG(QString, response));
    }
    
    reply->deleteLater();
}
