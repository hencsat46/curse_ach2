#include "widget.h"
#include "ui_widget.h"

void Widget::reg_link() {
    ui->stackedWidget->setCurrentIndex(2);
}

void Widget::registration() {

    QString username = ui->r_login_edit->text();
    QString password = ui->r_password_edit->text();
    QString code = ui->r_code_edit->text();
    int role = ui->r_box_role->currentIndex();


    if (username.isEmpty() || password.isEmpty()) {
        ui->r_wdata_label->show();
        return;
    }



    {
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", "superuser_connection");
        bool status = start_db_superuser(db);
        QSqlQuery query = QSqlQuery(db);
        qDebug() << status;
        if (status) {
            qDebug() << "status open\n";



            switch(role) {
                case 0:
                    query.exec("SELECT * FROM strong_insert(\'" + username + "\', \'" + password + "\', \'user_1\');");
                    qDebug() << "student added\n";
                    break;
                case 1:
                    if (code == "1234") {
                        query.exec("SELECT * FROM strong_insert(\'" + username + "\', \'" + password + "\', \'teacher\');");
                        qDebug() << "teacher added\n";
                    } else {
                        ui->r_wcode_label->show();
                    }
                    break;
                case 2:
                    if (code == "4321") {
                        qDebug() << db.isOpen();
                        query.exec("SELECT * FROM strong_insert(\'" + username + "\', \'" + password + "\', \'admin\');");
                    } else {
                        ui->r_wcode_label->show();
                    }
                    break;
            }
        }
    }

    close_db("superuser_connection");


//query.exec("SELECT * FROM strong_insert(\'" + username + "\', \'" + password + "\', \'" + roles[ui->r_box_role->currentIndex()] + "\');");

}

void Widget::box_changed() {
    switch(ui->r_box_role->currentIndex()) {
        case 0:
            ui->r_code_label_admin->hide();
            ui->r_code_label_teacher->hide();
            ui->r_code_edit->hide();
            break;
        case 1:
            ui->r_code_label_admin->hide();
            ui->r_code_label_teacher->show();
            ui->r_code_edit->show();
            break;
        case 2:
            ui->r_code_label_admin->show();
            ui->r_code_label_teacher->hide();
            ui->r_code_edit->show();
            break;
    }
}

bool Widget::start_db_superuser(QSqlDatabase db) {
    db.setHostName("localhost");
    db.setDatabaseName("curse_ach");
    db.setUserName("postgres");
    db.setPassword("forstudy");
    return db.open();
}
