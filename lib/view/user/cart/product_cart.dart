import 'package:google_fonts/google_fonts.dart';
import 'package:mkb_technology/helper/orderHelper.dart';
import 'package:flutter/material.dart';

import 'edit_order.dart';
// import 'package:provider/provider.dart';

class ProductCart extends StatefulWidget {
  const ProductCart({super.key});

  @override
  State<ProductCart> createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  List<Map<String, dynamic>> dataList = [];

  void getTransaction() async {
    List<Map<String, dynamic>> listOrder = await OrderHelper.getDataOrderNew();
    setState(() {
      dataList = listOrder;
    });
  }
  @override
  void initState(){
    getTransaction();
    super.initState();
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
        drawer: const Drawer(),
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
                            //  int prID = ProductHelper.getId(index) as int;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditOrder(data: dataList, id: index,)));
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
