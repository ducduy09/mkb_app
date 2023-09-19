// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:mkb_technology/helper/task_helper.dart';
import 'package:mkb_technology/models/user_login.dart';
import 'package:mkb_technology/view/admin/screens/main/components/side_menu.dart';
import 'package:mkb_technology/view/admin/screens/manage/task/chart_widget/task_line_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

import 'source/app_resources.dart';
import 'chart_widget/indicator.dart';
import 'chart_widget/menu_button.dart';

class TaskPieChart extends StatefulWidget {
  const TaskPieChart({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  late SharedPreferences pref;
  UserLogin? user;
  int adminId = 0;
  late LineChartData lineChartData;
  List<LineChartBarData>? lineBarsData;
  List dataAvg = [];
  bool showAvg = false;

  int touchedIndex = -1;
  bool isOpen = true;
  int tabNumber = 1;
  // Danh sách các giá trị checkbox đã chọn
  late List<List<bool>> _checked = [];
  List<Map<String, dynamic>> taskList = [];
  List<Map<String, dynamic>> dataList = [];
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

  @override
  void initState() {
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

  void setValue(int id) {
    int i = 0;
    setState(() {
      while (i < dataList.length) {
        if (dataList[i]['status'] == 1) {
          _checked[id][i] = true;
        } else {
          _checked[id][i] = false;
        }
        i++;
      }
    });
  }

  void updateStatus(String taskID, int status, String date) async {
    try {
      await TaskHelper.changeStatus(taskID, adminId, status, date);
      print("update success");
    } catch (e) {
      print(e);
    }
  }

  Future<void> getDataTask(int adId, String id) async {
    List<Map<String, dynamic>> list = await TaskHelper.getTaskById(adId, id);
    setState(() {
      dataList = list;
    });
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
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ))),
          title: const Text('List Task',
              style: TextStyle(
                color: Colors.white,
              )),
        ),
        drawer: const SideMenu(isCase: 3),
        body: Row(
          children: <Widget>[
            // Menu bar ở bên trái
            if (isOpen == true)
              Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Text('Menu Bar'),
                    ),
                    ListTile(
                      title: const Text('My tasks statistics'),
                      onTap: () {
                        // Xử lý sự kiện khi người dùng chọn mục 1
                        if (tabNumber != 1) {
                          setState(() {
                            tabNumber = 1;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('List Task'),
                      onTap: () {
                        // Xử lý sự kiện khi người dùng chọn mục 2
                        if (tabNumber != 2) {
                          setState(() {
                            tabNumber = 2;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('Other statistics'),
                      onTap: () {
                        // Xử lý sự kiện khi người dùng chọn mục 2
                        if (tabNumber != 3) {
                          setState(() {
                            tabNumber = 3;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            Container(
              color: Colors.blue,
              child: Column(
                children: [
                  IconButton(
                      icon: const Icon(Icons.more_vert_outlined),
                      onPressed: () {
                        setState(() {
                          isOpen = !isOpen;
                        });
                      }),
                ],
              ),
            ),
            // Nội dung ở bên phải
            if (tabNumber == 1)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1.3,
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            height: 18,
                          ),
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback:
                                        (FlTouchEvent event, pieTouchResponse) {
                                      setState(() {
                                        if (!event
                                                .isInterestedForInteractions ||
                                            pieTouchResponse == null ||
                                            pieTouchResponse.touchedSection ==
                                                null) {
                                          touchedIndex = -1;
                                          return;
                                        }
                                        touchedIndex = pieTouchResponse
                                            .touchedSection!
                                            .touchedSectionIndex;
                                      });
                                    },
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 40,
                                  sections: showingSections(),
                                ),
                              ),
                            ),
                          ),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Indicator(
                                color: AppColors.contentColorBlue,
                                text: 'First',
                                isSquare: true,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Indicator(
                                color: AppColors.contentColorYellow,
                                text: 'Second',
                                isSquare: true,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Indicator(
                                color: AppColors.contentColorPurple,
                                text: 'Third',
                                isSquare: true,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Indicator(
                                color: AppColors.contentColorGreen,
                                text: 'Fourth',
                                isSquare: true,
                              ),
                              SizedBox(
                                height: 18,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            if (tabNumber == 3)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1.70,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 18,
                            left: 12,
                            top: 24,
                            bottom: 12,
                          ),
                          child: LineChart(
                            showAvg ? avgData(dataAvg) : mainData(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        height: 34,
                        child: TextButton(
                          onPressed: () {
                            lineChartData = mainData();
                            lineBarsData = lineChartData
                                .lineBarsData; // Danh sách các LineChartBarData
                            List<FlSpot> spots = lineBarsData![0].spots;
                            double sum = 0;
                            int count = 0;
                            setState(() {
                              for (FlSpot spot in spots) {
                                sum = sum + spot.y;
                                count++;
                              }
                              dataAvg.add(sum / count);
                              showAvg = !showAvg;
                            });
                          },
                          child: Text(
                            'avg',
                            style: TextStyle(
                              fontSize: 12,
                              color: showAvg
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            if (tabNumber == 2)
              Expanded(
                  child: Container(
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
                          onTap: () {
                            setState(() {
                              tabChildNumber = i;
                              getDataTask(adminId, taskList[i]['taskId'])
                                  .then((value) {
                                setValue(i);
                              });
                            });
                          },
                        ),
                      );
                    }),
              )),

            if (tabNumber == 2 && dataList.isNotEmpty)
              Expanded(
                child: Container(
                  child: ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Column(
                          children: [
                            Text(
                              dataList[index]['taskName'],
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(
                              dataList[index]['content'],
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF797575),
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        leading: Checkbox(
                          value: _checked[tabChildNumber][index],
                          onChanged: (bool? value) {
                            setState(() {
                              String date = DateTime.now().toString();
                              _checked[tabChildNumber][index] = value!;
                              print(_checked[tabChildNumber][index]);
                              _checked[tabChildNumber][index]
                                  ? updateStatus(
                                      dataList[index]['taskId'], 1, date)
                                  : updateStatus(
                                      dataList[index]['taskId'], 0, "");
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: tabNumber == 2 ? MenuButtons() : null);
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 80.0 : 60.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.contentColorBlue,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: AppColors.contentColorYellow,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: AppColors.contentColorPurple,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: AppColors.contentColorGreen,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
