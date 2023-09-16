import 'package:flutter/material.dart';

import 'package:mkb_technology/helper/DbHelper.dart';
import 'package:mkb_technology/view/admin/screens/main/components/side_menu.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:mkb_technology/view/admin/screens/manage/user/edit_user.dart';

class ListUserPage extends StatefulWidget {
  const ListUserPage({super.key});

  @override
  State<ListUserPage> createState() => _ListUserPageState();
}

class _ListUserPageState extends State<ListUserPage> {
  List<Map<String, dynamic>> dataList = [];
  final _nameController = TextEditingController();
  final _avtController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();

  void _fetchUsers() async {
    List<Map<String, dynamic>> userList = await DatabaseHelper.getData();
    setState(() {
      dataList = userList;
    });
  }

  @override
  void initState() {
    _fetchUsers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _avtController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          title: const Text('MKB Technology',
              style: TextStyle(
                color: Colors.white,
              )),
        ),
        drawer: const SideMenu(isCase: 7),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            dataList[index]['name'],
                            style: const TextStyle(color: Colors.amber),
                          ),
                          subtitle: Text('Age: ${dataList[index]['age']}',
                              style: const TextStyle(color: Colors.black)),
                          trailing: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditUserPage(data: dataList, id: index)));
                              },
                              icon: const Icon(Icons.edit, color: Colors.amber,)),
                        );
                      }),
                )
              ],
            ),
          ),
        ));
  }
}
