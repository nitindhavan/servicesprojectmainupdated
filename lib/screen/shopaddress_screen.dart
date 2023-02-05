import 'package:flutter/cupertino.dart';
import 'map.dart';

class ShopAdress extends StatefulWidget {
  const ShopAdress({Key? key}) : super(key: key);

  @override
  State<ShopAdress> createState() => _ShopAdressState();
}

class _ShopAdressState extends State<ShopAdress> {
  double latitude=0;
  double longitude=0;

  @override
  Widget build(BuildContext context) {
    return MyMap();
  }
}
