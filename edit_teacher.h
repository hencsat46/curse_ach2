#ifndef EDIT_TEACHER_H
#define EDIT_TEACHER_H

#include <QWidget>
#include <QSqlDatabase>
#include <QDebug>
#include <QSqlQuery>

namespace Ui {
class Edit_teacher;
}

class Edit_teacher : public QWidget
{
    Q_OBJECT

public:
    explicit Edit_teacher(QWidget *parent = nullptr);
    ~Edit_teacher();
    void get_teacher(QString pub_name, QString pub_name2, QString pub_name3, QString temp_role);

private:
    Ui::Edit_teacher *ui;
    QString role;
    QString old_name, old_name2, old_name3;
    void close_db(QString connection_name);

public slots:
    void save_data();
    void add_data();
    void delete_data();
};

#endif // EDIT_TEACHER_H
