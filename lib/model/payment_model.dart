


class PaymentModel {
  ///UID OF Payment
  String? uid;

  /// paypal data
  String? name;
  String? secreteKey;

  /// note
  String? note;

  ///photo url
  String? photoUrl;

  /// email
  String? email;
  String? mobile;

  String? role;

  ///number of products in currencyCode
  String? currencyCode;

  PaymentModel(
      {this.uid,
      this.name,
      this.secreteKey,
      this.note,
      this.currencyCode,
      this.photoUrl,
      this.email,
      this.mobile,
      this.role});

  PaymentModel.formMap(Map<dynamic, dynamic> map)
      : uid = map['uid'],
        name = map['name'],
        secreteKey = map['secreteKey'],
        note = map['note'],
        currencyCode = map['currencyCode'],
        photoUrl = map['photoUrl'],
        email = map['email'],
        mobile = map['mobile'],
        role = map['role'];

  toMap() {
    return {
      'uid': uid,
      'name': name,
      'secreteKey': secreteKey,
      'note': note,
      'email': email,
      'currencyCode': currencyCode,
      'photoUrl': photoUrl,
      'mobile': mobile,
      'role': role,
    };
  }
}
