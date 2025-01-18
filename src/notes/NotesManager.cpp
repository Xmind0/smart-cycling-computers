#include "NotesManager.h"
#include <QStandardPaths>
#include <QFile>
#include <QDateTime>
#include <QTextStream>
#include <QDebug>

NotesManager::NotesManager(QObject *parent)
    : QObject(parent)
{
    m_notesDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/notes";
    ensureNotesDirectory();
}

void NotesManager::ensureNotesDirectory()
{
    QDir dir;
    if (!dir.exists(m_notesDir)) {
        dir.mkpath(m_notesDir);
    }
}

bool NotesManager::saveNote(const QString &fileName, const QString &content)
{
    QString filePath = m_notesDir + "/" + fileName;
    QFile file(filePath);
    
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Failed to open file for writing:" << filePath;
        return false;
    }

    QTextStream out(&file);
    out << content;
    file.close();
    return true;
}

QVariantList NotesManager::loadNotes()
{
    QVariantList notes;
    QDir dir(m_notesDir);
    QStringList filters;
    filters << "*.txt";
    QFileInfoList files = dir.entryInfoList(filters, QDir::Files, QDir::Time);

    for (const QFileInfo &fileInfo : files) {
        QFile file(fileInfo.filePath());
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            continue;
        }

        QTextStream in(&file);
        QString content = in.readAll();
        file.close();

        QVariantMap note;
        note["fileName"] = fileInfo.fileName();
        note["title"] = fileInfo.baseName();
        note["content"] = content;
        note["date"] = fileInfo.lastModified().toString("yyyy-MM-dd hh:mm:ss");
        
        notes.append(note);
    }

    return notes;
} 