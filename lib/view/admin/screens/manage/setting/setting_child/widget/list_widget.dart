import 'package:flutter/material.dart';
import 'package:mkb_technology/helper/widget_helper.dart';

import 'edit_widgets.dart';
import 'insert_widget.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  List<Map<String, dynamic>> dataList = [];

  void getWidget() async {
    List<Map<String, dynamic>> listSlide = await WidgetHelper.getData();
    setState(() {
      dataList = listSlide;
    });
  }

  void deleteWidget(String wdgid, String prdId, String type) async {
    WidgetHelper.deleteProductWidget(wdgid, prdId, type);
    List<Map<String, dynamic>> listSlide = await WidgetHelper.getData();
    setState(() {
      dataList = listSlide;
    });
  }

  @override
  void initState() {
    getWidget();
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
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ))),
          title: const Text('List Widget User',
              style: TextStyle(
                color: Colors.white,
              )),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InsertWidget(),
                          ));
                    },
                    child: const Text('Insert Widget')),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Warning !!!'),
                                  backgroundColor: Colors.white38,
                                  content:
                                      const Text('This Widget  - unblock?'),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton(
                                      child: const Text('Edit'),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditWidget(data: dataList, id: index),
                                            ));
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ID:   ${dataList[index]["widgetId"]}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        ),
                                        Text(
                                          "Title:   ${dataList[index]["title"]}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          //width: 100,
                                          height: 20,
                                          //alignment: Alignment.center, // Đặt container ở góc trái
                                          child: Text(
                                            "${dataList[index]["productId"]}",
                                          ),
                                        ),
                                        SizedBox(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              deleteWidget(
                                                  dataList[index]["widgetId"]
                                                      .toString(),
                                                  dataList[index]["productId"]
                                                      .toString(),
                                                  dataList[index]["type"]
                                                      .toString());
                                            },
                                            child: const Text("Delete"),
                                          ),
                                        )
                                      ],
                                    ),
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
