
class ProductModel {
  ///sellerUID OF USER
  String? sellerUID;

  ///unique key of the product
  String? key;

  /// name
  String? name;
  num? price;
  num? deliveryCharge;
  String? currency;

  String? type;

  List<Object?>? photoUrl;

  List<Object?>? videoUrl;

  num? quantity;
  num? stock;

  num? offer;

  ///only live product will be available to client
  bool? live;

  String? desc;

  ProductModel(
      {this.sellerUID,
      this.name,
      this.key,
      this.price,
      this.stock,
      this.deliveryCharge,
      this.photoUrl,
      required this.currency,
      this.live,
      this.quantity,
         this.desc,
      this.type,this.offer,this.videoUrl});

  ProductModel.fromMap(Map<dynamic, dynamic> map)
      : sellerUID = map['sellerUID'],
        name = map['name'],
        price = map['price'],
        stock = map['stock'],
        live = map['live'],
        deliveryCharge = map['deliveryCharge'],
        quantity = map['quantity'],
        currency = map['currency'],
        photoUrl = map['photoUrl'],
        videoUrl=map['videoUrl'],
        key = map['key'],
        offer=map['offer'],
        desc=map['desc'],
        type = map['type'];

  toMap() {
    return {
      'sellerUID': sellerUID,
      'name': name,
      'quantity': quantity,
      'stock': stock,
      'currency': currency,
      'photoUrl': photoUrl,
      'price': price,
      'deliveryCharge': deliveryCharge,
      'live': live,
      'key': key,
      'offer':offer,
      'desc':desc,
      'type': type,
      'videoUrl': videoUrl
    };
  }
}
