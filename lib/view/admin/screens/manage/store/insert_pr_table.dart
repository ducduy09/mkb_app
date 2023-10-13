// ignore_for_file: avoid_print

import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mkb_technology/helper/products.dart';
import 'package:mkb_technology/models/datasource/product/datasource_product.dart';
import 'package:mkb_technology/models/products.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// ignore: must_be_immutable
class InsertPrTable extends StatefulWidget {
  const InsertPrTable({super.key});

  @override
  State<InsertPrTable> createState() => _InsertPrTableState();
}

class _InsertPrTableState extends State<InsertPrTable> {
  List<Map<String, dynamic>> dataList = [];
  late ProductDataSource _productsDataSource;
  final List<Products> _products = <Products>[];
  late DataGridController _dataGridController;
  final Excel excel = Excel.createExcel();
  List<Map<String, dynamic>> result = [];

  @override
  void initState() {
    // getProduct();
    super.initState();
    _productsDataSource = ProductDataSource(_products);
    _dataGridController = DataGridController();
  }

  @override
  void dispose() {
    _productsDataSource.dispose();
    _dataGridController.dispose();
    super.dispose();
  }

  void addProduct(List<Map<String, dynamic>> list) {
    setState(() {
    for (int index = 0; index < list.length; index++) {
      Products a = Products(
        productId: list[index]["productId"],
        productName: list[index]["productName"],
        productImage: list[index]["productImage"],
        price: list[index]["price"],
        sale: list[index]["sale"],
        prSale: list[index]["prSale"],
        quantity: list[index]["quantity"],
        quantityTemp: list[index]["quantityTemp"],
      );
      print(a);
      _products.add(a);
      _productsDataSource.dataGridRows.insert(
          0,
          DataGridRow(cells: [
            DataGridCell(value: _products[index].productId, columnName: 'productId'),
            DataGridCell(value: _products[index].productName, columnName: 'productName'),
            DataGridCell(value: _products[index].productImage, columnName: 'productImage'),
            DataGridCell(value: _products[index].price, columnName: 'price'),
            DataGridCell(value: _products[index].quantity, columnName: 'quantity'),
            DataGridCell(value: _products[index].sale, columnName: 'sale'),
            DataGridCell(value: _products[index].prSale, columnName: 'prSale'),
            DataGridCell(value: _products[index].quantityTemp, columnName: 'quantityTemp')
          ]));
    }
    }); 
  }

  Future<void> importExcelFile() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );
    excelData.clear();
    if (pickedFile != null) {
      String link = pickedFile.paths.toString();
      link = link.replaceAll("[", "");
      link = link.replaceAll("]", "");
      var bytes = File(link).readAsBytesSync();
      if (bytes.isNotEmpty) {
        var excel = Excel.decodeBytes(bytes);
        for (var table in excel.tables.keys) {
          for (var row in excel.tables[table]!.rows) {
            excelData.add(row.map((cell) => cell!.value.toString()).toList());
          }
        }
        excelData.removeAt(0);
        print(excelData);
      }
      for (int i = 1; i < excelData.length; i++) {
        int sale = (double.parse(excelData[i][5]) * 100).round();
        Map<String, dynamic> map = {
          'productId': excelData[i][0],
          'productName': excelData[i][1],
          'productImage': excelData[i][2],
          'quantity': int.parse(excelData[i][3].toString()),
          'price': int.parse(excelData[i][4].toString()),
          'sale': "$sale%",
          'prSale': int.parse(excelData[i][6].toString()),
          'quantityTemp': int.parse(excelData[i][7].toString()),
        };
        result.add(map);
      }
    }
  }

  List<List<String>> excelData = [];

  // List<Map<String, dynamic>> convertToMapList(List<List<String>> inputList) {
  //   // convert from list to listMap
  //   List<Map<String, dynamic>> result = [];
  //   for (int i = 1; i < inputList.length; i++) {
  //     Map<String, dynamic> map = {
  //       'productId': inputList[i][0],
  //       'productName': inputList[i][1],
  //       'productImage': inputList[i][2],
  //       'quantity': int.parse(inputList[i][3].toString()),
  //       'price': int.parse(inputList[i][4].toString()),
  //       'sale': inputList[i][5].toString(),
  //       'prSale': int.parse(inputList[i][6].toString()),
  //       'quantityTemp': int.parse(inputList[i][7].toString()),
  //     };
  //     result.add(map);
  //   }
  //   return result;
  // }

  void exportTemplate() async {
    Sheet sheetObject = excel['Sheet1'];

    List<List<String>> data = [
      [
        'ProductId',
        'ProductName',
        'Image',
        'Price',
        'Quantity',
        'Sale',
        'PrSale',
        'QuantityTemp'
      ],
    ];
    final CellStyle headerStyle = CellStyle(
      // khai báo kiểu ô dữ liệu
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      backgroundColorHex: "#ffff00",
    );
    for (var row in data) {
      sheetObject.appendRow(row);
    }
    List column = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    for (var data in column) {
      var cell = sheetObject
          .cell(CellIndex.indexByString("${data}1")); // lấy địa chỉ ô
      cell.cellStyle = headerStyle; // gán kiểu style cho ô
    }
    for (int columnIndex = 1; columnIndex < data[0].length; columnIndex++) {
      sheetObject.setColAutoFit(columnIndex); // Auto fit the column width
    }
    if (Platform.isAndroid || Platform.isWindows || Platform.isIOS) {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath =
          '${directory.path}/templateInputData_Product.xlsx';
      print(filePath);

      final List<int>? excelBytes = excel.encode();

      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(excelBytes!);
    } else {}
  }

  // void removeProducts(List<Products> products, String id) {
  //   products.removeWhere((product) => product.productId == id);
  // }

  String isID = "";

  Future<String> getLastProduct(String id) async {
    List<Map<String, dynamic>> updateData = await ProductHelper.getLastID(id);
    dataList = updateData;
    int? number = 0;
    try {
      print(dataList);
      if (dataList.isEmpty) {
        number = 1;
        print(number);
      } else {
        String id = dataList[0]["productId"];
        String kitu = id.substring(id.length - 4);
        number = int.tryParse(kitu);
        if (number != null) {
          number++;
          print(number);
        } else {
          kitu = id.substring(id.length - 3);
          number = int.tryParse(kitu);
          if (number != null) {
            number++;
            print(number);
          } else {
            kitu = id.substring(id.length - 2);
            number = int.tryParse(kitu);
            if (number != null) {
              number++;
              print("So $number");
            } else {
              kitu = id.substring(id.length - 1);
              number = int.parse(kitu);
              number++;
              print(number);
            }
          }
        }
      }
    } catch (e) {
      // Xử lý ngoại lệ ở đây
      print('Đã xảy ra một ngoại lệ: $e');
    }

    setState(() {
      isID = id + number.toString();
    });
    print("ID test: $isID");
    return isID;
  }

  String setNextId(String id, int len, String type) {
    String kitu = id.substring(id.length - 4);
    int? number = int.tryParse(kitu);
    if (number != null) {
      number++;
      print(number);
    } else {
      kitu = id.substring(id.length - 3);
      number = int.tryParse(kitu);
      if (number != null) {
        number++;
        print(number);
      } else {
        kitu = id.substring(id.length - 2);
        number = int.tryParse(kitu);
        if (number != null) {
          number++;
          print("So $number");
        } else {
          kitu = id.substring(id.length - 1);
          number = int.parse(kitu);
          number++;
          print(number);
        }
      }
    }
    print("Ngat dong: $number");
    setState(() {
      len = int.parse(number.toString()) + len - 1;
      print(len);
      isID = type + len.toString();
    });
    return isID;
  }

  int countA = 0;
  int countB = 0;
  int countC = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
          title: const Text('Insert Product',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateColor.resolveWith((states) => Colors.blue),
                    iconColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Warning !!!'),
                        backgroundColor: Colors.white38,
                        content: const Text('Product Id ?'),
                        actions: [
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.blue)),
                            onPressed: () {
                              //int length = _productsDataSource.dataGridRows.length;
                              print("Độ dài là :$countA");
                              getLastProduct("prdA").then((value) {
                                if (countA == 0) {
                                  Products a = Products(
                                      productId: value,
                                      productName: "",
                                      productImage: "",
                                      price: 0,
                                      sale: "",
                                      prSale: 0,
                                      quantity: 0,
                                      quantityTemp: 0);
                                  _products.add(a);
                                  _productsDataSource.dataGridRows.insert(
                                      0,
                                      DataGridRow(cells: [
                                        DataGridCell(
                                            value: value,
                                            columnName: 'productId'),
                                        const DataGridCell(
                                            value: "",
                                            columnName: 'productName'),
                                        const DataGridCell(
                                            value: "",
                                            columnName: 'productImage'),
                                        const DataGridCell(
                                            value: "", columnName: 'price'),
                                        const DataGridCell(
                                            value: "", columnName: 'quantity'),
                                        const DataGridCell(
                                            value: "", columnName: 'sale'),
                                        const DataGridCell(
                                            value: "", columnName: 'prSale'),
                                        const DataGridCell(
                                            value: "",
                                            columnName: 'quantityTemp')
                                      ]));
                                } else {
                                  setNextId(value, countA, "prdA");
                                  print(isID);
                                  Products a = Products(
                                      productId: isID,
                                      productName: "",
                                      productImage: "",
                                      price: 0,
                                      sale: "",
                                      prSale: 0,
                                      quantity: 0,
                                      quantityTemp: 0);
                                  _products.add(a);
                                  _productsDataSource.dataGridRows.insert(
                                      0,
                                      DataGridRow(cells: [
                                        DataGridCell(
                                            value: isID,
                                            columnName: 'productId'),
                                        const DataGridCell(
                                            value: "",
                                            columnName: 'productName'),
                                        const DataGridCell(
                                            value: "",
                                            columnName: 'productImage'),
                                        const DataGridCell(
                                            value: 0, columnName: 'price'),
                                        const DataGridCell(
                                            value: 0, columnName: 'quantity'),
                                        const DataGridCell(
                                            value: "0%", columnName: 'sale'),
                                        const DataGridCell(
                                            value: 0, columnName: 'prSale'),
                                        const DataGridCell(
                                            value: 0,
                                            columnName: 'quantityTemp')
                                      ]));
                                }

                                //_productsDataSource.dataGridRows.remove(_products.length-1);
                                print(_products.length);
                                //print(_products.first);
                                _productsDataSource.updateDataGridSource();
                                setState(() {
                                  countA++;
                                });
                              });
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'A',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.blue),
                            ),
                            onPressed: () {
                              //int length = _productsDataSource.dataGridRows.length;
                              print("Độ dài là :$countB");
                              getLastProduct("prdB").then((value) {
                                if (countB == 0) {
                                  Products b = Products(
                                      productId: value,
                                      productName: "",
                                      productImage: "",
                                      price: 0,
                                      sale: "",
                                      prSale: 0,
                                      quantity: 0,
                                      quantityTemp: 0);
                                  _products.add(b);
                                  _productsDataSource.dataGridRows.insert(
                                      0,
                                      DataGridRow(cells: [
                                        DataGridCell(
                                            value: value,
                                            columnName: 'productId'),
                                        const DataGridCell(
                                            value: "",
                                            columnName: 'productName'),
                                        const DataGridCell(
                                            value: "",
                                            columnName: 'productImage'),
                                        const DataGridCell(
                                            value: "", columnName: 'price'),
                                        const DataGridCell(
                                            value: "", columnName: 'quantity'),
                                        const DataGridCell(
                                            value: "", columnName: 'sale'),
                                        const DataGridCell(
                                            value: "", columnName: 'prSale'),
                                        const DataGridCell(
                                            value: "",
                                            columnName: 'quantityTemp')
                                      ]));
                                } else {
                                  setNextId(value, countB, "prdB");
                                  print(isID);
                                  Products b = Products(
                                      productId: isID,
                                      productName: "",
                                      productImage: "",
                                      price: 0,
                                      sale: "",
                                      prSale: 0,
                                      quantity: 0,
                                      quantityTemp: 0);
                                  _products.add(b);
                                  _productsDataSource.dataGridRows.insert(
                                      0,
                                      DataGridRow(cells: [
                                        DataGridCell(
                                            value: isID,
                                            columnName: 'productId'),
                                        const DataGridCell(
                                            value: "",
                                            columnName: 'productName'),
                                        const DataGridCell(
                                            value: "",
                                            columnName: 'productImage'),
                                        const DataGridCell(
                                            value: 0, columnName: 'price'),
                                        const DataGridCell(
                                            value: 0, columnName: 'quantity'),
                                        const DataGridCell(
                                            value: "0%", columnName: 'sale'),
                                        const DataGridCell(
                                            value: 0, columnName: 'prSale'),
                                        const DataGridCell(
                                            value: 0,
                                            columnName: 'quantityTemp')
                                      ]));
                                }

                                //_productsDataSource.dataGridRows.remove(_products.length-1);
                                print(_products.length);
                                //print(_products.first);
                                _productsDataSource.updateDataGridSource();
                                setState(() {
                                  countB++;
                                });
                              });
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'B',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.blue),
                            ),
                            onPressed: () {
                              //int length = _productsDataSource.dataGridRows.length;
                              print("Độ dài là :$countC");
                              getLastProduct("prdC").then((value) {
                                if (countC == 0) {
                                  Products c = Products(
                                      productId: value,
                                      productName: "",
                                      productImage: "",
                                      price: 0,
                                      sale: "",
                                      prSale: 0,
                                      quantity: 0,
                                      quantityTemp: 0);
                                  _products.add(c);
                                  _productsDataSource.dataGridRows.insert(
                                      0,
                                      DataGridRow(cells: [
                                        DataGridCell(
                                            value: value,
                                            columnName: 'productId'),
                                        const DataGridCell(
                                            value: "",
                                            columnName: 'productName'),
                                        const DataGridCell(
                                            value: "",
                                            columnName: 'productImage'),
                                        const DataGridCell(
                                            value: "", columnName: 'price'),
                                        const DataGridCell(
                                            value: "", columnName: 'quantity'),
                                        const DataGridCell(
                                            value: "", columnName: 'sale'),
                                        const DataGridCell(
                                            value: "", columnName: 'prSale'),
                                        const DataGridCell(
                                            value: "",
                                            columnName: 'quantityTemp')
                                      ]));
                                } else {
                                  setNextId(value, countC, "prdC");
                                  print(isID);
                                  Products c = Products(
                                      productId: isID,
                                      productName: "",
                                      productImage: "",
                                      price: 0,
                                      sale: "",
                                      prSale: 0,
                                      quantity: 0,
                                      quantityTemp: 0);
                                  _products.add(c);
                                  _productsDataSource.dataGridRows.insert(
                                      0,
                                      DataGridRow(cells: [
                                        DataGridCell(
                                            value: isID,
                                            columnName: 'productId'),
                                        const DataGridCell(
                                            value: "",
                                            columnName: 'productName'),
                                        const DataGridCell(
                                            value: "",
                                            columnName: 'productImage'),
                                        const DataGridCell(
                                            value: 0, columnName: 'price'),
                                        const DataGridCell(
                                            value: 0, columnName: 'quantity'),
                                        const DataGridCell(
                                            value: "0%", columnName: 'sale'),
                                        const DataGridCell(
                                            value: 0, columnName: 'prSale'),
                                        const DataGridCell(
                                            value: 0,
                                            columnName: 'quantityTemp')
                                      ]));
                                }
                                //_productsDataSource.dataGridRows.remove(_products.length-1);
                                print(_products.length);
                                //print(_products.first);
                                _productsDataSource.updateDataGridSource();
                                setState(() {
                                  countC++;
                                });
                              });
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'C',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(Icons.add)),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width < 1000
                      ? MediaQuery.of(context).size.width - 100
                      : 900,
                  child: SfDataGrid(
                    endSwipeActionsBuilder:
                        (BuildContext context, DataGridRow row, int rowIndex) {
                      return GestureDetector(
                          onTap: () {
                            _productsDataSource.dataGridRows.removeAt(rowIndex);
                            _productsDataSource.updateDataGridSource();
                          },
                          child: Container(
                              color: Colors.redAccent,
                              child: const Center(
                                child: Icon(Icons.delete),
                              )));
                    },
                    source: _productsDataSource,
                    allowEditing: true,
                    allowSwiping: true,
                    swipeMaxOffset: 100.0,
                    frozenRowsCount: 0,
                    selectionMode: SelectionMode.single,
                    navigationMode: GridNavigationMode.cell,
                    //columnWidthMode: ColumnWidthMode.fill,
                    controller: _dataGridController,
                    columns: <GridColumn>[
                      GridColumn(
                        width: 100,
                        allowEditing: false,
                        columnName: 'productId',
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: const Text('ID',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      GridColumn(
                        width: 200,
                        columnName: 'productName',
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'Name',
                            style: TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        width: 150,
                        columnName: 'productImage',
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'Image',
                            style: TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'price',
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'Price',
                            style: TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'quantity',
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'Quantity',
                            style: TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'sale',
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'Sale',
                            style: TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'prSale',
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'PrSale',
                            style: TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        width: 0,
                        visible: false,
                        columnName: 'quantityTemp',
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'Quantity Temp',
                            style: TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    countA = 0;
                    countB = 0;
                    countC = 0;
                    int xoa = _products.length;
                    print('do dai con lai: $xoa');
                    if (xoa > 0) {
                      for (int index = 0; index < _products.length; index++) {
                        print(_products[index].productId);
                        print(_products[index].productImage);
                        ProductHelper.insertProduct(
                            _products[index].productId,
                            _products[index].productName,
                            _products[index].productImage,
                            _products[index].price,
                            _products[index].quantity,
                            _products[index].sale,
                            int.parse(_products[index].prSale.toString()));
                        _productsDataSource.dataGridRows.removeAt(0);
                        _productsDataSource.updateDataGridSource();
                      }
                      while (_products.isNotEmpty) {
                        _products.removeAt(0);
                      }
                      setState(() {
                        int xoa = _products.length;
                        print('do dai con lai: $xoa');
                      });
                    } else {
                      print("het cai them r :v");
                    }
                  },
                  child: const Icon(Icons.save),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    exportTemplate();
                  },
                  child: const Icon(Icons.download),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    importExcelFile().then((value) => {
                          print(result),
                          addProduct(result),
                        });
                  },
                  child: const Icon(Icons.upload),
                ),
              ],
            )
          ]),
        ));
  }
}
