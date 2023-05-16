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

QT_BEGIN_NAMESPACE
namespace Ui { class Widget; }
QT_END_NAMESPACE

class Widget : public QWidget {
    Q_OBJECT

public:
    Widget(QWidget *parent = nullptr);
    ~Widget();

private:
    Ui::Widget *ui;
    QStandardItemModel *model;
    QSqlDatabase db;
    QString connection_name = "new_connection";
    void close_db();
    bool start_db_user();
    bool start_db_teacher();
    bool start_db_admin();
    bool start_db_superuser();


public slots:
    void show_table();
    void change_widget();
    void login();
    void registration();
    void box_changed();
    void reg_link();
    void auth_link();

};
#endif // WIDGET_H
