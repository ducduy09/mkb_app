// ignore_for_file: avoid_print

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mkbmanager/model/view_manager.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

dynamic newCellValue;

class ListJsonDatasource extends DataGridSource {
  ListJsonDatasource(this._listJson) {
    dataGridRows = _listJson
        .map<DataGridRow>((dataGridRow) => dataGridRow.getDataGridRow())
        .toList();
  }
  // ignore: prefer_final_fields
  List<ListJson> _listJson = [];

  List<DataGridRow> dataGridRows = [];

  /// Helps to hold the new value of all editable widget.
  /// Based on the new value we will commit the new value into the corresponding
  /// [DataGridCell] on [onSubmitCell] method.

  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      switch (dataGridCell.columnName) {
        // case 'productImage':
        //   return PickerImage(link: dataGridCell.value);
        default:
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              dataGridCell.value.toString(),
              style: const TextStyle(color: Colors.black, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          );
      }
    }).toList());
  }

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value ??
        '';

    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }
    switch (column.columnName) {
      case 'code':
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<int>(columnName: 'code', value: newCellValue);
        _listJson[dataRowIndex].code = int.parse(newCellValue.toString());
        break;
      case 'quantity':
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<int>(columnName: 'quantity', value: newCellValue);
        _listJson[dataRowIndex].quantity = int.parse(newCellValue.toString());
        // CheckListHelper.updateData(_listJson[dataRowIndex].idCheckList, 1,
        //     idCustomer: int.parse(newCellValue.toString()));
        break;
      case 'idMfrPart':
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<int>(columnName: 'idMfrPart', value: newCellValue);
        _listJson[dataRowIndex].idMfrPart = int.parse(newCellValue.toString());
        // CheckListHelper.updateData(_listJson[dataRowIndex].idCheckList, 2,
        //     dateCheck: newCellValue.toString());
        break;
      case 'mfrPartName':
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<String>(
                columnName: 'mfrPartName', value: newCellValue);
        _listJson[dataRowIndex].mfrPartName = newCellValue.toString();
        // CheckListHelper.updateData(_listJson[dataRowIndex].idCheckList, 3,
        //     checker: newCellValue.toString());
        break;
      case 'idBrand':
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<int>(
                columnName: 'idBrand', value: newCellValue);
        _listJson[dataRowIndex].idBrand = int.parse(newCellValue.toString());
        // CheckListHelper.updateData(_listJson[dataRowIndex].idCheckList, 3,
        //     checker: newCellValue.toString());
        break;
      case 'brandName':
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<String>(
                columnName: 'brandName', value: newCellValue);
        _listJson[dataRowIndex].brandName = newCellValue.toString();
        // CheckListHelper.updateData(_listJson[dataRowIndex].idCheckList, 3,
        //     checker: newCellValue.toString());
        break;
      case 'description':
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<String>(
                columnName: 'description', value: newCellValue);
        _listJson[dataRowIndex].description = newCellValue.toString();
        // CheckListHelper.updateData(_listJson[dataRowIndex].idCheckList, 3,
        //     checker: newCellValue.toString());
        break;
      case 'idMkbPart':
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<int>(
                columnName: 'idMkbPart', value: newCellValue);
        _listJson[dataRowIndex].idMkbPart = int.parse(newCellValue.toString());
        // CheckListHelper.updateData(_listJson[dataRowIndex].idCheckList, 3,
        //     checker: newCellValue.toString());
        break;
    }
    notifyListeners();
  }

  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    // Return false, to retain in edit mode.
    return true; // or super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';
    newCellValue = null;

    final bool isNumericType = column.columnName == 'code' ||
        column.columnName == 'quantity' ||
        column.columnName == 'idBrand' || column.columnName == 'idMkbPart' ||
        column.columnName == 'idMfrPart';

    // Holds regular expression pattern based on the column type.
    final RegExp regExp = _getRegExp(isNumericType, column.columnName);

    return Wrap(
      children: [
        Row(
          children: [
            SizedBox(
              width: column.width,
              child: TextField(
                autofocus: true,
                controller: editingController..text = displayText,
                textAlign: TextAlign.center,
                autocorrect: false,
                style: const TextStyle(fontSize: 12),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 36),
                  border: InputBorder.none, // Không có border
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(regExp)
                ],
                keyboardType:
                    isNumericType ? TextInputType.number : TextInputType.text,
                onChanged: (String value) {
                  if (value.isNotEmpty) {
                    if (isNumericType) {
                      newCellValue = int.parse(value);
                    } else {
                      newCellValue = value;
                    }
                  } else {
                    newCellValue = null;
                  }
                },
                onSubmitted: (String value) {
                  /// Call [CellSubmit] callback to fire the canSubmitCell and
                  /// onCellSubmit to commit the new value in single place.
                  submitCell();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void updateDataGridSource() {
    notifyListeners();
  }

  RegExp _getRegExp(bool isNumericKeyBoard, String columnName) {
    return isNumericKeyBoard
        ? RegExp('[0-9 ]')
        : RegExp('[^"\']*[^\'\"]', unicode: true);
  }
}
