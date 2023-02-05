
class BankCardModel {
  String uid;
  String cardNumber;
  String cvv;
  String expiary;

  BankCardModel(
      {required this.uid,required this.cardNumber,required this.cvv,required this.expiary});

  BankCardModel.fromMap(Map<dynamic, dynamic> map)
      : uid = map['uid'],
        cardNumber = map['cardNumber'],
        cvv = map['cvv'],
        expiary=map['expiary'];

  Map<String, Object?> toMap() {
    final map = {
      'uid': uid,
      'cardNumber': cardNumber,
      'cvv': cvv,
      'expiary': expiary,
    };
    map.removeWhere((key, value) => value==null);
    return map;
  }
}