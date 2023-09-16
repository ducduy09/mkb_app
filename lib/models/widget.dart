class Widget {
  final String widgetId;
  final String? title;
  final String productId;
  final String? type;
  final String content;

  const Widget({required this.widgetId,  this.title,required this.productId ,this.type,required this.content});
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'widgetId': widgetId,
      'title': title,
      'productId': productId,
      'type': type,
      'content': content
    };
    return map;
  }
  Widget.fromMap(Map<String, dynamic> res)
    : widgetId = res["widgetId"],
      title = res["title"],
      productId = res["productId"],
      type = res["type"],
      content = res["content"];

Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['widgetId'] = widgetId;
    data['title'] = title;
    data['productId'] = productId;
    data['type'] = type;
    data['content'] = content;
    return data;
  }
  Widget.fromJson(Map<String, dynamic> json) 
    : widgetId = json['widgetId'],
    title = json['title'],
    productId = json['productId'],
    type = json['type'],
    content = json['content'];
  
}