// ignore_for_file: prefer_const_constructors, avoid_print
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mkb_technology/helper/DbHelper.dart';
// import 'package:get/get.dart';
import 'package:mkb_technology/helper/orderHelper.dart';
import 'package:mkb_technology/models/user_login.dart';
import 'package:mkb_technology/view/admin/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  final List<Map> data;
  final int id;
  final int choose;
  const PaymentScreen({
    Key? key,
    required this.data,
    required this.id,
    required this.choose,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

final _priceController = TextEditingController();
final _addressController = TextEditingController();
final _quantityController = TextEditingController(text: "1");

class _PaymentScreenState extends State<PaymentScreen> {
  late SharedPreferences pref;
  UserLogin? user;
  late FToast fToast;

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    _quantityController.text = "1";
    _priceController.text = widget.data[widget.id]["prSale"].toString();
    initPreferences();
    super.initState();
  }

  void initPreferences() async {
    pref = await SharedPreferences.getInstance();
    String? userData = pref.getString("userData");
    setState(() {
      if (userData != null) {
        user = UserLogin.fromMap(jsonDecode(userData));
      }
    });
  }

  void checker(String code, String prId) async {
    int a = await DatabaseHelper.payment(
        user!.userId, double.parse(_priceController.text).round());
    if (a == 0) {
      OrderHelper.insertOrder(
          code,
          prId,
          user!.userId.toString(),
          double.parse(_priceController.text),
          _addressController.text,
          int.parse(_quantityController.text),
          0,
          widget.choose);
      setState(() {
        _quantityController.text = "1";
        _addressController.text = "";
        _priceController.text =  widget.data[widget.id]["prSale"].toString();
      });
      fToast.showToast(
        child: const Text('Completed !!',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
            )),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 3),
      );
    } else {
      fToast.showToast(
        child: const Text('You do not have enough money !!',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
            )),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double price_pr = widget.data[widget.id]["prSale"];
    String prId = widget.data[widget.id]["productId"];

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
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.badge_outlined,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          margin: Responsive.isDesktop(context)
              ? EdgeInsets.only(right: 200, left: 20)
              : EdgeInsets.only(right: 20, left: 20),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .35,
                padding: const EdgeInsets.only(bottom: 30),
                width: double.infinity,
                child: Image.asset(widget.data[widget.id]["productImage"]),
              ),
              Text(
                "Chi tiết đơn hàng:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text("Quantity: ",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.end),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 4,
                    child: TextField(
                      readOnly: true,
                      controller: _quantityController,
                      style: TextStyle(color: Colors.amber),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            //color: Colors.red, // Màu sắc của đường viền
                            width: 2.0, // Độ dày của đường viền
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(bottom: 3),
                        labelText: "Quantity",
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        int count = int.parse(_quantityController.text);
                        if (count > 1) {
                          setState(() {
                            count--;
                            _quantityController.text = count.toString();
                            double a = price_pr * count;
                            _priceController.text = a.toString();
                          });
                        } else {
                          setState(() {
                            _quantityController.text = "1";
                            _priceController.text = price_pr.toString();
                          });
                        }
                      },
                      child: Text(
                        '\u2212', // Dấu trừ (−) dưới dạng mã Unicode
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                        onPressed: () {
                          int count = int.parse(_quantityController.text);
                          if (count >= 1) {
                            if (widget.data[widget.id]["quantity"] > count) {
                              setState(() {
                                count++;
                                _quantityController.text = count.toString();
                                double a = price_pr * count;
                                _priceController.text = a.toString();
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid product quantity !!!'),
                                ),
                              );
                            }
                          } else {
                            setState(() {
                              _quantityController.text = "1";
                              _priceController.text = price_pr.toString();
                            });
                          }
                        },
                        child: Icon(Icons.add, color: Colors.black)),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text("Address: ",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.end),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 8,
                    child: TextField(
                      controller: _addressController,
                      style: TextStyle(color: Colors.amber),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            //color: Colors.red, // Màu sắc của đường viền
                            width: 2.0, // Độ dày của đường viền
                          ),
                        ),
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: "Address",
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text("Total Price: ",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.end),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 8,
                    child: TextField(
                      readOnly: true,
                      controller: _priceController,
                      style: TextStyle(color: Colors.amber),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            //color: Colors.red, // Màu sắc của đường viền
                            width: 2.0, // Độ dày của đường viền
                          ),
                        ),
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: "Total Price",
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        )),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(
              //padding: const EdgeInsets.only(top: 20),
              height: 50,
              color: Color.fromARGB(255, 224, 158, 33),
              child: TextButton(
                onPressed: () {
                  String code =
                      "${prId}u${user!.userId}q${_quantityController.text}c${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().millisecond}";
                  print(code);
                  if (_addressController.text.isEmpty ||
                      _priceController.text.isEmpty) {
                    fToast.showToast(
                      child: const Text('You must enter all the information !!',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          )),
                      gravity: ToastGravity.BOTTOM,
                      toastDuration: const Duration(seconds: 3),
                    );
                  } else {
                    try {
                      checker(code, prId);
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                child: Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ));
  }
}
