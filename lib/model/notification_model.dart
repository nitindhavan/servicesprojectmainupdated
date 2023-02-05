import 'package:WeServeU/model/address_model.dart';

class OrderModel {
  ///UID OF USER
  String? buyerUID;
  String? sellerUID;

  ///unique key of the cart
  String? key;
  String? providerId;

  /// product
  String? productKey;

  DateTime? date;
  num? quantity;
  num? price;
  num? deliveryCharge;

  ///payment
  String? paymentMethod;
  String? paymentStatus;
  String? paymentId;
  String? orderId;
  String? signature;
  AddressModel? addressModel;

  OrderModel(
      {required this.buyerUID,
      required this.key,
      required this.price,
      required this.deliveryCharge,
      required this.addressModel,
      required this.productKey,
      required this.providerId,
      required this.orderId,
      required this.paymentId,
      required this.sellerUID,
      required this.signature,
      required this.quantity,
      required this.date});

  OrderModel.fromMap(Map<dynamic, dynamic> map)
      : buyerUID = map['buyerUID'],
        key = map['key'],
        signature = map['signature'],
        paymentId = map['paymentId'],
        sellerUID = map['sellerUID'],
        orderId = map['orderId'],
        addressModel = map['addressModel'] == null
            ? null
            : AddressModel.fromMap(map['addressModel']),
        productKey = map['productKey'],
        price = map['price'],
        deliveryCharge = map['deliveryCharge'],
        providerId = map['providerId'],
        quantity = map['quantity'],
        date = DateTime.tryParse(map['date'] ?? "");

  Map<String, Object?> toMap() {
    final map = {
      'buyerUID': buyerUID,
      'key': key,
      'productKey': productKey,
      'price': price,
      'paymentId': paymentId,
      'sellerUID': sellerUID,
      'signature': signature,
      'orderId': orderId,
      'deliveryCharge': deliveryCharge,
      'providerId': providerId,
      'quantity': quantity,
      'addressModel': addressModel == null ? null : addressModel!.toMap(),
      'date': date?.toIso8601String(),
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
