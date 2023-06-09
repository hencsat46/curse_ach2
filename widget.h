#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>
#include <QSqlDatabase>
#include <QDebug>
#include <QTableView>
#include <QStandardItemModel>
#include <QSqlQueryModel>
#include <QSqlQuery>
#include <QSqlError>
#include <QTableWidget>
#include <QLabel>
#include <QList>
#include "QStringListModel"
#include <QSqlTableModel>
#include "edit_archive.h"
#include "edit_docum_plan.h"
#include "edit_faculty.h"
#include <QSqlRecord>
#include <QSqlField>
#include <QVariant>

QT_BEGIN_NAMESPACE
namespace Ui { class Widget; }
QT_END_NAMESPACE

class Widget : public QWidget {
    Q_OBJECT

public:
    Widget(QWidget *parent = nullptr);
    ~Widget();
    void set_color(QLabel *label, QColor color);
    QString role = "";
    void close_db(QString connection_name);

private:
    Ui::Widget *ui;
    QStandardItemModel *model;

    bool start_db_user();
    bool start_db_teacher();
    bool start_db_admin();
    bool start_db_superuser(QSqlDatabase db);
    QSqlQueryModel *sql_model = nullptr;
    bool wrong_code(int role, QString code);
    void shit_config();
    void close_mode_connection(QString connection_name);
    QList<QString> table_list;
    bool check_permission(QString code);
    QSqlTableModel* table_model;
    Edit_archive archive;
    Edit_docum_plan docum_plan;
    Edit_faculty faculty;
    QModelIndex table_index;


public slots:
    void show_table();
    void login();
    void registration();
    void box_changed();
    void reg_link();
    void auth_link();
    void db_disconnect();
    void get_tables();
    void temp_index(const QModelIndex &index);
    void show_edit_archive();
    //void table_changed();

};
#endif // WIDGET_H
