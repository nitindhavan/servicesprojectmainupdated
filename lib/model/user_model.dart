
const serviceProvider = 'serviceProvider';
const client = 'client';

const gas='gas';
const water='water';

class UserModel {
  ///UID OF USER
  String? uid;
  double? distance;
  double? rating;
  String? shopStatus;
  DateTime? dateTime;
  String? notifyAllowed;

  // Shop id for driver only

  String? shopId;
  /// ID number of the user
  String? idCard;
  String? bankCard;

  /// name
  String? name;

  ///photo url
  String? photoUrl;

  /// email
  String? email;
  String? mobile;

  ///device token for firebase messaging
  String? token;

  String? role;

  String? shopType;

  String? referal_code;

  String? referal_link;

  String? referer_code;


  // address for shop
  double? latitude;

  double? longitude;
  ///number of products in currencyCode
  String? currencyCode;

  //wallet balance of user

  int? balance;

  int? rewardBalance;

  String? city;
  String? country;

  double? charge;

  String? accountStatus;


  UserModel(
      {this.uid,
      this.idCard,
      this.bankCard,
      this.name,
      this.currencyCode,
      this.photoUrl,
      this.email,
      this.token,
      this.mobile,
      this.role,
      this.balance,
      this.accountStatus,
      this.shopType,
      this.latitude,
      this.longitude,
      this.referer_code,
      this.referal_code,
      this.referal_link,
      this.rewardBalance,
      this.city,
      this.country,
      this.shopStatus,
      this.charge,
        this.dateTime,
        this.shopId,
        this.notifyAllowed
      });

  UserModel.formMap(Map<dynamic, dynamic> map)
      : uid = map['uid'],
        idCard = map['idCard'],
        bankCard = map['bankCard'],
        name = map['name'],
        currencyCode = map['currencyCode'],
        photoUrl = map['photoUrl'],
        email = map['email'],
        mobile = map['mobile'],
        token = map['token'],
        role = map['role'],
        balance=map['balance'],
  notifyAllowed=map['notifyAllowed'],
  shopId=map['shopId'],
  shopType=map['shopType'],
  latitude=map['latitude'],
  charge=double.parse(map['charge'].toString()),
  longitude=map['longitude'],
  referer_code=map['referer_code'],
  referal_code=map['referal_code'],
  referal_link=map['referal_link'],
  city=map['city'],
  country=map['country'],
  shopStatus=map['shopStatus'],
  dateTime=DateTime.tryParse(map['dateTime'] ?? ""),
  rewardBalance=map['reward_balance'],
  accountStatus=map['accountStatus'];

  toMap() {
    return {
      'uid': uid,
      'balance': balance,
      'idCard': idCard,
      'bankCard': bankCard,
      'name': name,
      'email': email,
      'currencyCode': currencyCode,
      'photoUrl': photoUrl,
      'token': token,
      'charge': charge,
      'mobile': mobile,
      'role': role,
      'shopType': shopType,
      'latitude':latitude,
      'longitude':longitude,
      'referer_code': referer_code,
      'referal_link':referal_link,
      'referal_code':referal_code,
      'reward_balance':rewardBalance,
      'country': country,
      'city': city,
      'notifyAllowed': notifyAllowed,
      'dateTime':dateTime?.toIso8601String(),
      'shopStatus': shopStatus,
      'shopId': shopId,
      'accountStatus':accountStatus,
    };
  }
}
