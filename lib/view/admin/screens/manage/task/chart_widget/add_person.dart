// ignore_for_file:library_private_types_in_public_api, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  late FToast fToast;
  late SharedPreferences pref;
  UserLogin? user;
  int adminId = 0;

  List<Map<String, dynamic>> taskList = [];
  // List<Map<String, dynamic>> taskListData = [];
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> userList = [];

  Future<void> getListTask(int id) async {
    List<Map<String, dynamic>> list = await TaskHelper.getListTask(id);
    setState(() {
      taskList = list;
    });
  }

  Future<void> getTaskName(String id) async {
    List<Map<String, dynamic>> list = await TaskHelper.checkTaskId(id, adminId);
    setState(() {
      taskList = list;
    });
  }

  Future<void> getListTaskID(int id, String idtask) async {
    List<Map<String, dynamic>> list = await TaskHelper.getTaskById(id, idtask);
    setState(() {
      dataList.addAll(list);
    });
    print(dataList);
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

  void addUserToTask(
      String taskId, int userId, String taskName, String content) async {
    try {
      List<Map<String, dynamic>> data =
          await TaskHelper.checkTaskId(taskId, userId);
      if (data.isEmpty) {
        await TaskHelper.insertTaskNow(taskId, userId, taskName, content);
        var notify = const SnackBar(
          content: Text("Completed !!!"),
          duration: Duration(seconds: 3),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(notify);
      } else {
        fToast.showToast(
          child: const Text(
            "This user already exists in the task !!!",
            style: TextStyle(color: Colors.black),
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getIdAdmin().then((value) {
      getListTask(adminId).then((value) => {
            for (int i = 0; i < taskList.length; i++)
              {getListTaskID(adminId, taskList[i]["taskId"])}
          });
      getListUser();
    });
    fToast = FToast();
    fToast.init(context);
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
                    itemCount: userList.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Draggable(
                          data: userList[i],
                          feedback: SizedBox(
                            width: 300,
                            height: 80,
                            child: Card(
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
                            ),
                          ),
                          childWhenDragging: const SizedBox(),
                          child: SizedBox(
                            width: 300,
                            height: 80,
                            child: Card(
                              color: const Color.fromARGB(255, 209, 162, 9),
                              elevation: 8,
                              child: ListTile(
                                title: Text(
                                  "Admin ${i + 1}",
                                  style: GoogleFonts.montserrat(),
                                ),
                                subtitle: Text(
                                  userList[i]['userName'],
                                ),
                                trailing: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.green.shade800,
                                ),
                                onTap: () {},
                              ),
                            ),
                          ));
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int i) {
                return DragTarget(
                  builder: (BuildContext context, List<dynamic> candidateData,
                      List<dynamic> rejectedData) {
                    return Card(
                      color: const Color.fromARGB(255, 209, 162, 9),
                      elevation: 8,
                      child: ListTile(
                        title: Text(
                          dataList[i]['taskName'],
                          style: GoogleFonts.montserrat(),
                        ),
                        subtitle: Text(
                          "${dataList[i]['content']}",
                          // style: greyTExt,
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.green.shade800,
                        ),
                        onTap: () {
                          String text = dataList[i]['taskId'];
                          text = text.substring(0, text.indexOf("."));
                          print(text);
                          getTaskName(text).then((value) => {
                                fToast.showToast(
                                  child: Text(
                                    "Task Name: ${taskList[0]['taskName']}",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: const Duration(seconds: 2),
                                )
                              });
                        },
                      ),
                    );
                  },
                  onWillAccept: (data) {
                    return data != null;
                  },
                  onAccept: (data) {
                    setState(() {
                      accepted = true;
                      // Map<String, dynamic> a = data as Map<String, dynamic>; // cách này là dùng nên cẩn thận vì nếu sai có thể sinh
                      // print(a["userId"]);  // ra ngoại lệ và nên sử dụng cách bên dưới để kiểm tra thì hay hơn
                      if (data is Map<String, dynamic>) {
                        var userId = data['userId'];
                        addUserToTask(dataList[i]["taskId"], userId,
                            dataList[i]["taskName"], dataList[i]["content"]);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
