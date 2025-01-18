#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtWebEngineQuick>
#include "network/httputils.h"
#include "speechRecognizer/SpeechRecognizer.h"
#include "notes/NotesManager.h"

int main(int argc, char *argv[])
{
    // 在创建QGuiApplication之前初始化WebEngine
    QtWebEngineQuick::initialize();
    
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // 注册Style单例
    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/src/qml/Settings/Style.qml")), "Style", 1, 0, "Style");

    // 注册C++类到QML
    qmlRegisterType<HttpUtils>("Network", 1, 0, "HttpUtils");
    qmlRegisterType<SpeechRecognizer>("SpeechRecognition", 1, 0, "SpeechRecognizer");
    qmlRegisterType<NotesManager>("Notes", 1, 0, "NotesManager");

    const QUrl url(u"qrc:/src/qml/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);

    engine.load(url);
    return app.exec();
}
