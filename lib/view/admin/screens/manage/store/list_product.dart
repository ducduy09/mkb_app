// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mkb_technology/helper/products.dart';
import 'package:mkb_technology/models/datasource/product/list_product.dart';
import 'package:mkb_technology/models/products.dart';
import 'package:mkb_technology/view/admin/screens/main/components/side_menu.dart';
import 'package:mkb_technology/view/admin/screens/manage/store/edit_pr_table.dart';
import 'package:mkb_technology/view/admin/screens/manage/store/insert_pr_form.dart';
import 'package:mkb_technology/view/admin/screens/manage/store/insert_pr_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:excel/excel.dart';
import 'package:pdf/widgets.dart' as pw;

// import 'package:path/path.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:pdf/pdf.dart';

class ListProduct extends StatefulWidget {
  const ListProduct({super.key});

  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  List<Map<String, dynamic>> dataList = [];
  late ProductDataSource _productsDataSource;
  final List<Products> _products = <Products>[];
  late DataGridController _dataGridController;
  final controller = TextEditingController();
  FToast fToast = FToast();
  List<List<String>> result = [];

  void getProduct() async {
    List<Map<String, dynamic>> listSlide = await ProductHelper.getData();
    setState(() {
      result = convertToListOfLists(listSlide);
      dataList = listSlide;
    });
    for (int index = 0; index < dataList.length; index++) {
      Products a = Products(
          productId: dataList[index]["productId"],
          productName: dataList[index]["productName"],
          productImage: dataList[index]["productImage"],
          price: dataList[index]["price"],
          sale: dataList[index]["sale"],
          prSale: dataList[index]["prSale"],
          quantity: dataList[index]["quantity"],
          quantityTemp: dataList[index]["quantityTemp"],
          status: dataList[index]["status"]);
      _products.add(a);
    }
    _productsDataSource = ProductDataSource(_products);
    _dataGridController = DataGridController();
  }

  Future<Uint8List> getImageBytesFromAssets(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  final Excel excel = Excel.createExcel();
  List<String> rowdetail = [];

  Future<void> exportPDF() async {
    List<Map<String, dynamic>> listSlide = await ProductHelper.getData();
    setState(() {
      result = convertToListOfLists(listSlide);
      dataList = listSlide;
    });
    final cellStyle = pw.TextStyle(
        font: pw.Font.ttf(await rootBundle.load('assets/fonts/times.ttf')));
    final List<dynamic> header = [
      'Product ID',
      'Product Name',
      'Product Image',
      'Price',
      'Quantity',
      'Sale',
      'PrSale',
      'Quantity Temp',
      'Status'
    ];
    final rows = <List<dynamic>>[
      ...dataList.map((row) {
        return [
          row['productId'],
          row['productName'],
          row['productImage'], // Store the image path for later use
          row['price'].toString(),
          row['quantity'].toString(),
          row['sale'],
          row['prSale'].toString(),
          row['quantityTemp'].toString(),
          row['status'].toString(),
        ];
      }),
    ];
    for (var row in rows) {
      final imagePath = row[2]; // Assuming the image path is at index 2
      print(row[2]);
      if (imagePath != "" || imagePath != null) {
        final imageBytes = await getImageBytesFromAssets(imagePath);
        row[2] = pw.Image(pw.MemoryImage(imageBytes), height: 50, width: 50);
        print(row[2]);
      }
    }
    List<List<dynamic>> combinedList = [header, ...rows];
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            // ignore: deprecated_member_use
            child: pw.Table.fromTextArray(
                context: context, cellStyle: cellStyle, data: combinedList),
          );
        },
      ),
    );

    final Directory directory =
        await getApplicationDocumentsDirectory(); // lấy link file lưu trữ tài liệu của máy
    final String filePath = '${directory.path}/Products.pdf';

    final File file = File(filePath);
    await file
      ..createSync(recursive: true)
      ..writeAsBytes(await pdf.save()); // ghi file
  }

  List<List<String>> convertToListOfLists(
      List<Map<String, dynamic>> inputList) {
    result.clear();
    result.add([
      'productId',
      'productName',
      'productImage',
      'quantity',
      'price',
      'sale',
      'prSale',
      'quantityTemp',
      'status'
    ]);

    for (var map in inputList) {
      result.add([
        map['productId'],
        map['productName'],
        map['productImage'],
        map['quantity'].toString(),
        map['price'].toString(),
        map['sale'],
        map['prSale'].toString(),
        map['quantityTemp'].toString(),
        map['status'].toString()
      ]);
    }
    return result;
  }

  void exportToExcel() async {
    Sheet sheetObject = excel['Product List'];
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
    List column = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'];
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
      final String filePath = '${directory.path}/Products.xlsx';
      print(filePath);

      final List<int>? excelBytes = excel.encode();

      File(filePath)
        ..createSync(
            recursive:
                true) // nếu nó chưa tồn tại cái file tên là products thì tạo ra
        ..writeAsBytesSync(excelBytes!); // còn ko thì sẽ ghi đè lên
    } else {}
  }

  void searchProduct(String id) async {
    List<Map<String, dynamic>> listPrId =
        await ProductHelper.searchProductRelative(id);
    List<Map<String, dynamic>> listPrName =
        await ProductHelper.searchProductByName(id);
    for (int index = 0; index < _products.length; index++) {
      _productsDataSource.dataGridRows.removeAt(0);
      _productsDataSource.updateDataGridSource();
    }
    while (_products.isNotEmpty) {
      _products.removeAt(0);
    }
    listPrId.addAll(listPrName);
    dataList = listPrId;

    for (int index = 0; index < dataList.length; index++) {
      Products a = Products(
          productId: dataList[index]["productId"],
          productName: dataList[index]["productName"],
          productImage: dataList[index]["productImage"],
          price: dataList[index]["price"],
          sale: dataList[index]["sale"],
          prSale: dataList[index]["prSale"],
          quantity: dataList[index]["quantity"],
          quantityTemp: dataList[index]["quantityTemp"],
          status: dataList[index]["status"]);
      _products.add(a);
    }
    setState(() {
      _productsDataSource = ProductDataSource(_products);
      _dataGridController = DataGridController();
    });
  }

  @override
  void initState() {
    getProduct();
    fToast.init(context);
    super.initState();
    _productsDataSource = ProductDataSource(_products);
    _dataGridController = DataGridController();
  }

  @override
  void dispose() {
    _productsDataSource.dispose();
    _dataGridController.dispose();
    //dataList.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
          title:
              const Text('List Product', style: TextStyle(color: Colors.white)),
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    controller: controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.only(bottom: 3),
                      hintText: "Search",
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue)),
                  onPressed: () {
                    String text = controller.text.trimLeft();
                    if (text.isNotEmpty) {
                      searchProduct(controller.text);
                    } else {
                      fToast.showToast(
                        child: const Text('Input is null !!',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        gravity: ToastGravity.BOTTOM,
                        toastDuration: const Duration(seconds: 2),
                      );
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10), // Khoảng cách to hơn cho nút
                    child: Icon(Icons.search, size: 25, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue)),
                  onPressed: () {
                    showDialog(
                        barrierColor: Colors.amber,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text('Option !!!'),
                              backgroundColor: Colors.white38,
                              content: const Text('Choose your option: '),
                              actions: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  //spacing: 20,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const EditPrTable(),
                                              ));
                                        },
                                        child: const SizedBox(
                                            width: 130,
                                            child: Row(
                                              children: [
                                                Text("Edit with Table"),
                                                Icon(Icons.add),
                                              ],
                                            ))),
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const InsertPrForm(),
                                              ));
                                        },
                                        child: const SizedBox(
                                            width: 120,
                                            child: Row(
                                              children: [
                                                Text("Add By Form"),
                                                Icon(Icons.add),
                                              ],
                                            ))),
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const InsertPrTable(),
                                              ));
                                        },
                                        child: const SizedBox(
                                            width: 120,
                                            child: Row(
                                              children: [
                                                Text("Add By Table"),
                                                Icon(Icons.add),
                                              ],
                                            ))),
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          // convertToListOfLists(_products)
                                          exportToExcel();
                                        },
                                        child: const SizedBox(
                                            width: 120,
                                            child: Row(
                                              children: [
                                                Text("Export Excel"),
                                                Icon(Icons.add),
                                              ],
                                            ))),
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                        child: const SizedBox(
                                            width: 120,
                                            child: Row(
                                              children: [
                                                Text('Export To Pdf'),
                                                Icon(Icons.add),
                                              ],
                                            )),
                                        onPressed: () {
                                          exportPDF();
                                        }),
                                  ],
                                ),
                              ]);
                        });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10), // Khoảng cách to hơn cho nút
                    child: Icon(Icons.settings, size: 25, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 100),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width < 1200
                      ? MediaQuery.of(context).size.width - 100
                      : 1040,
                  child: SfDataGrid(
                    startSwipeActionsBuilder:
                        (BuildContext context, DataGridRow row, int rowIndex) {
                      return GestureDetector(
                          onTap: () {
                            print(row
                                .getCells()); // del this will give an error is can't del more object
                            print(_products[rowIndex]
                                .productId); // lấy giá trị cột id của hàng rowIndex
                            // ProductHelper.deleteProduct(
                            //     id: _products[rowIndex].productId);
                            // _productsDataSource.dataGridRows.removeAt(rowIndex);
                            // _productsDataSource.updateDataGridSource();
                          },
                          child: Container(
                              color: const Color.fromARGB(255, 255, 156, 7),
                              child: const Center(
                                child: Icon(Icons.edit),
                              )));
                    },
                    endSwipeActionsBuilder:
                        (BuildContext context, DataGridRow row, int rowIndex) {
                      return GestureDetector(
                          onTap: () {
                            print(rowIndex.toString());
                            print(_products[rowIndex]
                                .productId); // lấy giá trị id của ô rowIndex

                            ProductHelper.deleteProduct(
                                id: _products[rowIndex].productId);
                            _products.removeAt(rowIndex);
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
                    //allowEditing: true,
                    allowSwiping: true,
                    swipeMaxOffset: 100.0,
                    frozenRowsCount: 0,
                    selectionMode: SelectionMode.single,
                    //navigationMode: GridNavigationMode.cell,
                    //columnWidthMode: ColumnWidthMode.fill,
                    controller: _dataGridController,
                    columns: [
                      GridColumn(
                        width: 80,
                        allowEditing: false,
                        columnName: 'productId',
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                        width: 200,
                        columnName: 'productImage',
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
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
                        width: 150,
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
                      GridColumn(
                        width: 150,
                        visible: false,
                        columnName: 'status',
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'Status',
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
