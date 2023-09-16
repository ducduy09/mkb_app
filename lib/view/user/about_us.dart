import 'package:flutter/material.dart';
//import 'main.dart';
import 'drawer.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _AboutUstWidgetState();
}

class _AboutUstWidgetState extends State<MyWidget> {
  String? cauhoi2;
  void setAnswer2(value){
  setState(() {
      cauhoi2 = value.toString();
  });
}
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}
class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 51, 122, 245),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          icon: const Icon(Icons.menu,color: Colors.white,))
        ), 
        title: Container(
          alignment: Alignment.center,
          child: const Text(
          //   widget.title,
            'ABOUT US',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 30),
          ),
        ),
      ),
      drawer: const MyWidgetDrawer(isCase: 3),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1300.0,
          ), child: ListView(
              children: [
                FittedBox(
                  fit: BoxFit.cover,
                  child: Image.asset('assets/images/address.jpg', width: 500, height: 220,),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.home,color: Colors.black,
                  ),
                  title: Text('Địa chỉ: 63 Cổ Linh, Hanoi, Vietnam, 100000', style: TextStyle(color: Colors.black),),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.phone,color: Colors.black
                  ),
                  title: Text('SĐT: 035 688 8669',style: TextStyle(color: Colors.black)),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.email,color: Colors.black
                  ),
                  title: Text('Email: mkb.tech.vn@gmail.com',style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
      )
      )
    );
      // GridView.count(
      //   crossAxisCount: 3,
      //   children: [
      //     for(var i = 0; i < 50; i ++)
      //         Image.network("https://picsum.photos/250?image=$i")
      //   ],);   
  }
}