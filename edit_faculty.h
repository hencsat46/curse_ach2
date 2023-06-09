#ifndef EDIT_FACULTY_H
#define EDIT_FACULTY_H

#include <QWidget>
#include <QSqlDatabase>
#include <QDebug>
#include <QSqlQuery>

namespace Ui {
class Edit_faculty;
}

class Edit_faculty : public QWidget
{
    Q_OBJECT

public:
    explicit Edit_faculty(QWidget *parent = nullptr);
    ~Edit_faculty();
    void get_teacher(QString pub_name, QString temp_role);
private:
    Ui::Edit_faculty *ui;
    QString role, old_name;
    void close_db(QString connection_name);

public slots:
    void save_data();
    void add_data();
    void delete_data();
};

#endif // EDIT_FACULTY_H
