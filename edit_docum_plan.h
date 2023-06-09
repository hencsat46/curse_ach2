#ifndef EDIT_DOCUM_PLAN_H
#define EDIT_DOCUM_PLAN_H

#include <QWidget>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QDebug>

namespace Ui {
class Edit_docum_plan;
}

class Edit_docum_plan : public QWidget
{
    Q_OBJECT

public:
    explicit Edit_docum_plan(QWidget *parent = nullptr);
    ~Edit_docum_plan();
    void get_teacher(QString pub_name, QString role);

private:
    QString role;
    QString old_name;
    Ui::Edit_docum_plan *ui;
    void close_db(QString connection_name);
public slots:
    void save_data();
    void add_data();
    void delete_data();
};

#endif // EDIT_DOCUM_PLAN_H
