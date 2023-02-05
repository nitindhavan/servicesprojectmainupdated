
class WalletModel {
  ///UID OF wallet
  String? uid;

  /// name
  String? name;
  num amount;


  /// email
  String? email;
  String? mobile;
  ///number of products in currencyCode
  String? currencyCode;

  WalletModel(
      {this.uid,
      this.name,
      this.currencyCode,

      this.email,
      required this.amount,

      this.mobile,});

  WalletModel.formMap(Map<dynamic, dynamic> map)
      : uid = map['uid'],

        name = map['name'],
        amount = map['amount']??0.0,
        currencyCode = map['currencyCode'],

        email = map['email'],
        mobile = map['mobile'];

  toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'currencyCode': currencyCode,
      'amount': amount,
      'mobile': mobile,
    };
  }
}
