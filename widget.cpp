#include "widget.h"
#include "ui_widget.h"

Widget::Widget(QWidget *parent) : QWidget(parent), ui(new Ui::Widget) {
    ui->setupUi(this);
    connect(ui->w_show_db, SIGNAL(clicked()), this, SLOT(show_table()));
    connect(ui->sm_login_button, SIGNAL(clicked()), this, SLOT(login()));
    connect(ui->r_box_role, SIGNAL(currentIndexChanged(int)), this, SLOT(box_changed()));
    connect(ui->sm_reg_link, SIGNAL(clicked()), this, SLOT(reg_link()));
    connect(ui->r_auth_link, SIGNAL(clicked()), this, SLOT(auth_link()));
    connect(ui->r_registration_button, SIGNAL(clicked()), this, SLOT(registration()));
    QPalette palette = ui->r_code_label->palette();
    palette.setColor(ui->r_wcode_label->foregroundRole(), Qt::red);
    ui->r_wcode_label->setPalette(palette);
    ui->r_wcode_label->hide();




    qDebug() << this->ui->stackedWidget->currentIndex();

    if (ui->r_box_role->currentIndex() == 0) {
        ui->r_code_edit->hide();
        ui->r_code_label->hide();
    }

}

Widget::~Widget() {
    delete ui;
}



void Widget::show_table() {
    db = QSqlDatabase::addDatabase("QPSQL");
    db.setHostName("localhost");
    db.setDatabaseName("curse_ach");
    db.setUserName("postgres");
    db.setPassword("");

    QSqlQueryModel *sql_model = new QSqlQueryModel();
    bool status = db.open();
    if (status) sql_model->setQuery("SELECT * FROM show_archive();");
    this->ui->w_table->horizontalHeader()->setStretchLastSection(true);
    this->ui->w_table->setModel(sql_model);
    this->ui->w_table->resizeColumnsToContents();


}

void Widget::change_widget() {
    this->ui->stackedWidget->setCurrentIndex(1);
}

void Widget::login() {
    QString username = ui->sm_login_edit->text();
    QString password = ui->sm_password_edit->text();
    if (username == "ilya" && password == "") {
        ui->stackedWidget->setCurrentIndex(0);
    }
}

void Widget::box_changed() {
    if (ui->r_box_role->currentIndex() == 1) {
        ui->r_code_edit->show();
        ui->r_code_label->show();
    } else {
        ui->r_code_edit->hide();
        ui->r_code_label->hide();
    }
}



void Widget::auth_link() {
    ui->stackedWidget->setCurrentIndex(1);
}

void Widget::close_db() {
    {
        QSqlDatabase db = QSqlDatabase::database();
        db.close();
    }
    QSqlDatabase::removeDatabase(QSqlDatabase::defaultConnection);
    return;
}
