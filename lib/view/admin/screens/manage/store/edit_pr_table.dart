// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mkb_technology/helper/products.dart';
import 'package:mkb_technology/models/datasource/product/edit_datasource.dart';
import 'package:mkb_technology/models/products.dart';
import 'package:mkb_technology/view/admin/screens/manage/store/list_product.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// import 'package:mkb_technology/view/drawer.dart';

class EditPrTable extends StatefulWidget {
  const EditPrTable({super.key});

  @override
  State<EditPrTable> createState() => _EditPrTableState();
}

class _EditPrTableState extends State<EditPrTable> {
  final controller = TextEditingController();
  List<Map<String, dynamic>> dataList = [];
  late ProductDataSource _productsDataSource;
  final List<Products> _products = <Products>[];
  late DataGridController _dataGridController;
  late FToast fToast;

  void getProduct() async {
    List<Map<String, dynamic>> listSlide = await ProductHelper.getData();
    setState(() {
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
          status: dataList[index]["status"],);
      _products.add(a);
    }
    _productsDataSource = ProductDataSource(_products);
    _dataGridController = DataGridController();
  }

  void searchProduct(String id) async {
    List<Map<String, dynamic>> listPrId = await ProductHelper.searchProductRelative(id);
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
          status: dataList[index]["status"],);
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
    fToast = FToast();
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

  String isID = "";
  Future<String> getLastProduct(String id) async {
    List<Map<String, dynamic>> updateData = await ProductHelper.getLastID(id);
    dataList = updateData;
    int so = 0;
    try {
      print(dataList);
      if (dataList.isEmpty) {
        so = 1;
        print(so);
      } else {
        String id = dataList[0]["productId"];
        String kitu = id.substring(id.length - 1);
        so = int.parse(kitu);
        so++;
        print(so);
      }
    } catch (e) {
      // Xử lý ngoại lệ ở đây
      print('Đã xảy ra một ngoại lệ: $e');
    }

    setState(() {
      isID = id + so.toString();
    });
    print("ID test: $isID");
    return isID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
          title: const Text('Edit Product', style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListProduct(),
                  ));
            },
          ),
        ),
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
                  style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue)),
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
                    child: Icon(Icons.search, size: 25, color: Colors.white,),
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
                  width: MediaQuery.of(context).size.width < 1240
                      ? MediaQuery.of(context).size.width - 100
                      : 1040,
                  child: SfDataGrid(
                    source: _productsDataSource,
                    allowEditing: true,
                    swipeMaxOffset: 100.0,
                    frozenRowsCount: 0,
                    selectionMode: SelectionMode.single,
                    navigationMode: GridNavigationMode.cell,
                    // columnWidthMode: ColumnWidthMode.fill,
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
                        width: 150,
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
                        width: 80,
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
