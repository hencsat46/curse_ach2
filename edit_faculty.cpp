#include "edit_faculty.h"
#include "ui_edit_faculty.h"

Edit_faculty::Edit_faculty(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Edit_faculty)
{

    ui->setupUi(this);
    connect(ui->ef_save_button, SIGNAL(clicked()), this, SLOT(save_data()));
    connect(ui->ef_add_button, SIGNAL(clicked()), this, SLOT(add_data()));
    connect(ui->ef_delete_button, SIGNAL(clicked()), this, SLOT(delete_data()));
}

void Edit_faculty::get_teacher(QString pub_name, QString temp_role) {

    role = temp_role;
    old_name = pub_name;

}

void Edit_faculty::save_data() {
    QString name = ui->ef_name_edit->text();

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
            query.exec("SELECT * FROM update_faculty_func('" + old_name + "', '" + name + "');");
        }

    }

    close_db(role + "_edit_" + "_connection");

}

void Edit_faculty::add_data() {
    QString name = ui->ef_name_edit->text();

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
            query.exec("CALL add_faculty('" + name + "');");
        }

    }

    close_db(role + "_edit_" + "_connection");
}

void Edit_faculty::delete_data() {
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
            query.exec("SELECT * FROM delete_faculty('" + old_name + "');");
        }

    }

    close_db(role + "_edit_" + "_connection");
}

void Edit_faculty::close_db(QString connection_name) {
    {
        QSqlDatabase db = QSqlDatabase::database(connection_name);
        db.close();
    }
    QSqlDatabase::removeDatabase(connection_name);
    return;
}


Edit_faculty::~Edit_faculty()
{
    delete ui;
}
