#include "edit_table.h"
#include "ui_edit_table.h"

Edit_table::Edit_table(QWidget *parent) : QWidget(parent), ui(new Ui::Edit_table) {
    ui->setupUi(this);
    connect(ui->e_quit_button, SIGNAL(clicked()), this, SLOT(close_table()));


}

void Edit_table::close_table() {
    this->close();
}

void Edit_table::pass_table(QSqlQueryModel* table) {
    this->ui->e_table->setModel(table);
    this->ui->e_table->setEditTriggers(QAbstractItemView::DoubleClicked);
    this->ui->e_table->horizontalHeader()->setStretchLastSection(true);
    this->ui->e_table->resizeColumnsToContents();

}

Qt::ItemFlags QStringListModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::ItemIsEnabled;

    return QAbstractItemModel::flags(index) | Qt::ItemIsEditable;
}

bool QStringListModel::setData(const QModelIndex &index,
                               const QVariant &value, int role)
{
    if (index.isValid() && role == Qt::EditRole) {

        stringList().replace(index.row(), value.toString());
        emit dataChanged(index, index);
        return true;
    }
    return false;
}




Edit_table::~Edit_table() {
    delete ui;
}
