// ignore_for_file: avoid_print

import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:mkb_technology/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:image_picker/image_picker.dart';

dynamic newCellValue;
List<Map<String, dynamic>> imageProduct = [];

class ProductDataSource extends DataGridSource {
  ProductDataSource(this._products) {
    dataGridRows = _products
        .map<DataGridRow>((dataGridRow) => dataGridRow.getDataGridRow())
        .toList();
  }

  // ignore: prefer_final_fields
  List<Products> _products = [];

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
              style: const TextStyle(color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          );
      }
    }).toList());
  }

  List<Products> newProducts = [];
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
      case 'productId':
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<String>(columnName: 'productId', value: newCellValue);
        _products[dataRowIndex].productId = newCellValue.toString();
        break;
      case 'productName':
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<String>(
                columnName: 'productName', value: newCellValue);
        _products[dataRowIndex].productName = newCellValue.toString();
        break;
      case 'productImage':
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<String>(
                columnName: 'productImage', value: newCellValue);
        _products[dataRowIndex].productImage = newCellValue.toString();
        break;
      case 'quantity':
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<int>(columnName: 'quantity', value: newCellValue);
        _products[dataRowIndex].quantity = newCellValue as int;
        break;
      case 'sale':
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<String>(columnName: 'sale', value: newCellValue);
        _products[dataRowIndex].sale = newCellValue.toString();
        break;
      case 'prSale':
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<int>(columnName: 'prSale', value: newCellValue);
        _products[dataRowIndex].prSale = newCellValue as int;
        break;
      case 'price':
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<int>(columnName: 'price', value: newCellValue);
        _products[dataRowIndex].price = newCellValue as int;
        break;
      case 'quantityTemp':
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<int>(columnName: 'quantityTemp', value: newCellValue);
        _products[dataRowIndex].quantityTemp = newCellValue as int;
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
    final String nameColumn = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.columnName
            .toString() ??
        '';
    newCellValue = null;
    String imageLink = '';
    Future<void> getImageLink() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        if (pickedFile.path.contains(
            "E:\\Project_Flutter\\mkb_technology\\")) {
          imageLink = pickedFile.path.replaceAll("\\", "/");
          imageLink = imageLink.replaceFirst(
              "E:/Project_Flutter/mkb_technology/",
              "");
        } else {
          final pathImage = pickedFile.path;
          const pathGallery =
              '..\\mkb_technology\\assets\\images\\';
          final tenTapTinMoi = pickedFile.name;

          final tapTinCu = File(pathImage);
          final tapTinMoi = await tapTinCu.copy('$pathGallery$tenTapTinMoi');

          print('Đã sao chép tệp tin thành công: ${tapTinMoi.path}');

          imageLink = tapTinMoi.path.replaceAll("\\", "/");
          imageLink = imageLink.replaceFirst(
              "../mkb_technology/",
              "");
        }
      }
    }

    final bool isNumericType = column.columnName == 'quantity' ||
        column.columnName == 'price' ||
        column.columnName == 'prSale';

    // Holds regular expression pattern based on the column type.
    final RegExp regExp = _getRegExp(isNumericType, column.columnName);

    if (nameColumn != "productImage") {
      return Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment:
                isNumericType ? Alignment.centerRight : Alignment.centerLeft,
            child: TextField(
              autofocus: true,
              controller: editingController..text = displayText,
              textAlign: TextAlign.center,
              autocorrect: false,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
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
      );
    } else {
      return Wrap(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(3.0),
                child: 
                displayText != "" ?
                Image.asset(
                  displayText,
                  height: 40,
                ) : const Text(""),
              ),
              Container(
                alignment: isNumericType
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                width: 0.0,
                height: 0.0,
                child: TextField(
                  readOnly: true,
                  autofocus: true,
                  controller: editingController..text = displayText,
                  textAlign: TextAlign.center,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
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
          Container(
            padding: const EdgeInsets.only(top: 10.0, left: 10),
            child: TextButton.icon(
                onPressed: () {
                  getImageLink().then((value) {
                    if (imageLink.isNotEmpty) {
                      newCellValue = imageLink;
                    } else {
                      newCellValue = null;
                    }
                    submitCell();
                  });
                },
                icon: const Icon(Icons.edit),
                label: const Text("")),
          ),
        ],
      );
    }
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
