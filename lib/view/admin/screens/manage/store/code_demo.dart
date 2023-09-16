// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mkb_technology/helper/products.dart';
import 'package:mkb_technology/models/datasource/product/datasource_product.dart';
import 'package:mkb_technology/models/products.dart';
import 'package:mkb_technology/view/admin/screens/manage/store/insert_pr_form.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// import 'package:mkb_technology/view/drawer.dart';

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
          quantityTemp: dataList[index]["quantityTemp"]);
      _products.add(a);
    }
    _productsDataSource = ProductDataSource(_products);
    _dataGridController = DataGridController();
  }

  @override
  void initState() {
    getProduct();
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
          title: const Text('List Product'),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InsertPrForm(),
                      ));
                },
                child: const Icon(Icons.update)),
            const SizedBox(
              height: 20,
            ),
            SfDataGrid(
              startSwipeActionsBuilder:
                  (BuildContext context, DataGridRow row, int rowIndex) {
                return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Warning !!!'),
                            backgroundColor: Colors.white38,
                            content: const Text('Product Id ?'),
                            actions: [
                              ElevatedButton(
                                child: const Text('A'),
                                onPressed: () {
                                  getLastProduct("prdA").then((value) {
                                    print("ID: $value");
                                  });
                                },
                              ),
                              ElevatedButton(
                                child: const Text('B'),
                                onPressed: () async {
                                  getLastProduct("prdB").then((value) {
                                    print("ID: $value");
                                  });
                                },
                              ),
                              ElevatedButton(
                                child: const Text('C'),
                                onPressed: () {
                                  getLastProduct("prdC").then((value) {
                                    print("ID: $value");
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                      _productsDataSource.dataGridRows.insert(
                          rowIndex,
                          const DataGridRow(cells: [
                            DataGridCell(value: "", columnName: 'productId'),
                            DataGridCell(value: "", columnName: 'productName'),
                            DataGridCell(value: "", columnName: 'productImage'),
                            DataGridCell(value: "", columnName: 'price'),
                            DataGridCell(value: "", columnName: 'quantity'),
                            DataGridCell(value: "", columnName: 'sale'),
                            DataGridCell(value: "", columnName: 'prSale'),
                            DataGridCell(value: "", columnName: 'quantityTemp')
                          ]));
                      _productsDataSource.updateDataGridSource();
                      // Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => const InsertProduct()));
                    },
                    child: Container(
                        color: Colors.greenAccent,
                        child: const Center(
                          child: Icon(Icons.add),
                        )));
              },
              endSwipeActionsBuilder:
                  (BuildContext context, DataGridRow row, int rowIndex) {
                return GestureDetector(
                    onTap: () {
                      print(row.getCells().first);
                      
                      // _productsDataSource.dataGridRows.removeAt(rowIndex);
                      // _productsDataSource.updateDataGridSource();
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
              columnWidthMode: ColumnWidthMode.fill,
              controller: _dataGridController,
              columns: [
                GridColumn(
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
          ]),
        ));
  }
}
