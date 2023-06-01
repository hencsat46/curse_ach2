#ifndef EDIT_TABLE_H
#define EDIT_TABLE_H

#include <QWidget>
#include <QSqlQueryModel>
#include <QStringListModel>

namespace Ui {
class Edit_table;
}

class Edit_table : public QWidget
{
    Q_OBJECT

public:
    explicit Edit_table(QWidget *parent = nullptr);
    ~Edit_table();
    void pass_table(QSqlQueryModel *table);
    Qt::ItemFlags flags(const QModelIndex &index) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole);

private:
    Ui::Edit_table *ui;

public slots:
    void close_table();
};

#endif // EDIT_TABLE_H
