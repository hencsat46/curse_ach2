#include "edit_archive.h"
#include "ui_edit_archive.h"


Edit_archive::Edit_archive(QWidget *parent) : QWidget(parent), ui(new Ui::Edit_archive) {
    ui->setupUi(this);


    connect(ui->ea_save_button, SIGNAL(clicked()), this, SLOT(save_data()));
    connect(ui->ea_add_button, SIGNAL(clicked()), this, SLOT(add_data()));
    connect(ui->ea_delete_button, SIGNAL(clicked()), this, SLOT(delete_data()));
}

Edit_archive::~Edit_archive() {
    delete ui;
}

void Edit_archive::get_teacher(QString pub_name, QString temp_role) {
    role = temp_role;
    old_name = pub_name;
    qDebug() << QSqlDatabase::connectionNames();
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
                ui->ea_teacher_box->addItem(teacher);
            }
            query.exec("SELECT * FROM get_publisher();");
            while (query.next()) {
                ui->ea_publisher_box->addItem(query.value(0).toString());
            }

        }
    }
    close_db("edit_connection");

}


void Edit_archive::add_data() {
    QString name = ui->ea_name_edit->text();
    QString publisher = ui->ea_publisher_box->currentText();
    QString date = ui->ea_date_edit->text();
    QString author = ui->ea_teacher_box->currentText();
    int author_id;
    {
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", role + "_edit_" + "_connection");
        db.setHostName("localhost");
        db.setDatabaseName("curse_ach");
        db.setUserName(role);
        db.setPassword("administrator");
        bool status = db.open();
        qDebug() << role;
        if (status) {
            QSqlQuery query = QSqlQuery(db);
            query.exec("SELECT * FROM get_author_id('" + author + "');");
            query.next();
            author_id = query.value(0).toInt();

            query.exec("SELECT * FROM insert_archive('" + name + "', '" + author + "', '" + publisher
                       + "', '" + date + "');");

            qDebug() << "SELECT * FROM insert_archive('" + name + "', '" + author + "', '" + publisher
                            + "', '" + date + "');";


        }

    }

    close_db(role + "_edit_" + "_connection");
}

void Edit_archive::close_db(QString connection_name) {
    {
        QSqlDatabase db = QSqlDatabase::database(connection_name);
        db.close();
    }
    QSqlDatabase::removeDatabase(connection_name);
    return;
}

void Edit_archive::save_data() {

    qDebug() << QSqlDatabase::connectionNames();
    QString name = ui->ea_name_edit->text();
    QString publisher = ui->ea_publisher_box->currentText();
    QString date = ui->ea_date_edit->text();
    QString author = ui->ea_teacher_box->currentText();
    int author_id;
    {
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", role + "_edit_" + "_connection");
        db.setHostName("localhost");
        db.setDatabaseName("curse_ach");
        db.setUserName(role);
        db.setPassword("administrator");
        bool status = db.open();

        if (status) {
            QSqlQuery query = QSqlQuery(db);
            query.exec("SELECT * FROM get_author_id('" + author + "');");
            query.next();
            author_id = query.value(0).toInt();

            query.exec("SELECT * FROM update_archive('" + old_name + "', '" + name + "', '" + date + "', '" + publisher
                       + "', '" + author + "');");

            //qDebug() << "SELECT * FROM update_archive('" + old_name + "', '" + name + "', '" + date + "', '" + publisher
              //              + "', '" + author + "');";


        }

    }

    close_db(role + "_edit_" + "_connection");

    qDebug() << QSqlDatabase::connectionNames();

}

void Edit_archive::delete_data() {


    {
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", role + "_edit_" + "_connection");
        db.setHostName("localhost");
        db.setDatabaseName("curse_ach");
        db.setUserName(role);
        db.setPassword("administrator");
        bool status = db.open();
        qDebug() << role;
        if (status) {
            QSqlQuery query = QSqlQuery(db);
            query.exec("select * from delete_archive('" + old_name + "');");

        }

    }

    close_db(role + "_edit_" + "_connection");
}

void Edit_archive::get_publisher() {

}
