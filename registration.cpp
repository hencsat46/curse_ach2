#include "widget.h"
#include "ui_widget.h"

void Widget::reg_link() {
    ui->stackedWidget->setCurrentIndex(2);
}

void Widget::registration() {

    QString username = ui->r_login_edit->text();
    QString password = ui->r_password_edit->text();
    QString name = ui->r_name_edit->text();
    QString surname = ui->r_surname_edit->text();
    QString code = ui->r_code_edit->text();
    int role = ui->r_box_role->currentIndex();


    if (username.isEmpty() || password.isEmpty()) {
        ui->r_wdata_label->show();
        ui->r_wcode_label->hide();
        return;
    }

    if (wrong_code(role, code)) {
        ui->r_wcode_label->show();
        ui->r_wdata_label->hide();
        return;
    }

    {
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", "superuser_connection");
        bool status = start_db_superuser(db);
        QSqlQuery query = QSqlQuery(db);
        //qDebug() << status;
        if (status) {

            switch(role) {
                case 0:
                    query.exec("SELECT * FROM strong_insert(\'" + username + "\', \'" + password + "\', \'user_1\');");
                    qDebug() << "student added\n";
                    break;
                case 1:
                    query.exec("SELECT * FROM strong_insert(\'" + username + "\', \'" + password + "\', \'teacher\');");
                    qDebug() << "teacher added\n";
                    break;
                case 2:
                    query.exec("SELECT * FROM strong_insert(\'" + username + "\', \'" + password + "\', \'administrator\');");
                    qDebug() << "admin added\n";
                    break;
            }

            if (ui->r_box_role->currentIndex() == 1) {

            }
        }
    }

    close_db("superuser_connection");


//query.exec("SELECT * FROM strong_insert(\'" + username + "\', \'" + password + "\', \'" + roles[ui->r_box_role->currentIndex()] + "\');");

}

void Widget::box_changed() {
    if (ui->r_box_role->currentIndex() != 0) {
        ui->r_input_widget->move(300, 200);
        ui->r_code_widget->show();
        if (ui->r_box_role->currentIndex() == 1) {
            ui->r_input_widget->move(300, 220);
            ui->r_faculty_widget->show();
            return;
        }
        ui->r_faculty_widget->hide();
        return;

    }


    ui->r_input_widget->move(300, 160);
    ui->r_code_widget->hide();
    ui->r_faculty_widget->hide();
}

bool Widget::start_db_superuser(QSqlDatabase db) {
    db.setHostName("localhost");
    db.setDatabaseName("curse_ach");
    db.setUserName("superuser");
    db.setPassword("forstudy");
    return db.open();
}

bool Widget::wrong_code(int role, QString code) {
    if ((role == 1 && code != "1234") || (role == 2 && code != "4321")) return true ;
    return false;
}
