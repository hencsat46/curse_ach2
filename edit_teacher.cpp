#include "edit_teacher.h"
#include "ui_edit_teacher.h"

Edit_teacher::Edit_teacher(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Edit_teacher)
{
    ui->setupUi(this);
    connect(ui->et_save_button, SIGNAL(clicked()), this, SLOT(save_data()));
    connect(ui->et_add_button, SIGNAL(clicked()), this, SLOT(add_data()));
    connect(ui->et_delete_button, SIGNAL(clicked()), this, SLOT(delete_data()));
}

Edit_teacher::~Edit_teacher()
{
    delete ui;
}

void Edit_teacher::get_teacher(QString pub_name, QString pub_name2, QString pub_name3, QString temp_role) {

    role = temp_role;
    old_name = pub_name;
    old_name2 = pub_name2;
    old_name3 = pub_name3;

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
            query.exec("SELECT * FROM get_faculties();");
            QString teacher;
            while (query.next()) {
                teacher = query.value(0).toString();
                ui->et_faculty_box->addItem(teacher);
            }


        }
    }
    close_db("edit_connection");

}

void Edit_teacher::close_db(QString connection_name) {
    {
        QSqlDatabase db = QSqlDatabase::database(connection_name);
        db.close();
    }
    QSqlDatabase::removeDatabase(connection_name);
    return;
}

void Edit_teacher::save_data() {
    QString name = ui->et_name_edit->text();
    QString surname = ui->et_surname_edit->text();
    QString faculty = ui->et_faculty_box->currentText();
    QString age = ui->et_age_edit->text();
    {
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", role + "_edit_" + "_connection");
        db.setHostName("localhost");
        db.setDatabaseName("curse_ach");
        db.setUserName(role);
        db.setPassword("administrator");
        bool status = db.open();

        if (status) {
            QSqlQuery query = QSqlQuery(db);

            qDebug() << "SELECT * FROM update_teacher_view('" + old_name + "', '" + old_name2 + "', '" + old_name3 + "', '" + name
                            + "', '" + surname + "', '" + faculty + "', " + age + ");";

            query.exec("SELECT * FROM update_teacher_view('" + old_name + "', '" + old_name2 + "', '" + old_name3 + "', '" + name
                       + "', '" + surname + "', '" + faculty + "', " + age + ");");

            //qDebug() << "SELECT * FROM update_archive('" + old_name + "', '" + name + "', '" + date + "', '" + publisher
            //              + "', '" + author + "');";


        }

    }

    close_db(role + "_edit_" + "_connection");
}

void Edit_teacher::add_data() {

}

void Edit_teacher::delete_data() {

}
