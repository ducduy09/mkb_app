import 'package:mkb_technology/view/admin/controllers/MenuAppController.dart';
import 'package:mkb_technology/view/admin/responsive.dart';
import 'package:mkb_technology/view/admin/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool? isLoggedIn = false;
  late SharedPreferences pref;
  
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
    print(isLoggedIn);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 160, 160, 160),
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: const SideMenu(isCase: 1),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(isCase: 1),
              ),
            const Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: DashboardScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
