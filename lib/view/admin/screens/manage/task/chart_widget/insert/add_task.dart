// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:mkb_technology/helper/index_task_helper.dart';
import 'package:mkb_technology/helper/task_helper.dart';
import 'package:mkb_technology/models/index_task.dart';
import 'package:mkb_technology/models/tasks.dart';
import 'package:mkb_technology/models/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<StatefulWidget> createState() => AddTaskState();
}

class AddTaskState extends State {
  late SharedPreferences pref;
  UserLogin? user;
  int adminId = 0;
  late FToast fToast;
  // Danh sách các giá trị checkbox đã chọn
  late List<List<bool>> _checked = [];
  List<TextEditingController> titleController = [];
  List<TextEditingController> contentController = [];
  List<Map<String, dynamic>> taskList = [];
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> insertList = [];
  final List<Tasks> task = <Tasks>[];

  Future<void> getListTask(int id) async {
    // lấy danh sách task board của admin đó
    List<Map<String, dynamic>> list = await IndexTaskHelper.getListTask(id);
    setState(() {
      taskList = list;
    });
  }

  Future<int> getIdAdmin() async {
    // lấy id của admin hiện tại đang đăng nhập
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

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    titleController = List.generate(
      100,
      (index) => TextEditingController(),
    );
    contentController = List.generate(
      100,
      (index) => TextEditingController(),
    );
    getIdAdmin().then((value) {
      getListTask(adminId).then((value) {
        _checked = List.generate(
          taskList.length,
          (i) => List.generate(50, (j) => false),
        );
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

  // void setValue(int id) {
  //   // set giá trị cho nút ấn checkbox, giá trị lấy từ bảng tasks cột status ( đã hoàn thành chưa ? )
  //   int i = 0;
  //   setState(() {
  //     while (i < dataList.length) {
  //       if (dataList[i]['status'] == 1) {
  //         _checked[id][i] = true;
  //       } else {
  //         _checked[id][i] = false;
  //       }
  //       i++;
  //     }
  //   });
  // }

  // void updateStatus(String taskID, String tcId, int status, String date) async {
  //   // cập nhật giá trị status lúc ấn nút checkbox
  //   try {
  //     await TaskHelper.changeStatus(taskID, tcId, status, date);
  //     print("update success");
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> getDataTask(String id) async {
    // lấy danh sách task của bảng indexTask
    List<Map<String, dynamic>> list = await TaskHelper.getListTask(id);
    setState(() {
      dataList = list;
      insertList.clear();
    });
  }

  Future<void> deleteDataTask(String id, String taskId) async {
    // lấy danh sách task của bảng indexTask
    await TaskHelper.deleteTask(id, taskId);
    List<Map<String, dynamic>> list = await TaskHelper.getListTask(id);
    setState(() {
      dataList = list;
    });
  }

  // void addProduct(List<Map<String, dynamic>> list) {
  //   setState(() {
  //     for (int index = 0; index < list.length; index++) {
  //       Tasks a = Tasks(
  //         taskId: list[index]["taskId"],
  //         taskChildId: list[index]["taskChildId"],
  //         taskChildName: list[index]["taskChildName"],
  //         content: list[index]["content"],
  //         createTime: list[index]["createTime"],
  //         completeTime: list[index]["completeTime"],
  //         status: list[index]["status"],
  //       );
  //       print(a);
  //       task.add(a);
  //     }
  //   });
  // }

  void addItemToInsertList(String idTask, String title, String content) {
    int count = dataList.length;
    int countl = insertList.length;
    int id = count + countl;
    print(count);
    print(countl);
    print(idTask);
    print(title);
    print(content);
    Map<String, dynamic> map = {
      'taskId': idTask, // Thêm các giá trị mặc định tùy ý
      'taskChildId': "t$id",
      'taskChildName': title,
      'content': content,
      'createTime': DateTime.now().toString(),
      'completeTime': null,
      'status': 0,
    };
    setState(() {
      insertList.add(map);
    });
    print(insertList);
  }

  int tabChildNumber = 0;
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
          children: <Widget>[
            SizedBox(
              width: 500,
              child: ListView.builder(
                  itemCount: taskList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Card(
                      color: const Color.fromARGB(255, 209, 162, 9),
                      elevation: 8,
                      child: ListTile(
                        title: TextField(
                          //controller: titleController[i],
                          decoration: InputDecoration(
                            hintText: "Task ${i + 1}",
                          ),
                          style: GoogleFonts.montserrat(),
                        ),
                        subtitle: TextField(
                          //controller: contentController[i],
                          decoration: InputDecoration(
                              hintText: taskList[i]['taskName']),
                          style: GoogleFonts.montserrat(),
                        ),
                        onTap: () {
                          setState(() {
                            tabChildNumber = i;
                            getDataTask(
                              taskList[i]['taskId'],
                            );
                          });
                        },
                      ),
                    );
                  }),
            ),
            if (dataList.isNotEmpty)
              Expanded(
                  child: SingleChildScrollView(
                // Sử dụng SingleChildScrollView ở đây
                child: Column(children: <Widget>[
                  SizedBox(
                    width: 500,
                    child: ListView.builder(
                      shrinkWrap: true, // Thêm dòng này
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dataList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Column(
                            children: [
                              Text(
                                dataList[index]['taskChildName'] ?? "",
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                dataList[index]['content'] ?? "",
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF797575),
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                          leading: IconButton(
                              onPressed: () {
                                setState(() {
                                  deleteDataTask(dataList[index]['taskId'],
                                      dataList[index]['taskChildId']);
                                });
                              },
                              icon: const Icon(Icons.remove)),
                          trailing: SizedBox(
                            height: 100,
                            width: 100,
                            child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: (){
                                          setState(() {
                                            addItemToInsertList(dataList[index]['taskId'], "", "");
                                            print(dataList[index]['taskId']);
                                          });
                                        },
                                        icon: const Icon(Icons.add)),
                                    IconButton(
                                        onPressed: () {
                                          print(dataList[index]['taskId']);
                                        },
                                        icon: const Icon(Icons.save)),
                                  ],
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (insertList.isNotEmpty)
                    SizedBox(
                        width: 500,
                        height: 500,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: insertList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: const TextField(
                                    decoration: InputDecoration(
                                        hintText: "Title",
                                        hintStyle:
                                            TextStyle(color: Colors.black)),
                                    style: TextStyle(color: Colors.black),
                                  ),
                              subtitle: const TextField(
                                    decoration: InputDecoration(
                                        hintText: "Content",
                                        hintStyle: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w100)),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF797575),
                                        fontStyle: FontStyle.italic),
                                  ),
                              leading: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      insertList.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.remove)),
                              trailing: SizedBox(
                            height: 100,
                            width: 100,
                            child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: (){
                                          setState(() {
                                            addItemToInsertList(insertList[index]['taskId'], "", "");
                                            print(dataList[index]['taskId']);
                                          });
                                        },
                                        icon: const Icon(Icons.add)),
                                    IconButton(
                                        onPressed: () {
                                          print(insertList[index]['taskId']);
                                        },
                                        icon: const Icon(Icons.save)),
                                  ],
                                ),
                          ),
                            );
                            // ListTile(
                            //   title: Column(
                            //     children: [
                            //       Text(
                            //         insertList[index]['taskChildName'] ?? "",
                            //         style: const TextStyle(color: Colors.black),
                            //       ),
                            //       Text(
                            //         insertList[index]['content'] ?? "",
                            //         style: const TextStyle(
                            //             fontSize: 12,
                            //             color: Color(0xFF797575),
                            //             fontStyle: FontStyle.italic),
                            //       ),
                            //     ],
                            //   ),
                            //   leading: Checkbox(
                            //     value: _checked[tabChildNumber][index],
                            //     onChanged: (bool? value) {
                            //       setState(() {
                            //         _checked[tabChildNumber][index] = value!;
                            //         print(_checked[tabChildNumber][index]);
                            //       });
                            //     },
                            //   ),
                            // );
                          }, // Thêm dòng này
                        )),
                ]),
              ))
          ],
        ));
  }
}
