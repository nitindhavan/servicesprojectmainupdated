import 'package:WeServeU/model/address_model.dart';
import 'package:intl/intl.dart';

import '../data/constants.dart';

class OrderModel {
  ///UID OF USER
  String? buyerUID;
  String? sellerUID;
  String? driverUID;

  String? productName;
  ///unique key of the cart
  String? key;
  String? note;

  /// product
  String? productKey;

  DateTime? date;
  num? quantity;
  num? price;
  num? deliveryCharge;

  ///payment
  String? paymentMethod;
  String? shippingStatus;
  String? paymentStatus;
  String? paymentId;
  String? orderId;
  String? signature;
  AddressModel? addressModel;
  int? rating;
  double? appEarning;
  String? deliveryTime;

  ///below part is used for to know notification delivery status
  ///
  bool? isOrderNotificationSent;
  bool? isDeliveryStatusNotificationSent;
  OrderModel(
      {required this.buyerUID,
      required this.key,
      required this.price,
      required this.deliveryCharge,
      required this.addressModel,
      required this.productKey,
      required this.isOrderNotificationSent,
      required this.isDeliveryStatusNotificationSent,
      required this.orderId,
      required this.paymentId,
      required this.shippingStatus,
      required this.paymentMethod,
      required this.sellerUID,
      required this.paymentStatus,
      required this.signature,
      required this.quantity,
      required this.date,
        required this.driverUID,
        required this.appEarning,
      required this.rating,required this.note,required this.deliveryTime});

  OrderModel.fromMap(Map<dynamic, dynamic> map)
      : buyerUID = map['buyerUID'],
        key = map['key'],
        signature = map['signature'],
        paymentId = map['paymentId'],
        paymentMethod = map['paymentMethod'],
        paymentStatus = map['paymentStatus'],
        isDeliveryStatusNotificationSent = map['isDeliveryStatusNotificationSent'],
        isOrderNotificationSent = map['isOrderNotificationSent'],
        sellerUID = map['sellerUID'],
        shippingStatus = map['shippingStatus'].toString(),
        orderId = map['orderId'],
  driverUID=map['driverUID'],
  deliveryTime=map['deliveryTime'],
        addressModel = map['addressModel'] == null
            ? null
            : AddressModel.fromMap(map['addressModel']),
        productKey = map['productKey'],
        price = map['price'],
        deliveryCharge = map['deliveryCharge'],
        quantity = map['quantity'],
  note=map['note'],
  appEarning=(double.tryParse(map['appEarning'].toString()) ?? int.tryParse(map['appEarning'].toString()) ?? 0).toDouble(),
        date = DateTime.tryParse(map['date'] ?? "",),
  rating=map['rating'];

  Map<String, Object?> toMap() {
    final map = {
      'buyerUID': buyerUID,
      'key': key,
      'productKey': productKey,
      'price': price,
      'paymentId': paymentId,
      'sellerUID': sellerUID,
      'deliveryTime': deliveryTime,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'driverUID': driverUID,
      'isDeliveryStatusNotificationSent': isDeliveryStatusNotificationSent,
      'isOrderNotificationSent': isOrderNotificationSent,
      'signature': signature,
      'shippingStatus': shippingStatus,
      'orderId': orderId,
      'deliveryCharge': deliveryCharge,
      'quantity': quantity,
      'addressModel': addressModel == null ? null : addressModel!.toMap(),
      'date': date?.toIso8601String(),
      'rating':rating,
      'appEarning': appEarning,
      'note': note,
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  String toMultiLine() {
    var paymentDetails = [];
    if (paymentStatus.toString().toLowerCase().contains('paid')) {
      paymentDetails = [
        'Order Id: ${orderId ?? '-'}',
        'Payment Id: ${paymentId ?? '-'}',
        'Payment Method: ${paymentMethod ?? '-'}',
      ];
    }
    List list = [
      'Quantity: $quantity',
      'Total Price: $currency $price',
      'Payment Status: $paymentStatus',
      'Shipping Status: $shippingStatus',
      'Order Date: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(date!)}',
    ];
    list.addAll(paymentDetails);

    return list.join('\n');
  }
}
