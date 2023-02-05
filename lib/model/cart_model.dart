class CartModel {
  ///UID OF USER
  String? buyerUID;
  String? sellerUID;

  ///unique key of the cart
  String? key;
  String? name;

  /// product
  String? productKey;
  DateTime? date;
  num? quantity;
  num? price;
  num? deliveryCharge;

  CartModel(
      {required this.buyerUID,
      required this.key,
      required this.price,
      required this.sellerUID,
      required this.name,
      required this.productKey,
      required this.deliveryCharge,
      required this.quantity,
      required this.date});

  CartModel.fromMap(Map<dynamic, dynamic> map)
      : buyerUID = map['buyerUID'],
        key = map['key'],
        productKey = map['productKey'],
        price = map['price'],
        sellerUID = map['sellerUID'],
        name = map['name'],
        deliveryCharge = map['deliveryCharge'],
        quantity = map['quantity'],
        date = DateTime.tryParse(map['date'] ?? "");

  Map<String, Object?> toMap() {
    final map = {
      'buyerUID': buyerUID,
      'key': key,
      'productKey': productKey,
      'price': price,
      'name': name,
      'sellerUID': sellerUID,
      'deliveryCharge': deliveryCharge,
      'quantity': quantity,
      'date': date?.toIso8601String(),
    };
    map.removeWhere((key, value) => value==null);
    return map;
  }
}
