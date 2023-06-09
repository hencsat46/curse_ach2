#ifndef EDIT_PUB_H
#define EDIT_PUB_H

#include <QWidget>
#include <QSqlDatabase>
#include <QDebug>
#include <QSqlQuery>


namespace Ui {
class Edit_pub;
}

class Edit_pub : public QWidget
{
    Q_OBJECT

public:
    explicit Edit_pub(QWidget *parent = nullptr);
    ~Edit_pub();
    void get_teacher(QString pub_name, QString temp_role);
private:
    Ui::Edit_pub *ui;
    QString role;
    QString old_name;
    void close_db(QString connection_name);

public slots:
    void save_data();
    void add_data();
    void delete_data();
};

#endif // EDIT_PUB_H
