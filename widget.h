#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>
#include <QSqlDatabase>
#include <QDebug>
#include <QTableView>
#include <QStandardItemModel>
#include <QSqlQueryModel>
#include <QSqlQuery>
#include <QTableWidget>
#include <QLabel>

QT_BEGIN_NAMESPACE
namespace Ui { class Widget; }
QT_END_NAMESPACE

class Widget : public QWidget {
    Q_OBJECT

public:
    Widget(QWidget *parent = nullptr);
    ~Widget();
    void set_color(QLabel *label, QColor color);

private:
    Ui::Widget *ui;
    QStandardItemModel *model;
    QString role;
    void close_db(QString connection_name);
    bool start_db_user();
    bool start_db_teacher();
    bool start_db_admin();
    bool start_db_superuser(QSqlDatabase db);
    QSqlQueryModel *sql_model;



public slots:
    void show_table();
    void login();
    void registration();
    void box_changed();
    void reg_link();
    void auth_link();
    void db_disconnect();

};
#endif // WIDGET_H
