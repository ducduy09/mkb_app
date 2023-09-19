import 'package:flutter/material.dart';

import 'add_person.dart';

class MenuButtons extends StatefulWidget {
  @override
  _MenuButtonsState createState() => _MenuButtonsState();
}

class _MenuButtonsState extends State<MenuButtons> {
  bool showButtons = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (showButtons)
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.blue, // Đặt màu nền tại đây
                  shape: BoxShape.circle, // Optional: Đặt hình dạng của container (ví dụ: hình tròn)
                ),
                child: IconButton(
                  hoverColor: Colors.blue[700],
                  icon: const Icon(Icons.insert_invitation),
                  onPressed: () {
                    // Xử lý khi ấn vào nút
                  },
                  color: Colors.white, // Đặt màu cho biểu tượng
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.blue, // Đặt màu nền tại đây
                  shape: BoxShape.circle, // Optional: Đặt hình dạng của container (ví dụ: hình tròn)
                ),
                child: IconButton(
                  icon: const Icon(Icons.person),
                  hoverColor: Colors.blue[700],
                  onPressed: () {
                    // Xử lý khi ấn vào nút
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  DragAndDropExample(),));
                  },
                  color: Colors.white, // Đặt màu cho biểu tượng
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.blue, // Đặt màu nền tại đây
                  shape: BoxShape.circle, // Optional: Đặt hình dạng của container (ví dụ: hình tròn)
                ),
                child: IconButton(
                  hoverColor: Colors.blue[700],
                  icon: const Icon(Icons.add_task),
                  onPressed: () {
                    showDialog(context: context, builder: (BuildContext context) {
                      return const AlertDialog(
                        
                      );});
                  },
                  color: Colors.white, // Đặt màu cho biểu tượng
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        FloatingActionButton(
          hoverColor: Colors.amber[700],
          backgroundColor: Colors.amber,
          onPressed: () {
            setState(() {
              showButtons = !showButtons;
            });
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}