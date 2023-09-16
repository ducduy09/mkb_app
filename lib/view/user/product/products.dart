import 'package:flutter/material.dart';
import 'package:mkb_technology/view/admin/screens/main/components/side_menu.dart';
import 'package:mkb_technology/view/auth/src/loginPage.dart';
import 'package:mkb_technology/view/user/product/product_details.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'main.dart';
import '../drawer.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Map<String, dynamic>> dataList = [];

  late SharedPreferences pref;
  bool? isLoggedIn = false;
  
  @override
  void initState() {
    initPreferences();
    super.initState();
  }
  void initPreferences() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = pref.getBool("isLogin");
    });
  }

  @override
  Widget build(BuildContext context) {
    dataList = context.watch<ListData>().dataProduct;
    //  print(dataList);
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
          title: Container(
            alignment: Alignment.center,
            child: const Text(
              //   widget.title,
              'PRODUCT PAGE',
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
          ),
        ),
        drawer: const MyWidgetDrawer(isCase: 2),
        body: Center(
            child: Flex(direction: Axis.vertical, children: [
          Expanded(
            child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (isLoggedIn == true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetail(
                                      data: dataList,
                                      id: index,
                                    )));
                      } else if (isLoggedIn == false || isLoggedIn == null){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      }
                    },
                    child: Container(
                        margin: const EdgeInsets.all(20),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dataList[index]["sale"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.favorite_outline,
                                    color: Colors.red,
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: Image.asset(
                                    dataList[index]["productImage"],
                                    height: 150,
                                    width: 200),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dataList[index]["productName"],
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black.withOpacity(0.8),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${dataList[index]["prSale"]}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.redAccent,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${dataList[index]["price"]}",
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: 13,
                                            color:
                                                Colors.black.withOpacity(0.4),
                                          ),
                                        )
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
        ])));
  }
}
