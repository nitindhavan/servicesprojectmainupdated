
class WithdrawlModel {
  String? key;
  num? amount;
  String? status;
  String uid;
  WithdrawlModel(
      {required this.key,
      required this.amount,
      required this.status,
      required this.uid});

  WithdrawlModel.formMap(Map<dynamic, dynamic> map)
      : key = map['key'],
        amount = map['amount'] ?? 0,
        status = map['status'],
  uid=map['uid'];

  toMap() {
    return {
      'key': key,
      'amount': amount,
      'status': status,
      'uid': uid
    };
  }
}
