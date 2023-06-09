#ifndef EDIT_ARCHIVE_H
#define EDIT_ARCHIVE_H

#include <QWidget>
#include <QSqlDatabase>
#include <QDebug>
#include <QSqlQuery>
#include <QTableView>


namespace Ui {
class Edit_archive;
}

class Edit_archive : public QWidget
{
    Q_OBJECT

public:
    explicit Edit_archive(QWidget *parent = nullptr);
    ~Edit_archive();
    void get_teacher(QString pub_name, QString role);
private:
    Ui::Edit_archive *ui;
    void close_db(QString connection_name);
    QString role;
    QString old_name;
    void get_publisher();

public slots:
    void save_data();
    void add_data();
    void delete_data();
};

#endif // EDIT_ARCHIVE_H
