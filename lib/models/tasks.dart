import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:core';

class Tasks {
  late String taskId; 
  late String taskChildId;
  late String taskChildName;
  late String? content;
  String? createTime = DateTime.now().toString();
  late String? completeTime;
  int status;
  Tasks({
      required this.taskId, 
      required this.taskChildId, 
      required this.taskChildName, 
      this.content, 
      this.createTime,
      this.completeTime,
      this.status = 0
  });

  Tasks.fromMap(Map<String, dynamic> res)
      : taskId = res["taskId"],
        taskChildId = res["taskChildId"],
        taskChildName = res["taskChildName"],
        content = res["content"],
        createTime = res["createTime"],
        completeTime = res["completeTime"],
        status = res["status"];

  Map<String, dynamic> toMap() {  
    return {  
      'taskId': taskId,  
      'taskChildId': taskChildId,  
      'taskChildName': taskChildName,
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
      DataGridCell<String>(columnName: 'taskChildId', value: taskChildId),
      DataGridCell<String>(columnName: 'taskChildName', value: taskChildName),
      DataGridCell<String>(columnName: 'content', value: content),
      DataGridCell<String>(columnName: 'createTime', value: createTime),
      DataGridCell<String>(columnName: 'completeTime', value: completeTime),
      DataGridCell<int>(columnName: 'status', value: status),
    ]);
  }
}