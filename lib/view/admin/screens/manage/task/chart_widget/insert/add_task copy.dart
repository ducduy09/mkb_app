import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mkb_technology/helper/index_task_helper.dart';
import 'package:mkb_technology/helper/task_helper.dart';
import 'package:mkb_technology/models/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class AddTask extends StatefulWidget {
  final int count;
  const AddTask({super.key, required this.count});

  @override
  // ignore: library_private_types_in_public_api
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  List<TextEditingController> titleController = [];
  List<TextEditingController> contentController = [];
  List<TextEditingController> titleChildController = [];
  List<TextEditingController> contentChildController = [];

  List<Map<String, dynamic>> listDataTask = [];
  List<Map<String, dynamic>> listTask = [];  // list lưu các task board
  List<Map<String, dynamic>> dataList = [];  // list lưu thông tin chi tiết của board nào đó

  int tabNumber = 1;
  int number = 1;
  late SharedPreferences pref;
  UserLogin? user;
  int adminId = 0;
  bool accepted = false;
  late FToast fToast;
  int tabChildNumber = 0;

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
  Future<void> getListTask(int id) async { // lấy danh sách task board của admin này
    List<Map<String, dynamic>> list = await IndexTaskHelper.getListTask(id);
    setState(() {
      listTask = list;
    });
  }
  Future<void> getListTaskID(int id, String idtask) async {   // lấy thông tin của cái task board này
    List<Map<String, dynamic>> list =
        await IndexTaskHelper.getTaskById(id, idtask);
    setState(() {
      dataList.addAll(list);
    });
    // print(dataList);
  }

Future<void> getTaskName(String id) async {
    List<Map<String, dynamic>> list =
        await IndexTaskHelper.checkTaskId(id, adminId);
    setState(() {
      listTask = list;
    });
  }
void addTaskToIndexTask(
      String id, String taskId, String taskName, String note) async {
    try {
      List<Map<String, dynamic>> data =
          await TaskHelper.checkTaskId(id, taskId);
      if (data.isEmpty) {
        await TaskHelper.insertTaskNow(id, taskId, taskName, note);
        var notify = const SnackBar(
          content: Text("Completed !!!"),
          duration: Duration(seconds: 3),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(notify);
      } else {
        fToast.showToast(
          child: const Text(
            "This task already exists in the IndexTask !!!",
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
    fToast = FToast();
    fToast.init(context);
    List<Map<String, dynamic>> tmpList = [];
    titleController = List.generate(
      widget.count,
      (index) => TextEditingController(),
    );
    contentController = List.generate(
      widget.count,
      (index) => TextEditingController(),
    );
    titleChildController = List.generate(
      1,
      (index) => TextEditingController(),
    );
    contentChildController = List.generate(
      1,
      (index) => TextEditingController(),
    );
    getIdAdmin().then((value) {
      print(value);
      getListTask(value).then((value1) => {
            for (int i = 0; i < listTask.length; i++)
              {
                getListTaskID(adminId, listTask[i]["taskId"]),
                print(dataList)
              }
          });
    });
    print(listTask);
    print(dataList);
    // for (var controller in titleChildController) {
    //   Map<String, dynamic> map = {
    //     'title': controller.text,
    //   };
    //   tmpList.add(map);
    // }
    // for (var controller in contentChildController) {
    //   Map<String, dynamic> map = {
    //     'content': controller.text,
    //   };
    //   tmpList.add(map);
    // }
    // dataList.addAll(tmpList);
    // print(dataList);
    // for (var controller in titleController) {
    //   Map<String, dynamic> map = {
    //     'title': controller.text,
    //   };
    //   tmpList.add(map);
    // }
    // for (var controller in contentController) {
    //   Map<String, dynamic> map = {
    //     'content': controller.text,
    //   };
    //   tmpList.add(map);
    // }
    // listTask.addAll(tmpList);
    // print(listTask);
    // tmpList.clear();
    
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in titleController) {
      controller.dispose();
    }
    for (var controller in contentController) {
      controller.dispose();
    }
    for (var controller in titleChildController) {
      controller.dispose();
    }
    for (var controller in contentChildController) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 51, 122, 245),
        leading: Builder(
            builder: (context) => IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ))),
        title: const Text('Add Task',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      body: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
              flex: 4,
              child: Container(
                child: ListView.builder(
                    itemCount: widget.count,
                    itemBuilder: (BuildContext context, int i) {
                      return DragTarget(
                        builder: (BuildContext context,
                            List<dynamic> candidateData,
                            List<dynamic> rejectedData) {
                          return Card(
                            color: const Color.fromARGB(255, 209, 162, 9),
                            elevation: 8,
                            child: ListTile(
                              title: TextField(
                                controller: titleController[i],
                                decoration: InputDecoration(hintText: "Title"),
                                style: GoogleFonts.montserrat(),
                              ),
                              subtitle: TextField(
                                controller: contentController[i],
                                decoration:
                                    InputDecoration(hintText: "Content"),
                                style: GoogleFonts.montserrat(),
                              ),
                              trailing: Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.green.shade800,
                              ),
                              onTap: () {
                                setState(() {
                                  tabChildNumber = i;
                                  // getDataTask(adminId, taskList[i]['taskId'])
                                  //     .then((value) {
                                  //   setValue(i);
                                  // });
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
                              addTaskToIndexTask(dataList[i]["taskId"], userId,
                                  dataList[i]["taskName"], dataList[i]["note"]);
                            }
                          });
                        },
                      );
                    }),
              )),
          Expanded(
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      number++;
                      TextEditingController newTitleController =
                          TextEditingController();
                      TextEditingController newContentController =
                          TextEditingController();
                      titleChildController.add(newTitleController);
                      contentChildController.add(newContentController);
                      // Map<String, dynamic> map = {
                      //   'title': newTitleController.text,
                      //   'content': newContentController.text,
                      // };
                      // dataList.add(map);
                    });
                  },
                  icon: Icon(Icons.add))),
          if (number >= 0)
            Expanded(
              flex: 6,
              child: Container(
                child: ListView.builder(
                  itemCount: number,
                  itemBuilder: (BuildContext context, int index) {
                    return Draggable(
                        data: dataList[index],
                        feedback: SizedBox(
                          width: 300,
                          height: 120,
                          child: Card(
                              color: const Color.fromARGB(255, 209, 162, 9),
                              elevation: 8,
                              child: ListTile(
                                title: Column(
                                  children: [
                                    TextField(
                                      controller: titleChildController[index],
                                      decoration:
                                          InputDecoration(hintText: "Title"),
                                      style: GoogleFonts.montserrat(),
                                    ),
                                    TextField(
                                      controller: contentChildController[index],
                                      decoration:
                                          InputDecoration(hintText: "Content"),
                                      style: GoogleFonts.montserrat(),
                                    ),
                                  ],
                                ),
                                leading: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        number--;
                                        titleChildController = List.generate(
                                          number,
                                          (index) => TextEditingController(),
                                        );
                                        contentChildController = List.generate(
                                          number,
                                          (index) => TextEditingController(),
                                        );
                                      });
                                    },
                                    icon: Icon(Icons.remove)),
                              )),
                        ),
                        childWhenDragging: const SizedBox(),
                        child: SizedBox(
                          width: 300,
                          height: 120,
                          child: Card(
                              color: const Color.fromARGB(255, 209, 162, 9),
                              elevation: 8,
                              child: ListTile(
                                title: Column(
                                  children: [
                                    TextField(
                                      controller: titleChildController[index],
                                      decoration:
                                          InputDecoration(hintText: "Title"),
                                      style: GoogleFonts.montserrat(),
                                    ),
                                    TextField(
                                      controller: contentChildController[index],
                                      decoration:
                                          InputDecoration(hintText: "Content"),
                                      style: GoogleFonts.montserrat(),
                                    ),
                                  ],
                                ),
                                leading: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        number--;
                                        titleChildController = List.generate(
                                          number,
                                          (index) => TextEditingController(),
                                        );
                                        contentChildController = List.generate(
                                          number,
                                          (index) => TextEditingController(),
                                        );
                                      });
                                    },
                                    icon: Icon(Icons.remove)),
                              )),
                        ));
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
