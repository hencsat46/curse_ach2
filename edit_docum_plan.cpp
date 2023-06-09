#include "edit_docum_plan.h"
#include "ui_edit_docum_plan.h"

Edit_docum_plan::Edit_docum_plan(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Edit_docum_plan)
{
    ui->setupUi(this);
    connect(ui->edc_save_button, SIGNAL(clicked()), this, SLOT(save_data()));
    connect(ui->edc_add_button, SIGNAL(clicked()), this, SLOT(add_data()));
    connect(ui->edc_delete_button, SIGNAL(clicked()), this, SLOT(delete_data()));
}

Edit_docum_plan::~Edit_docum_plan()
{
    delete ui;
}

void Edit_docum_plan::get_teacher(QString pub_name, QString temp_role) {

    role = temp_role;
    old_name = pub_name;
    {
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", "edit_connection");
        db.setHostName("localhost");
        db.setDatabaseName("curse_ach");
        db.setUserName(role);
        db.setPassword("student");
        bool status = db.open();
        qDebug() << status;
        if (status) {
            QSqlQuery query = QSqlQuery(db);
            query.exec("SELECT * FROM get_authors();");
            QString teacher;
            while (query.next()) {
                teacher = query.value(0).toString();
                ui->edc_author_box->addItem(teacher);
            }

        }
    }
    close_db("edit_connection");

}

void Edit_docum_plan::close_db(QString connection_name) {
    {
        QSqlDatabase db = QSqlDatabase::database(connection_name);
        db.close();
    }
    QSqlDatabase::removeDatabase(connection_name);
    return;
}

void Edit_docum_plan::save_data() {

    QString name = ui->edc_name_edit->text();
    QString date = ui->edc_date_edit->text();

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
            query.exec("SELECT * FROM update_docum_plan('" + old_name + "', '" + date + "', '" + name + "');");
        }

    }

    close_db(role + "_edit_" + "_connection");

}

void Edit_docum_plan::add_data() {

    QString name = ui->edc_name_edit->text();
    QString date = ui->edc_date_edit->text();
    QString author = ui->edc_author_box->currentText();

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
            query.exec("CALL insert_docum_plan('" + name + "', '" + date + "', '" + author + "');");
        }

    }

    close_db(role + "_edit_" + "_connection");

}

void Edit_docum_plan::delete_data() {

    QString name = ui->edc_name_edit->text();
    QString date = ui->edc_date_edit->text();
    QString author = ui->edc_author_box->currentText();

    {
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", role + "_edit_" + "_connection");
        db.setHostName("localhost");
        db.setDatabaseName("curse_ach");
        db.setUserName(role);
        db.setPassword("administrator");
        bool status = db.open();
        qDebug() << old_name;
        if (status) {
            QSqlQuery query = QSqlQuery(db);
            //qDebug() << "SELECT * FROM update_docum_plan('" + old_name + "', '" + author + "', '" + date + "', '" + name + "');";
            query.exec("SELECT * FROM delete_docum_plan('" + old_name + "');");
        }

    }

    close_db(role + "_edit_" + "_connection");


}
