#include "edit_pub.h"
#include "ui_edit_pub.h"

Edit_pub::Edit_pub(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Edit_pub)
{
    ui->setupUi(this);
    connect(ui->ep_save_button, SIGNAL(clicked()), this, SLOT(save_data()));
    connect(ui->ep_add_button, SIGNAL(clicked()), this, SLOT(add_data()));
    connect(ui->ep_delete_button, SIGNAL(clicked()), this, SLOT(delete_data()));
}

void Edit_pub::get_teacher(QString pub_name, QString temp_role) {

    role = temp_role;
    old_name = pub_name;

}

void Edit_pub::save_data() {
    QString name = ui->ep_name_edit->text();
    QString gen = ui->ep_gen_edit->text();
    QString address = ui->ep_address_edit->text();

    {
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", role + "_edit_" + "_connection");
        db.setHostName("localhost");
        db.setDatabaseName("curse_ach");
        db.setUserName(role);
        db.setPassword("administrator");
        bool status = db.open();

        if (status) {
            QSqlQuery query = QSqlQuery(db);
            //qDebug() << "SELECT * FROM update_docum_plan('" + old_name + "', '" + author + "', '" + date + "', '" + name + "');";
            query.exec("SELECT * FROM update_publisher('" + old_name + "', '" + name + "', '" + gen + "', '" + address +"');");
        }

    }

    close_db(role + "_edit_" + "_connection");
}

void Edit_pub::add_data() {
    QString name = ui->ep_name_edit->text();
    QString gen = ui->ep_gen_edit->text();
    QString address = ui->ep_address_edit->text();

    {
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", role + "_edit_" + "_connection");
        db.setHostName("localhost");
        db.setDatabaseName("curse_ach");
        db.setUserName(role);
        db.setPassword("administrator");
        bool status = db.open();

        if (status) {
            QSqlQuery query = QSqlQuery(db);
            //qDebug() << "SELECT * FROM update_docum_plan('" + old_name + "', '" + author + "', '" + date + "', '" + name + "');";
            query.exec("SELECT * FROM insert_publisher('" + gen + "', '" + address + "', '" + name + "');");

        }

    }

    close_db(role + "_edit_" + "_connection");
}

void Edit_pub::close_db(QString connection_name) {
    {
        QSqlDatabase db = QSqlDatabase::database(connection_name);
        db.close();
    }
    QSqlDatabase::removeDatabase(connection_name);
    return;
}

void Edit_pub::delete_data() {
    {
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", role + "_edit_" + "_connection");
        db.setHostName("localhost");
        db.setDatabaseName("curse_ach");
        db.setUserName(role);
        db.setPassword("administrator");
        bool status = db.open();

        if (status) {
            QSqlQuery query = QSqlQuery(db);
            //qDebug() << "SELECT * FROM update_docum_plan('" + old_name + "', '" + author + "', '" + date + "', '" + name + "');";
            query.exec("SELECT * FROM delete_publisher('" + old_name + "');");
            query.next();
            //if (query.value(0).toString()) Вывод!!!
        }

    }

    close_db(role + "_edit_" + "_connection");
}

Edit_pub::~Edit_pub()
{
    delete ui;
}
