class OfferModel {
  ///UID OF USER
  String? shopUID;
  String? imageUrl;
  String? key;
  String? status;

  OfferModel(
      {required this.shopUID,required this.imageUrl,required this.key});

  OfferModel.fromMap(Map<dynamic, dynamic> map)
      : shopUID = map['shopUid'],
        key = map['key'],
        status=map['status'],
        imageUrl = map['imageUrl'];

  Map<String, Object?> toMap() {
    final map = {
      'shopUid': shopUID,
      'key': key,
      'imageUrl': imageUrl,
      'status': status
    };
    map.removeWhere((key, value) => value==null);
    return map;
  }
}