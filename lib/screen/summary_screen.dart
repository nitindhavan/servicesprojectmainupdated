import 'package:WeServeU/providers/orders_provider.dart';
import 'package:WeServeU/providers/product_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import '../model/order_model.dart';
class SummaryScreen extends StatefulWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool selected=false;
  String range='Select Date Range';
  var args=null;
  DateTime start=DateTime.now();
  DateTime end=DateTime.now().subtract(Duration(days: 720));
  bool once=false;
  @override
  Widget build(BuildContext context) {
    var local=AppLocalizations.of(context);
    if(!once)range=local.selectDateRange;
    once=true;
    return Scaffold(
      body: SafeArea(child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                setState(() {
                  selected=!selected;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffb3d6ff),
                  borderRadius: BorderRadius.circular(20),
                ),
                width: double.infinity,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 8,),
                    Center(child: Text(range)),
                    Icon(selected ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                    SizedBox(width: 8,),
                  ],
                ),
              ),
            ),
          ),
          if(selected)Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffb3d6ff),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(8),
              child: SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange: PickerDateRange(
                    DateTime.now(),DateTime.now()
              ),

                onSelectionChanged: (args){
                  setState(() {
                    start=args.value.startDate;
                    end=args.value.endDate?? args.value.startDate;
                    range = '${local.from} ${DateFormat('dd/MM/yyyy').format(args.value.startDate)} ${local.to} ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffb3d6ff),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(8),
              child: FutureBuilder(key: Key(range),builder: (BuildContext context, AsyncSnapshot<Widget?> snapshot) {
                if(!snapshot.hasData) return SizedBox();
                return snapshot.data!;
                },future:createTable() ,),
            ),
          )
        ],
      ),),
      appBar: AppBar(
        title: Text(local.summary),
        backgroundColor: Color(0xff5a74ec),
      ),
    );
  }
  bool isSameDate(DateTime other,DateTime current) {
    return current.year == other.year && current.month == other.month
        && current.day == other.day;
  }

  Future<Widget> createTable() async {
    var local=AppLocalizations.of(context);
    int total=0;
    int quantity=0;
    List<TableRow> rows = [];
    rows.add(TableRow(children: [
      Padding(
        padding: const EdgeInsets.only(top: 8.0,bottom: 8),
        child: Text(local.orderno,style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0,bottom: 8),
        child: Text(local.product,style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0,bottom: 8),
        child: Text(local.quantity,style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0,bottom: 8),
        child: Text(local.price,style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0,bottom: 8),
        child: Text(local.total,style: TextStyle(fontWeight: FontWeight.bold),),
      ),
    ]));
    var ordersProvider=Provider.of<OrdersProvider>(context,listen: false);
    var provider=Provider.of<ProductProvider>(context,listen: false);
    List<OrderModel> modelList = [];
    List<DateTime> dateList=[];
    for (int i = 0; i < ordersProvider.ordersList.length; i++) {
      if(!dateList.contains(ordersProvider.ordersList[i].date)){
        ordersProvider.ordersList[i].orderId=(i+1).toString();
        modelList.add(ordersProvider.ordersList[i]);
      }
      dateList.add(ordersProvider.ordersList[i].date!);
    }
    for (int i = 1; i < ordersProvider.ordersList.length+1; ++i) {
      if ((ordersProvider.ordersList[i - 1].date!.isAfter(start) &&
          ordersProvider.ordersList[i - 1].date!.isBefore(end)) ||
          (ordersProvider.ordersList[i - 1].date!.isAfter(end) &&
          ordersProvider.ordersList[i - 1].date!.isBefore(start)) ||
          (isSameDate(ordersProvider.ordersList[i - 1].date!, end) ||
              isSameDate(ordersProvider.ordersList[i - 1].date!, start))) {
        total+=((ordersProvider.ordersList[i - 1].price?? 0) * (ordersProvider.ordersList[i - 1].quantity?? 0)).toInt();
        quantity+=(ordersProvider.ordersList[i - 1].quantity ?? 0).toInt();
        rows.add(TableRow(children: [
          Text((dateList.indexOf(ordersProvider.ordersList[i-1].date!)+1).toString()),
          FutureBuilder(builder: (BuildContext context,
              AsyncSnapshot<DataSnapshot> snapshot) {
            if (!snapshot.hasData) return Text(local.loading);
            return Text('${snapshot.data!.value ?? 'Deleted'}');
          },
              future: provider.getProductName(
                  ordersProvider.ordersList[i - 1].productKey!)),
          Text('${ordersProvider.ordersList[i - 1].quantity ?? '0'}'),
          Text('${ordersProvider.ordersList[i - 1].price  ?? '0'}'),
          Text('${(ordersProvider.ordersList[i - 1].price?? 0) * (ordersProvider.ordersList[i - 1].quantity?? 0)}'),
        ]));
      }
    }
    rows.add(TableRow(children: [
      SizedBox(),
      SizedBox(),
      SizedBox(),
      Padding(
        padding: const EdgeInsets.only(top: 16.0,bottom: 8),
        child: Text(local.total,style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16.0,bottom: 8),
        child: Text('$total',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
    ]));
    return SingleChildScrollView(
      child: Table(children: rows,columnWidths: {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
        4:FlexColumnWidth(2),
      },),
    );
  }
}
