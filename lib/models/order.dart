class Orders {
  final String tradingCode;
  final String productId;
  final String userId;
  final String address;
  final double price;
  int quantity;
  int complete;
  int isCart;
  int isConfirm;

  Orders({
    required this.tradingCode,
    required this.productId,
    required this.userId,
    required this.address,
    required this.price,
    this.quantity = 0,
    required this.complete,
    required this.isCart,
    this.isConfirm = 0,
  });

  Orders.fromMap(Map<String, dynamic> res)
      : tradingCode = res["tradingCode"],
        productId = res["productId"],
        userId = res["userId"],
        address = res["address"],
        price = res["price"],
        quantity = res["quantity"],
        complete = res["complete"],
        isCart = res["isCart"],
        isConfirm = res["isConfirm"];

  Map<String, dynamic> toMap() {
    return {
      'tradingCode' : tradingCode,
      'productId': productId,
      'userId': userId,
      'address': address,
      'price': price,
      'quantity': quantity,
      'complete': complete,
      'isCart': isCart,
      'isConfirm': isConfirm
    };
  }
}
