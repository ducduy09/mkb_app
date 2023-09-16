// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:mkb_technology/helper/orderHelper.dart';
import 'package:flutter/material.dart';
import 'package:mkb_technology/models/user_login.dart';
import 'package:mkb_technology/view/user/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';

class ListTransaction extends StatefulWidget {
  const ListTransaction({super.key});

  @override
  State<ListTransaction> createState() => _ListTransactionState();
}

class _ListTransactionState extends State<ListTransaction> {
  List<Map<String, dynamic>> dataList = [];
  UserLogin? user;
  late SharedPreferences pref;
  void getTransaction() async {
    pref = await SharedPreferences.getInstance();
    String? userData = pref.getString("userData");
    setState(() {
      if (userData != null) {
        user = UserLogin.fromMap(jsonDecode(userData));
      }
    });
    List<Map<String, dynamic>> listOrder = await OrderHelper.getOrderComplete(user!.userId.toString(), 1);
    setState(() {
      dataList = listOrder;
    });
  }
  void deleteOrder(String b) async{
    OrderHelper.deleteOrder(b);
    List<Map<String, dynamic>> listOrder = await OrderHelper.getOrderComplete(user!.userId.toString(), 1);
    setState(() {
      dataList = listOrder;
    });
  }
  @override
  void initState(){
    super.initState();
    getTransaction();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 51, 122, 245),
          leading: Builder(
              builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ))),
          title: const Text('List Transaction',
              style: TextStyle(
                color: Colors.white,
              )),
        ),
        drawer: const MyWidgetDrawer(isCase: 4),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        // return Consumer<ListData>(builder: (context, listData, child) {
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Warning !!!'),
                                  backgroundColor: Colors.white38,
                                  content: const Text('This Order will be delete?'),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton(
                                      child: const Text('Delete'),
                                      onPressed: () {
                                        deleteOrder(dataList[index]["tradingCode"]);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                              margin: const EdgeInsets.all(10),
                              //alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color.fromARGB(255, 212, 236, 247),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      // offset: Offset(2, 4),
                                      blurRadius: 4,
                                      spreadRadius: 2)
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text('ID Product: ',
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: const Color.fromARGB(255, 255, 0, 0),
                                              ),
                                            ),
                                            Text(
                                              dataList[index]["productId"],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Color.fromARGB(255, 3, 3, 3),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.favorite_outline,
                                          color: Colors.red,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Số lượng sản phẩm: ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.red,
                                            ),
                                          ),
                                          Text(
                                             "${dataList[index]["quantity"]}",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                           Text('Giá:',
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: const Color.fromARGB(255, 255, 0, 0),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${dataList[index]["price"]}",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Color.fromARGB(255, 0, 0, 0),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        );
                        // });
                      }),
                )
              ],
            ),
          ),
        ));
  }
}
