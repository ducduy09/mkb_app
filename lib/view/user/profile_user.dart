// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:mkb_technology/models/users.dart';
import 'package:mkb_technology/view/user/edit_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUser extends StatefulWidget {
  const ProfileUser({super.key});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  int _selectedIndex = 0;
  User? user;

  void initPreferences() async {
    SharedPreferences pref;
    pref = await SharedPreferences.getInstance();
    setState(() {
      if (pref.getString("user") != null) {
        user = User.fromJson(jsonDecode(pref.getString("user")!));
      }
    });
  }

  @override
  void initState() {
    initPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            //image user
            child: Image.asset(
              user != null ? "${user!.avatar}" : "assets/images/1.jpg",
              fit: BoxFit.cover,
            ),
          ),
          DraggableScrollableSheet(
            //minChildSize: 0.5,
            initialChildSize: 0.52,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //for user profile header
                      Container(
                        padding:
                            const EdgeInsets.only(left: 32, right: 32, top: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            user != null || user?.avatar != null
                                ? SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: ClipOval(
                                      child: Image.asset(
                                        user != null
                                            ? "${user!.avatar}"
                                            : "assets/images/1.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ))
                                : CircularProfileAvatar(
                                    "https://st.depositphotos.com/2101611/3925/v/600/depositphotos_39258143-stock-illustration-businessman-avatar-profile-picture.jpg"),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    user != null ? "${user!.name}" : "Null",
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        fontFamily: "Roboto",
                                        fontSize: 36,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    user != null
                                        ? "Age: ${user!.age}"
                                        : "assets/images/1.jpg",
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontFamily: "Roboto",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  // print(dataList);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const EditInfoPage(),
                                      ));
                                },
                                icon: const Icon(
                                  Icons.settings,
                                  color: Colors.blue,
                                  size: 40,
                                ))
                          ],
                        ),
                      ),

                      //performace bar

                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        padding: const EdgeInsets.all(32),
                        color: Colors.blue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                const Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.place,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "ADDRESS",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Roboto",
                                          fontSize: 24),
                                    )
                                  ],
                                ),
                                Text(
                                  user != null ? " ${user!.address}" : "",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Roboto",
                                      fontSize: 15),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                const Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.wallet,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "WALLET",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Roboto",
                                          fontSize: 24),
                                    )
                                  ],
                                ),
                                Text(
                                  user != null ? "${user!.wallet}" : "",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Roboto",
                                      fontSize: 15),
                                )
                              ],
                            ),
                            const Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "5",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Roboto",
                                          fontSize: 24),
                                    )
                                  ],
                                ),
                                Text(
                                  "Ratings",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Roboto",
                                      fontSize: 15),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),
                      //container for about me

                      Container(
                        padding: const EdgeInsets.only(left: 32, right: 32),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "About Me",
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Roboto",
                                  fontSize: 18),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              "Hello, this is maaz, and I am from easy approach, and this is just a demo text for information about me"
                              "Hello, this is maaz, and I am from easy approach, and this is just a demo text for information about me",
                              style:
                                  TextStyle(fontFamily: "Roboto", fontSize: 15),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),
                      //Container for clients

                      Container(
                        padding: const EdgeInsets.only(left: 32, right: 32),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Clients",
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Roboto",
                                  fontSize: 18),
                            ),

                            const SizedBox(
                              height: 8,
                            ),
                            //for list of clients
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 64,
                              height: 80,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    margin: const EdgeInsets.only(right: 8),
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/images/${index + 1}.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                                itemCount: 5,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                              ),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      //Container for reviews

                      Container(
                        padding: const EdgeInsets.only(left: 32, right: 32),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Reviews",
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 18,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 64,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Client $index",
                                              style: const TextStyle(
                                                  color: Colors.lightBlue,
                                                  fontSize: 18,
                                                  fontFamily: "Roboto",
                                                  fontWeight: FontWeight.w700)),
                                          const Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.star,
                                                color: Colors.orangeAccent,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Colors.orangeAccent,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Colors.orangeAccent,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                          "He is very fast and good at his work",
                                          style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 14,
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w400)),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  );
                                },
                                itemCount: 8,
                                shrinkWrap: true,
                                controller:
                                    ScrollController(keepScrollOffset: false),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 28.0,
        unselectedItemColor: const Color.fromARGB(255, 107, 105, 105),
        fixedColor: const Color(0xFFE63426),
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.shifting,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          // Xử lý sự kiện khi mục được nhấn
          switch (index) {
            case 0:
              Navigator.pop(context);
              break;
            case 1:
              // Xử lý sự kiện cho mục thứ hai
              break;
            case 2:
              // Xử lý sự kiện cho mục thứ ba
              break;
            case 3:
              // Xử lý sự kiện cho mục thứ tư

              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: '',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE63426),
        child: const Icon(Icons.add_a_photo),
        onPressed: () {},
      ),
    );
  }
}
