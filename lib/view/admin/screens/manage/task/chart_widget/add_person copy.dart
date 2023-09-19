// ignore_for_file:library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mkb_technology/helper/task_helper.dart';
import 'package:mkb_technology/helper/users.dart';
import 'package:mkb_technology/models/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DragAndDropExample extends StatefulWidget {
  const DragAndDropExample({super.key});

  @override
  _DragAndDropExampleState createState() => _DragAndDropExampleState();
}

class _DragAndDropExampleState extends State<DragAndDropExample> {
  String draggableData = 'OBJ';
  bool accepted = false;
  late SharedPreferences pref;
  UserLogin? user;
  int adminId = 0;

  List<Map<String, dynamic>> taskList = [];
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> userList = [];
  Future<void> getListTask(int id) async {
    List<Map<String, dynamic>> list = await TaskHelper.getListTask(id);
    setState(() {
      taskList = list;
    });
  }

  Future<int> getIdAdmin() async {
    pref = await SharedPreferences.getInstance();
    String? userData = pref.getString("userData");
    setState(() {
      if (userData != null) {
        user = UserLogin.fromMap(jsonDecode(userData));
      }
    });
    adminId = user!.userId;
    return adminId;
  }

  void getListUser() async {
    List<Map<String, dynamic>> list = await UserHelper.getDataByType("Admin");
    setState(() {
      userList = list;
    });
  }

  @override
  void initState() {
    getIdAdmin().then((value) {
      getListTask(adminId);
    });
    getListUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Manager Task"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: taskList.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Card(
                        color: const Color.fromARGB(255, 209, 162, 9),
                        elevation: 8,
                        child: ListTile(
                          title: Text(
                            "Task ${i + 1}",
                            style: GoogleFonts.montserrat(),
                          ),
                          subtitle: Text(
                            taskList[i]['taskName'],
                            // style: greyTExt,
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.green.shade800,
                          ),
                          onTap: () {},
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (BuildContext context, int i) {
                return Card(
                  color: const Color.fromARGB(255, 209, 162, 9),
                  elevation: 8,
                  child: ListTile(
                    title: Text(
                      "Admin ${i + 1}",
                      style: GoogleFonts.montserrat(),
                    ),
                    subtitle: Text(
                      userList[i]['userName'],
                      // style: greyTExt,
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.green.shade800,
                    ),
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}