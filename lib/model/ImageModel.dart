class ImageModel {
  ///UID OF USER
  String? shopUID;
  String? imageUrl;
  String? key;

  ImageModel(
      {required this.shopUID,required this.imageUrl,required this.key});

  ImageModel.fromMap(Map<dynamic, dynamic> map)
      : shopUID = map['shopUid'],
        key = map['key'],
        imageUrl = map['imageUrl'];

  Map<String, Object?> toMap() {
    final map = {
      'shopUid': shopUID,
      'key': key,
      'imageUrl': imageUrl,
    };
    map.removeWhere((key, value) => value==null);
    return map;
  }
}
