// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mkb_technology/helper/products.dart';
import 'package:mkb_technology/models/user_login.dart';
import 'package:mkb_technology/view/admin/main.dart';
import 'package:mkb_technology/view/admin/screens/manage/setting/setting.dart';
import 'package:mkb_technology/view/admin/screens/manage/store/list_product.dart';
import 'package:mkb_technology/view/admin/screens/manage/task/chart_example/bar_chart/bar_chart.dart';
import 'package:mkb_technology/view/admin/screens/manage/transaction/list_transaction.dart';
import 'package:mkb_technology/view/admin/screens/manage/user/list_user.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../manage/task/chart_example/line_chart/chart.dart';
import '../../manage/task/task.dart';

class SideMenu extends StatefulWidget {
  final int isCase;
  const SideMenu({super.key, required this.isCase});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

void clearCache() {
  DefaultCacheManager().emptyCache();
}

class ListData extends ChangeNotifier {
  List<Map<String, dynamic>> _dataProduct = [];

  List<Map<String, dynamic>> get dataProduct => _dataProduct;
  void transmissionData(List<Map<String, dynamic>> data) {
    _dataProduct = data;
    notifyListeners();
  }
}

class _SideMenuState extends State<SideMenu> {
  List<Map<String, dynamic>> dataList = [];
  late SharedPreferences pref;
  bool? isLoggedIn = false;
  UserLogin? user;

  @override
  void initState() {
    _getProductListData();
    initPreferences();
    super.initState();
  }

  void logout() async {
    setState(() {
      pref.setBool("isLogin", false);
      isLoggedIn = pref.getBool("isLogin");
    });
  }

  void initPreferences() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = pref.getBool("isLogin");
    });
    print(isLoggedIn);
  }

  void _getProductListData() async {
    List<Map<String, dynamic>> updateData = await ProductHelper.getData();
    dataList = updateData;
    setState(() {
      dataList = updateData;
      context.read<ListData>().transmissionData(dataList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/Logo_office.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              if (widget.isCase != 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyAppAdmin()));
              }
            },
          ),
          DrawerListTile(
            title: "Transaction",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              if (widget.isCase != 2) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListTransaction()));
              }
            },
          ),
          DrawerListTile(
            title: "Task",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              if (widget.isCase != 3) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const TaskPieChart()));
              }
            },
          ),
          DrawerListTile(
            title: "Documents",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Store",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              if (widget.isCase != 5) {
                context.read<ListData>().transmissionData(dataList);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListProduct()));
              }
            },
          ),
          DrawerListTile(
            title: "Notification",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Manage User",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              if (widget.isCase != 7) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListUserPage()));
              }
            },
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              if (widget.isCase != 8) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminSetting()));
              }
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: const ColorFilter.mode(
            Color.fromARGB(255, 253, 249, 249), BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
      ),
    );
  }
}
