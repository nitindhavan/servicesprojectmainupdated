import 'package:WeServeU/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/widgets.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Consumer<OrdersProvider>(
        builder: (ctx, provider, c) {
          return provider.loading
              ? const ListLoadingShimmer()
              : provider.ordersList.isEmpty
                  ? const Empty()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        reverse: true,
                          itemBuilder: (ctx, index) {
                            return OrdersListUnit(
                                orderModel: provider.ordersList[index]);
                          },
                          separatorBuilder: (ctx, index) {
                            return const Divider();
                          },
                          itemCount: provider.ordersList.length),
                    );
        },
      ),
    );
  }
}
