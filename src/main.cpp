#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWebEngineQuick/QtWebEngineQuick>
#include "network/httputils.h"

#include <QQuickWindow>
int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    app.setOrganizationName("Some Company");
    app.setOrganizationDomain("somecompany.com");

    qmlRegisterType<HttpUtils>("MyUtils",1,0,"HttpUtils");

    //初始化 WebEngine
    // QtWebEngineQuick::initialize();

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/src/qml/main.qml"));
    qDebug() << "Loading QML from:" << url.toString();
    qDebug() << "QML file exists:" << QFile::exists(url.toString());

    // 列出所有资源
    QDirIterator it(":", QDirIterator::Subdirectories);
    while (it.hasNext()) {
        qDebug() << "Available resource:" << it.next();
    }

    qDebug() << "Loading QML from:" << url.toString();
    qDebug() << "QML file exists:" << QFile::exists(url.toString());


    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/src/qml/Style.qml")), "Style", 1, 0, "Style");
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
