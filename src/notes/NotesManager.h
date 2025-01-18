#ifndef NOTESMANAGER_H
#define NOTESMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QDir>

class NotesManager : public QObject
{
    Q_OBJECT

public:
    explicit NotesManager(QObject *parent = nullptr);

    Q_INVOKABLE bool saveNote(const QString &fileName, const QString &content);
    Q_INVOKABLE QVariantList loadNotes();

private:
    QString m_notesDir;
    void ensureNotesDirectory();
};

#endif // NOTESMANAGER_H 