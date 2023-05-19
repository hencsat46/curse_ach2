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
    connect(ui->w_disconnect_button, SIGNAL(clicked()), this, SLOT(db_disconnect()));
    set_color(ui->r_wcode_label, Qt::red);
    set_color(ui->r_wdata_label, Qt::red);
    set_color(ui->sm_wdata_label, Qt::red);
    ui->r_box_role->setCurrentIndex(0);
    ui->r_wcode_label->hide();
    ui->r_wdata_label->hide();
    ui->r_code_widget->hide();
    ui->sm_wdata_label->hide();
    ui->stackedWidget->setCurrentIndex(1);

}

Widget::~Widget() {
    delete ui;
}

void Widget::set_color(QLabel *local_label, QColor color) {
    QPalette palette = local_label->palette();
    palette.setColor(local_label->foregroundRole(), color);
    local_label->setPalette(palette);
}

void Widget::show_table() {

    QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", "user_connection");
    db.setHostName("localhost");
    db.setDatabaseName("curse_ach");
    db.setUserName(role);

    if (role == "user_1") db.setPassword("student");
    else db.setPassword(role);
    bool status = db.open();

    sql_model = new QSqlQueryModel();
    if (status) sql_model->setQuery("SELECT * FROM show_archive();", db);

    this->ui->w_table->horizontalHeader()->setStretchLastSection(true);
    this->ui->w_table->setModel(sql_model);
    this->ui->w_table->resizeColumnsToContents();

}

void Widget::db_disconnect() {
    if (sql_model != nullptr) {
        delete sql_model;
        sql_model = nullptr;
        close_db("user_connection");
        qDebug() << "connection closed\n";
    }
}

void Widget::close_db(QString connection_name) {
    {
        QSqlDatabase db = QSqlDatabase::database(connection_name);
        db.close();
    }
    QSqlDatabase::removeDatabase(connection_name);
    return;
}
