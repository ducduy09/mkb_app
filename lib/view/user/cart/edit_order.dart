// ignore_for_file: prefer_const_constructors, must_be_immutable, avoid_print
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mkb_technology/helper/orderHelper.dart';
import 'package:mkb_technology/view/admin/screens/manage/transaction/list_transaction.dart';
// import 'package:mkb_technology/helper/products.dart';

class EditOrder extends StatefulWidget {
  final List<Map> data;
  final int id;

  const EditOrder({Key? key, required this.data, required this.id})
      : super(key: key);

  @override
  State<EditOrder> createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  final prIdController = TextEditingController();
  final userIdController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final tCodeController = TextEditingController();
  final addressController = TextEditingController();
  @override
  void initState() {
    super.initState();
    prIdController.text = widget.data[widget.id]["productId"];
    userIdController.text = widget.data[widget.id]["userId"];
    priceController.text = widget.data[widget.id]["price"].toString();
    quantityController.text = widget.data[widget.id]["quantity"].toString();
    tCodeController.text = widget.data[widget.id]["tradingCode"];
    addressController.text = widget.data[widget.id]["address"];
  }

  void _saveData() async {
    final tCode = tCodeController.text;

    int insertId = await OrderHelper.orderComplete(tCode, 1);
    // // ignore: avoid_print
    // List<Map<String, dynamic>> updateData =  await ProductHelper.getData();
    // setState(() {
    //   widget.data = updateData;
    // });
    print(insertId);
  }

  void _deleteData() async {
    final tCode = tCodeController.text;
    await OrderHelper.deleteOrder(tCode);
  }

  TextInputFormatter getInputFormatter(bool isNumericKeyBoard) {
    if (isNumericKeyBoard) {
      return FilteringTextInputFormatter.allow(RegExp('[0-9 ]'));
    } else {
      return FilteringTextInputFormatter.allow(
          RegExp('[^"\']*[^\'\"`]', unicode: true));
    }
  }

  @override
  void dispose() {
    prIdController.dispose();
    userIdController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.kBgColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.badge_outlined,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40, right: 14, left: 14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Xác nhận TT Đặt hàng',
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: const Color.fromARGB(255, 255, 0, 0),
                              fontWeight: FontWeight.bold),
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: Text("Trading Code: ",
                                        style: TextStyle(color: Colors.black),
                                        textAlign: TextAlign.end),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      enabled: false,
                                      style: TextStyle(color: Colors.black),
                                      controller: tCodeController,
                                      inputFormatters: [
                                        getInputFormatter(false)
                                      ],
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors
                                                  .red, // Màu sắc của đường viền
                                              width:
                                                  2.0, // Độ dày của đường viền
                                            ),
                                          ),
                                          hintText: 'Product userId'),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: Text("Product ID: ",
                                        style: TextStyle(color: Colors.black),
                                        textAlign: TextAlign.end),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      enabled: false,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      controller: prIdController,
                                      inputFormatters: [getInputFormatter(false)],
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors
                                                  .red, // Màu sắc của đường viền
                                              width:
                                                  2.0, // Độ dày của đường viền
                                            ),
                                          ),
                                          hintText: 'Product ID'),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: Text("User ID: ",
                                        style: TextStyle(color: Colors.black),
                                        textAlign: TextAlign.end),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      enabled: false,
                                      style: TextStyle(color: Colors.black),
                                      controller: userIdController,
                                      inputFormatters: [getInputFormatter(false)],
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors
                                                  .red, // Màu sắc của đường viền
                                              width:
                                                  2.0, // Độ dày của đường viền
                                            ),
                                          ),
                                          hintText: 'Product userId'),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: Text("Price: ",
                                        style: TextStyle(color: Colors.black),
                                        textAlign: TextAlign.end),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      enabled: false,
                                      style: TextStyle(color: Colors.black),
                                      controller: priceController,
                                      inputFormatters: [getInputFormatter(true)],
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors
                                                  .red, // Màu sắc của đường viền
                                              width:
                                                  2.0, // Độ dày của đường viền
                                            ),
                                          ),
                                          hintText: 'Price'),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: Text("Quantity: ",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.end),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      enabled: false,
                                      style: TextStyle(color: Colors.black),
                                      controller: quantityController,
                                      inputFormatters: [getInputFormatter(true)],
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors
                                                  .red, // Màu sắc của đường viền
                                              width:
                                                  2.0, // Độ dày của đường viền
                                            ),
                                          ),
                                          hintText: 'Quantity'),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: Text("Address: ",
                                        style: TextStyle(color: Colors.black),
                                        textAlign: TextAlign.end),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      enabled: false,
                                      style: TextStyle(color: Colors.black),
                                      controller: addressController,
                                      inputFormatters: [getInputFormatter(false)],
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors
                                                  .red, // Màu sắc của đường viền
                                              width:
                                                  2.0, // Độ dày của đường viền
                                            ),
                                          ),
                                          hintText: 'Product userId'),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        try {
                                          _deleteData();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Delete successfully !!!'),
                                            ),
                                          );
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ListTransaction(),
                                              ));
                                          // Nếu không có lỗi xảy ra, tiến hành các thao tác khác
                                        } catch (e) {
                                          // Xử lý lỗi khi chuỗi khi lỗi
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('Delete error !!!'),
                                            ),
                                          );
                                          print('Lỗi: ${e.toString()}');
                                        }
                                      },
                                      child: const Text('Cancel')),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        try {
                                          _saveData();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Update successfully !!!'),
                                            ),
                                          );
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ListTransaction(),
                                              ));
                                          // Nếu không có lỗi xảy ra, tiến hành các thao tác khác
                                        } catch (e) {
                                          // Xử lý lỗi khi chuỗi khi lỗi
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('Update error !!!'),
                                            ),
                                          );
                                          print('Lỗi: ${e.toString()}');
                                        }
                                      },
                                      child: const Text('Accept')),
                                ],
                              ),
                            ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
