// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mkb_technology/helper/view_manager.dart';
import 'package:mkb_technology/models/datasource/check_list/datasource_check.dart';
import 'package:mkb_technology/view/admin/screens/main/components/side_menu.dart';
import 'add_json.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:path/path.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:pdf/pdf.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

TextInputFormatter getInputFormatter(bool isNumericKeyBoard) {
  if (isNumericKeyBoard) {
    return FilteringTextInputFormatter.allow(RegExp('[0-9]'));
  } else {
    return FilteringTextInputFormatter.allow(
        RegExp('[^"\']*[^\'\"`]', unicode: true));
  }
}

class _TransactionViewState extends State<TransactionView> {
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> listMap = [];
  late ListJsonDatasource _listJsonDatasource;
  final List<ListJson> _viewSource = [];
  late DataGridController _dataGridController;
  final controller = TextEditingController();
  FToast fToast = FToast();
  List<List<String>> result = [];
  bool allowEdit = false;
  final Excel excel = Excel.createExcel();

  late File jsonFile;
  late Directory dir;
  String fileName = "data.json";
  bool fileExists = false;
  List<dynamic> listData = [];
  // List<String> rowdetail = [];

  void getView() async {
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File("${dir.path}/$fileName");
      fileExists = jsonFile.existsSync();
      print(jsonFile);
      if (fileExists) {
        setState(() {
          listData = jsonDecode(jsonFile.readAsStringSync());
          print(listData);
          for (int index = 0; index < listData.length; index++) {
            ListJson a = ListJson(
              code: listData[index]["code"],
              quantity: listData[index]["quantity"],
              idMfrPart: listData[index]["idMfrPart"],
              mfrPartName: listData[index]["mfrPartName"],
              idBrand: listData[index]["idBrand"],
              brandName: listData[index]["brandName"],
              description: listData[index]["description"],
              idMkbPart: listData[index]["idMkbPart"],
            );
            _viewSource.add(a);
          }
          _listJsonDatasource = ListJsonDatasource(_viewSource);
          _dataGridController = DataGridController();
        });
      }
    });
  }

  // Future<void> printView() async {
  //   List<Map<String, dynamic>> listSlide = await ViewHelper.getData();
  //   setState(() {
  //     result = convertToListOfLists(listSlide);
  //     dataList = listSlide;
  //   });
  //   final cellStyle = pw.TextStyle(
  //       font: pw.Font.ttf(await rootBundle.load('assets/fonts/times.ttf')));
  //   final List<dynamic> header = [
  //     'ID',
  //     'Name',
  //     'Price',
  //     'ImportPrice',
  //     'UnitName',
  //     'Pad',
  //     'BasicSupplies',
  //     'Pin',
  //     'Choose',
  //     'Link',
  //     'brandName',
  //     'description',
  //     'mfrPartName',
  //     'reel',
  //     'packagePartName'
  //   ];
  //   final rows = <List<dynamic>>[
  //     ...dataList.map((row) {
  //       return [
  //         row['idMkbPart'].toString(),
  //         row['mkbPartName'],
  //         row['price'].toString(), // Store the image path for later use
  //         row['importPrice'].toString(),
  //         row['unitName'].toString(),
  //         row['pad'].toString(),
  //         row['basicSupplies'].toString(),
  //         row['packagePartPin'],
  //         row['choose'].toString(),
  //         row['link'].toString(),
  //         row['brandName'].toString(),
  //         row['description'].toString(),
  //         row['mfrPartName'].toString(),
  //         row['reel'].toString(),
  //         row['packagePartName'].toString(),
  //       ];
  //     }),
  //   ];
  //   List<List<dynamic>> combinedList = [header, ...rows];
  //   final doc = pw.Document();
  //   doc.addPage(pw.Page(
  //       pageFormat: PdfPageFormat.a4,
  //       orientation: pw.PageOrientation.landscape,
  //       build: (pw.Context context) {
  //         return pw.Center(
  //           // ignore: deprecated_member_use
  //           child: pw.Table.fromTextArray(
  //               context: context, cellStyle: cellStyle, data: combinedList),
  //         );
  //       }));
  //   await Printing.layoutPdf(
  //       onLayout: (PdfPageFormat format) async => doc.save());
  // }

  // Future<void> exportPDF() async {
  //   List<Map<String, dynamic>> listSlide = await ViewHelper.getData();
  //   setState(() {
  //     result = convertToListOfLists(listSlide);
  //     dataList = listSlide;
  //   });
  //   final cellStyle = pw.TextStyle(
  //       font: pw.Font.ttf(await rootBundle.load('assets/fonts/times.ttf')));
  //   final List<dynamic> header = [
  //     'ID',
  //     'Name',
  //     'Price',
  //     'ImportPrice',
  //     'UnitName',
  //     'Pad',
  //     'BasicSupplies',
  //     'Pin',
  //     'Choose',
  //     'Link',
  //     'brandName',
  //     'description',
  //     'mfrPartName',
  //     'reel',
  //     'packagePartName'
  //   ];
  //   final rows = <List<dynamic>>[
  //     ...dataList.map((row) {
  //       return [
  //         row['idMkbPart'].toString(),
  //         row['mkbPartName'],
  //         row['price'].toString(), // Store the image path for later use
  //         row['importPrice'].toString(),
  //         row['unitName'].toString(),
  //         row['pad'].toString(),
  //         row['basicSupplies'].toString(),
  //         row['packagePartPin'],
  //         row['choose'].toString(),
  //         row['link'].toString(),
  //         row['brandName'].toString(),
  //         row['description'].toString(),
  //         row['mfrPartName'].toString(),
  //         row['reel'].toString(),
  //         row['packagePartName'].toString(),
  //       ];
  //     }),
  //   ];
  //   List<List<dynamic>> combinedList = [header, ...rows];
  //   final pdf = pw.Document();
  //   pdf.addPage(
  //     pw.Page(
  //       orientation: pw.PageOrientation.landscape,
  //       build: (context) {
  //         return pw.Center(
  //           // ignore: deprecated_member_use
  //           child: pw.Table.fromTextArray(
  //               context: context, cellStyle: cellStyle, data: combinedList),
  //         );
  //       },
  //     ),
  //   );
  //   final Directory directory =
  //       await getApplicationDocumentsDirectory(); // lấy link file lưu trữ tài liệu của máy
  //   final String filePath = '${directory.path}/ViewManager.pdf';
  //   final File file = File(filePath);
  //   await file
  //     ..createSync(recursive: true)
  //     ..writeAsBytes(await pdf.save()); // ghi file
  // }

  List<List<String>> convertToListOfLists(
      List<Map<String, dynamic>> inputList) {
    result.clear();
    result.add([
      'code',
      'quantity',
      'idMfrPart',
      'mfrPartName',
      'idBrand',
      'brandName',
      'description',
    ]);

    for (var map in inputList) {
      result.add([
        map['code'].toString(),
        map['quantity'].toString(),
        map['idMfrPart'].toString(),
        map['mfrPartName'].toString(),
        map['idBrand'].toString(),
        map['brandName'].toString(),
        map['description'].toString(),
      ]);
    }
    return result;
  }

  void exportToExcel() async {
    Sheet sheetObject = excel['Transaction'];
    excel.delete('Sheet1');
    final CellStyle headerStyle = CellStyle(
      // khai báo kiểu ô dữ liệu
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      backgroundColorHex: "#ffff00",
    );
    final CellStyle styleData = CellStyle(
        // khai báo kiểu ô dữ liệu
        verticalAlign: VerticalAlign.Center,
        horizontalAlign: HorizontalAlign.Center
        // backgroundColorHex: "#f0f0f0
        );
    for (var row in result) {
      //result là biến bên trên, lưu trữ list data để hiển thị ra excel
      sheetObject.appendRow(row); //add thêm từng hàng vô file
    }
    List column = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
    ];
    for (var data in column) {
      var cell = sheetObject
          .cell(CellIndex.indexByString("${data}1")); // lấy địa chỉ ô
      cell.cellStyle = headerStyle; // gán kiểu style cho ô
    }
    for (var data in column) {
      for (int i = 2; i <= result.length; i++) {
        var cell = sheetObject
            .cell(CellIndex.indexByString("$data$i")); // lấy địa chỉ ô
        cell.cellStyle = styleData;
      }
    }
    for (int columnIndex = 1; columnIndex < result[1].length; columnIndex++) {
      sheetObject.setColAutoFit(columnIndex); // Auto fit the column width
    }

    if (Platform.isAndroid || Platform.isWindows || Platform.isIOS) {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/JsonTransaction.xlsx';
      print(filePath);

      final List<int>? excelBytes = excel.encode();

      File(filePath)
        ..createSync(
            recursive:
                true) // nếu nó chưa tồn tại cái file tên là ViewManager thì tạo ra
        ..writeAsBytesSync(excelBytes!); // còn ko thì sẽ ghi đè lên
    } else {}
  }

  void searchView(var nameorid) async {
    for (int index = 0; index < _viewSource.length; index++) {
      _listJsonDatasource.dataGridRows.removeAt(0);
      _listJsonDatasource.updateDataGridSource();
    }
    while (_viewSource.isNotEmpty) {
      _viewSource.removeAt(0);
    }
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File("${dir.path}/$fileName");
      fileExists = jsonFile.existsSync();
      print(jsonFile);
      if (fileExists) {
        setState(() {
          listData = jsonDecode(jsonFile.readAsStringSync());
          print(listData);
          for (int index = 0; index < listData.length; index++) {
            if (listData[index]['code'].toString().contains(nameorid) ||
                listData[index]['mfrPartName'].toString().contains(nameorid) ||
                listData[index]['idMkbPart'].toString().contains(nameorid)) {
              ListJson a = ListJson(
                code: listData[index]["code"],
                quantity: listData[index]["quantity"],
                idMfrPart: listData[index]["idMfrPart"],
                mfrPartName: listData[index]["mfrPartName"],
                idBrand: listData[index]["idBrand"],
                brandName: listData[index]["brandName"],
                description: listData[index]["description"],
                idMkbPart: listData[index]["idMkbPart"],
              );
              _viewSource.add(a);
            }
          }
          setState(() {
            _listJsonDatasource = ListJsonDatasource(_viewSource);
            _dataGridController = DataGridController();
          });
        });
      }
    });
  }

  @override
  void initState() {
    getView();
    fToast.init(context);
    super.initState();
    _listJsonDatasource = ListJsonDatasource(_viewSource);
    _dataGridController = DataGridController();
  }

  @override
  void dispose() {
    _listJsonDatasource.dispose();
    _dataGridController.dispose();
    //dataList.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 230, 199, 123),
        appBar: AppBar(
          title:
              const Text('Transaction', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
          leading: Builder(
              builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ))),
        ),
        drawer: const SideMenu(isCase: 5),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 100,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.blue)),
                    onPressed: () {
                      showDialog(
                          //barrierColor: Color.fromARGB(255, 230, 199, 123),
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: const Text(
                                  'Option !!!',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.white38,
                                content: const Text('Choose your option: ',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                                actions: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    //spacing: 20,
                                    children: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateColor
                                                      .resolveWith((states) =>
                                                          Colors.blue)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              allowEdit == true
                                                  ? allowEdit = false
                                                  : allowEdit = true;
                                            });
                                          },
                                          child: const SizedBox(
                                              width: 110,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text("Enable editing",
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ],
                                              ))),
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateColor
                                                      .resolveWith((states) =>
                                                          Colors.blue)),
                                          onPressed: () {
                                            // convertToListOfLists(_viewsource)
                                            // exportToExcel();
                                            // Navigator.of(context).pop();
                                          },
                                          child: const SizedBox(
                                              width: 110,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text("Export Excel",
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ],
                                              ))),
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateColor
                                                      .resolveWith((states) =>
                                                          Colors.blue)),
                                          child: const SizedBox(
                                              width: 110,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text('Export To Pdf',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ],
                                              )),
                                          onPressed: () {
                                            // exportPDF();
                                            // Navigator.of(context).pop();
                                          }),
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateColor
                                                      .resolveWith((states) =>
                                                          Colors.blue)),
                                          child: const SizedBox(
                                              width: 110,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text('Print to Pdf',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ],
                                              )),
                                          onPressed: () {
                                            // printView();
                                          }),
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                      ),
                                      // ElevatedButton(
                                      //   style: ButtonStyle(
                                      //       backgroundColor:
                                      //           MaterialStateColor.resolveWith(
                                      //               (states) => Colors.red)),
                                      //   onPressed: () {
                                      //     List<String> column = [
                                      //       'idMkbPart',
                                      //       'mkbPartName',
                                      //       'packagePartPin',
                                      //       'unitName',
                                      //       'pad',
                                      //       'basicSupplies',
                                      //       'price',
                                      //       'importPrice',
                                      //       'choose',
                                      //       'link',
                                      //       'brandName',
                                      //       'description',
                                      //       'mfrPartName',
                                      //       'reel',
                                      //       'packagePartName'
                                      //     ];
                                      //     showDialog(
                                      //       context: context,
                                      //       builder: (context) =>
                                      //           CheckBoxDialog(
                                      //               column, visiblity),
                                      //     ).then((value) {
                                      //       if (value != null) {
                                      //         setState(() {
                                      //           visiblity = value;
                                      //         });
                                      //       }
                                      //     });
                                      //   },
                                      //   child: const SizedBox(
                                      //     width: 230,
                                      //     child: Row(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.center,
                                      //       children: [
                                      //         Text("Choose Column Display",
                                      //             style: TextStyle(
                                      //                 color: Colors.white)),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ]);
                          });
                    },
                    child: const SizedBox(
                        width: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.settings,
                              size: 18,
                              color: Colors.white,
                            )
                          ],
                        ))),
                const SizedBox(width: 20),
                SizedBox(
                  width: 200,
                  height: 30,
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 12),
                    controller: controller,
                    inputFormatters: [getInputFormatter(false)],
                    onChanged: (value) {
                      searchView(controller.text);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .red), // Màu của viền khi không được focus
                      ),
                      contentPadding: EdgeInsets.only(bottom: 3),
                      hintText: "Search",
                      hintStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            if (_listJsonDatasource.rows.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width < 1000
                        ? MediaQuery.of(context).size.width - 100
                        : 800,
                    child: SfDataGrid(
                      source: _listJsonDatasource,
                      rowHeight: 16,
                      swipeMaxOffset: 100.0,
                      allowEditing: allowEdit,
                      frozenRowsCount: 0,
                      selectionMode: SelectionMode.single,
                      navigationMode: GridNavigationMode.cell,
                      isScrollbarAlwaysShown: true,
                      controller: _dataGridController,
                      columns: [
                        GridColumn(
                          width: 80,
                          columnName: 'code',
                          label: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            alignment: Alignment.center,
                            child: const Text('Code',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        GridColumn(
                          width: 60,
                          columnName: 'quantity',
                          label: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            alignment: Alignment.center,
                            child: const Text(
                              'Quantity',
                              style: TextStyle(color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        GridColumn(
                          width: 60,
                          columnName: 'idMfrPart',
                          label: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'ID MFR',
                              style: TextStyle(color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        GridColumn(
                          width: 150,
                          columnName: 'mfrPartName',
                          label: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'MFR Name',
                              style: TextStyle(color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        GridColumn(
                          width: 100,
                          columnName: 'idBrand',
                          label: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'ID Brand',
                              style: TextStyle(color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        GridColumn(
                          width: 120,
                          columnName: 'brandName',
                          label: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'Brand Name',
                              style: TextStyle(color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        GridColumn(
                          width: 150,
                          columnName: 'description',
                          label: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'Description',
                              style: TextStyle(color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        GridColumn(
                          width: 80,
                          columnName: 'idMkbPart',
                          label: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'ID MKB',
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
          ]),
        ));
  }
}
