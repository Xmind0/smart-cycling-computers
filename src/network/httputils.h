#ifndef HTTPUTILS_H
#define HTTPUTILS_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QMap>
#include <QThread>
#include <QThreadPool>
#include <QRunnable>
#include <QMutex>
#include <QEventLoop>    
#include <QMetaObject>   



class HttpUtils : public QObject
{
    Q_OBJECT    // 使用Q_OBJECT宏，以便可以使用Qt的元对象系统，允许使用信号和槽机制
public:
    explicit HttpUtils(QObject *parent = nullptr);
    // 构造函数，使用explicit关键字防止隐式转换
    ~HttpUtils();
    
    Q_INVOKABLE void get(const QString &url, const QString &requestId);
    // Q_INVOKABLE宏允许在QML中调用这些方法

signals:
    void replySignal(const QString &requestId, const QString &reply);

// private slots:
//     void handleReply(QNetworkReply *reply);

private:
    class NetworkWorker : public QObject, public QRunnable {
    public:
        NetworkWorker(const QString &url, const QString &requestId, HttpUtils *parent);
        void run() override;
        
    private:
        QString m_url;
        QString m_requestId;
        HttpUtils *m_parent;
    };

private:
    QNetworkAccessManager *manager;
    QString BASE_URL = "http://8.153.105.63:3000/";
    QThreadPool m_threadPool;
    QMutex m_mutex;

};
    
#endif // HTTPUTILS_H
