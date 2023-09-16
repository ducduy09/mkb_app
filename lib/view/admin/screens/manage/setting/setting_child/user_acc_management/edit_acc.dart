import 'package:flutter/material.dart';
import 'package:mkb_technology/helper/users.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({super.key});

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  List<Map<String, dynamic>> dataList = [];

  void getTransaction() async {
    List<Map<String, dynamic>> listSlide =
        await UserHelper.getDataByType("Guest");
    setState(() {
      dataList = listSlide;
    });
  }

  void deleteAccount(String id, int a) async {
    UserHelper.deleteUser(id, a);
    List<Map<String, dynamic>> listSlide =
        await UserHelper.getDataByType("Guest");
    setState(() {
      dataList = listSlide;
    });
  }
  @override
  void initState(){
    getTransaction();
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
          title: const Text('List Account User',
              style: TextStyle(
                color: Colors.white,
              )),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                // ElevatedButton(
                //     onPressed: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => const InsertSlider()));
                //     },
                //     child: const Text('Insert Slider')),
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
                                  content: const Text('This account will be banned - unblock?'),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton(
                                      child: const Text('Banned'),
                                      onPressed: () {
                                        UserHelper.bannedAccount(dataList[index]["userId"]);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton(
                                      child: const Text('Unblock'),
                                      onPressed: () {
                                        UserHelper.unBlockAccount(dataList[index]["userId"]);
                                        Navigator.of(context).pop();
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
                                          "ID:   ${dataList[index]["userId"]}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        ),
                                        Text(
                                          "Status:   ${dataList[index]["status"]}",
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
                                            dataList[index]['userName'],
                                          ),
                                        ),
                                        SizedBox(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              deleteAccount(
                                                  dataList[index]["userId"], 1);
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
