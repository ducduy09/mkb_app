// ignore_for_file: avoid_unnecessary_containers, avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:mkb_technology/helper/products.dart';
import 'package:mkb_technology/helper/sliderHelper.dart';
import 'package:mkb_technology/models/user_login.dart';
import 'package:mkb_technology/view/admin/main.dart';

import 'package:mkb_technology/view/user/drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mkb_technology/view/admin/screens/main/components/side_menu.dart';
import 'package:mkb_technology/view/user/product/products.dart';
import 'package:mkb_technology/interfaceSettings/light_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mkb_technology/view/user/function.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:url_launcher/url_launcher.dart';

late SharedPreferences pref;
bool? isLoggedIn = false;
UserLogin? user;
void initPreferences() async {
  pref = await SharedPreferences.getInstance();
  String? userData = pref.getString("userData");
  if (userData != null) {
    user = UserLogin.fromMap(jsonDecode(userData));
  }
  isLoggedIn = pref.getBool("isLogin");
  print(user?.type.toString());
  print(isLoggedIn);
}

void main() async {
  initPreferences();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SettingScreen1()),
      ChangeNotifierProvider(
        create: (context) => ListData(),
      ),
      //  ChangeNotifierProvider(create: (_) => DataCounter())
    ],
    child: Phoenix(
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MKB Technology',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        brightness: context.watch<SettingScreen1>().Dark
            ? Brightness.dark
            : Brightness.light,
        useMaterial3: true,
      ),
      home: isLoggedIn == false ||
              user?.type.toString() == "Guest" ||
              isLoggedIn == null
          ? const MyHomePage()
          : const MyAppAdmin(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;
  late SharedPreferences pref;

  UserLogin? user;

  @override
  void initState() {
    // initPreferences();
    getProductListData();
    getSlider();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final Uri linkFB = Uri.parse('https://www.facebook.com');
  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }
  List<Map<String, dynamic>> dataList = [];
  List listSlider = [];
  void getProductListData() async {
    List<Map<String, dynamic>> updateData = await ProductHelper.getData();
    dataList = updateData;
    setState(() {
      dataList = updateData;
      //context.read<ListData>().transmissionData(dataList);
    });
  }

  void getSlider() async {
    List<Map<String, dynamic>> dataSlide = await SliderHelper.getData();
    setState(() {
      listSlider = dataSlide;
    });
  }

  // List listImageSlider = [
  //   {"id":1, "image_path":'assets/images/banner.jpg'},
  //   {"id":2, "image_path":'assets/images/image_slider_1.jpg'},
  //   {"id":3, "image_path":'assets/images/image_slider_2.jpg'},
  //   {"id":4, "image_path":'assets/images/image_slider_3.jpg'},
  // ];
  final CarouselController carouselController = CarouselController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 51, 122, 245),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: const Text('MKB Technology',
            style: TextStyle(
              color: Colors.white,
            )),
        actions: [
          menuTop(context),
          Switch(
              value: context.watch<SettingScreen1>().Dark,
              onChanged: (newValue) {
                Provider.of<SettingScreen1>(context, listen: false)
                    .setBrightness(newValue);
              }),
        ],
      ),
      drawer: const MyWidgetDrawer(isCase: 1),
      body: SingleChildScrollView(
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1300, minWidth: 500),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              sliderMain(listSlider),
              //hot product
              Container(
                margin: const EdgeInsets.only(top: 50, bottom: 20),
                child: Column(children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hot Products',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  Wrap(
                    children: [
                      if (isLoggedIn == true)
                        for (int i = 1; i < 7; i++)
                          list_product('assets/images/product_$i.jpg', context,
                              1, i, dataList),
                      if (isLoggedIn == false || isLoggedIn == null)
                        for (int i = 1; i < 7; i++)
                          list_product('assets/images/product_$i.jpg', context,
                              0, i, dataList),
                    ],
                  )
                ]),
              ),
              //new product
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                child: Column(children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New Products',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      )
                    ],
                  ),
                  Wrap(
                    children: [
                      if (isLoggedIn == true)
                        for (int i = 1; i < 7; i++)
                          list_product('assets/images/product_$i.jpg', context,
                              1, i, dataList),
                      if (isLoggedIn == false || isLoggedIn == null)
                        for (int i = 1; i < 7; i++)
                          list_product('assets/images/product_$i.jpg', context,
                              0, i, dataList),
                    ],
                  )
                ]),
              ),
              // Sale 55
              Container(
                color: Colors.blue[400],
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3, // 60%
                      child: SizedBox(
                        height: 150.0,
                        width: double.infinity,
                        // decoration: const BoxDecoration(
                        //   color: Colors.white,
                        //   borderRadius: BorderRadius.all(Radius.circular(10)),
                        //   boxShadow: [
                        //     BoxShadow(
                        //       color: Colors.deepPurple,
                        //       blurRadius: 20.0, // Soften the shaodw
                        //       spreadRadius: 2.0,
                        //       offset: Offset(0.0, 0.0),
                        //     )
                        //   ],
                        // ),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.asset('assets/images/sale.png',
                              alignment: Alignment.center),
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 4, // 20%
                      child: SizedBox(
                        height: 150.0,
                        width: double.infinity,
                        // decoration: const BoxDecoration(
                        //   color: Color.fromARGB(255, 32, 122, 224),
                        //   boxShadow: [
                        //     BoxShadow(
                        //       color: Colors.deepPurple,
                        //       blurRadius: 20.0, // Soften the shaodw
                        //       spreadRadius: 2.0,
                        //       offset: Offset(0.0, 0.0),
                        //     )
                        //   ],
                        // ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Save 5500 TK in GoPro Hero 10!',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center),
                            Text(
                                'Get huge discount in products or save money\n by using coupons while checkout',
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3, // 30%
                      child: SizedBox(
                        height: 150.0,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ProductPage()));
                                  },
                                  child: const Text(
                                    'View All',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //produc sale
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                child: Column(children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sale Products',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      )
                    ],
                  ),
                  Wrap(
                    children: [
                      if (isLoggedIn == true)
                        for (int i = 1; i < 7; i++)
                          list_product('assets/images/product_$i.jpg', context,
                              1, i, dataList),
                      if (isLoggedIn == false || isLoggedIn == null)
                        for (int i = 1; i < 7; i++)
                          list_product('assets/images/product_$i.jpg', context,
                              0, i, dataList),
                    ],
                  )
                ]),
              ),
              //big update
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 20),
                child: const Column(
                  children: <Widget>[
                    Text(
                      ' -- BIG UPDATES --',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    Text(
                      'Sắp ra mắt những sản phẩm mới ngày 22/10/2023 \n          đáp ứng mọi yêu cầu của khách hàng',
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    )
                  ],
                ),
              ),
              //3 khối content
              Container(
                color: Colors.blue[400],
                margin: const EdgeInsets.only(top: 20),
                child: const Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3, // 30%
                      child: SizedBox(
                        height: 200.0,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Save 5500 TK in GoPro Hero 1!',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center),
                            Text(
                                'Get huge discount in products or save money\n by using coupons while checkout',
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4, // 40%
                      child: SizedBox(
                        height: 200.0,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Save 5500 TK in GoPro Hero 10!',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center),
                            Text(
                                'Get huge discount in products or save money\n by using coupons while checkout',
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3, // 30%
                      child: SizedBox(
                        height: 200.0,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Save 5500 TK in GoPro Hero 10!',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center),
                            Text(
                                'Get huge discount in products or save money\n by using coupons while checkout',
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _linkFB,
        tooltip: 'Chat',
        child: const Icon(Icons.message),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            height: 50,
            color: Colors.blue[300],
            child: const Text('Create by Admin', textAlign: TextAlign.center),
          )),
    );
  }

  Stack sliderMain(List list) {
    return Stack(
      children: [
        CarouselSlider(
          items: list
              .map((item) => Image.asset(item['image_path'],
                  fit: BoxFit.cover, width: double.infinity))
              .toList(),
          carouselController: carouselController,
          options: CarouselOptions(
              scrollPhysics: const BouncingScrollPhysics(),
              autoPlay: true,
              aspectRatio: 2,
              viewportFraction: 1,
              onPageChanged: (index_, reason) {
                setState(() {
                  index = index_;
                });
              }),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: list.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => carouselController.animateToPage(entry.key),
                child: Container(
                  width: index == entry.key ? 17 : 7,
                  height: 7.0,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 3.0,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: index == entry.key ? Colors.red : Colors.teal),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Future<void> _linkFB() async {
    if (!await launchUrl(linkFB)) {
      throw Exception('Could not launch $linkFB');
    }
  }
}
