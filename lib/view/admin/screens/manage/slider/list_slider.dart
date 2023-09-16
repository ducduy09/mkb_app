// import 'package:google_fonts/google_fonts.dart';
// import 'package:mkb_technology/helper/orderHelper.dart';
import 'package:flutter/material.dart';
import 'package:mkb_technology/helper/sliderHelper.dart';
// import 'package:mkb_technology/view/admin/screens/main/components/side_menu.dart';
import 'package:mkb_technology/view/admin/screens/manage/slider/edit_slider.dart';
import 'package:mkb_technology/view/admin/screens/manage/slider/insert_slider.dart';
// import 'package:mkb_technology/view/admin/screens/manage/transaction/edit_order.dart';
// import 'package:provider/provider.dart';

class ListSlider extends StatefulWidget {
  const ListSlider({super.key});

  @override
  State<ListSlider> createState() => _ListSliderState();
}

class _ListSliderState extends State<ListSlider> {
  List<Map<String, dynamic>> dataList = [];

  void getSlider() async {
    List<Map<String, dynamic>> listSlide = await SliderHelper.getData();
    setState(() {
      dataList = listSlide;
    });
  }
  void deleteSlider(int id) async {
    SliderHelper.deleteSlide(id);
    List<Map<String, dynamic>> listSlide = await SliderHelper.getData();
    setState(() {
      dataList = listSlide;
    });
  }
  @override
  void initState(){
    getSlider();
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
          title: const Text('List Slider',
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
                              builder: (context) => const InsertSlider()));
                    },
                    child: const Text('Insert Slider')),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditSlider(
                                          data: dataList,
                                          id: index,
                                        )));
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
                                          "${dataList[index]["slideId"]}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.favorite_outline,
                                          color: Colors.red,
                                        )
                                      ],
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: 100,
                                              height: 100,
                                              //alignment: Alignment.center, // Đặt container ở góc trái
                                              child: Image.asset(
                                                dataList[index]['image_path'],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  deleteSlider(dataList[index]["slideId"]);
                                                },
                                                child: const Text("Delete"),
                                              ),
                                            )
                                          ],
                                        )),
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
