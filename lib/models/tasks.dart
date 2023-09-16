import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:core';

class Tasks {
  late String taskId;
  late String taskName;
  late int userId;
  late String content;
  String? createTime = DateTime.now().toString();
  late String? completeTime;
  int status;
  //final String warehourseCode;
  Tasks({
      required this.taskId, 
      required this.userId, 
      required this.taskName, 
      required this.content, 
      this.createTime,
      this.completeTime,
      this.status = 0
      //required this.warehourseCode,
  });

  Tasks.fromMap(Map<String, dynamic> res)
      : taskId = res["taskId"],
        userId = res["userId"],
        taskName = res["taskName"],
        content = res["content"],
        createTime = res["createTime"],
        completeTime = res["completeTime"],
        status = res["status"];
      //  warehourseCode = res["warehourseCode"];

  Map<String, dynamic> toMap() {  
    return {  
      'taskId': taskId,  
      'userId': userId,  
      'taskName': taskName,
      'content': content,  
      'createTime': createTime,
      'completeTime': completeTime,  
      'status': status,   
      //'warehourseCode': warehourseCode,
    };  
  }  
  DataGridRow getDataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell<String>(columnName: 'taskId', value: taskId),
      DataGridCell<int>(columnName: 'userId', value: userId),
      DataGridCell<String>(columnName: 'taskName', value: taskName),
      DataGridCell<String>(columnName: 'content', value: content),
      DataGridCell<String>(columnName: 'createTime', value: createTime),
      DataGridCell<String>(columnName: 'completeTime', value: completeTime),
      DataGridCell<int>(columnName: 'status', value: status),
    ]);
  }
}