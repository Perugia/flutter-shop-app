import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: orderData.orders.isEmpty
          ? Column(
              children: const [
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "You don't have any orders.",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Icon(Icons.hourglass_empty_sharp)
              ],
            )
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
            ),
    );
  }
}
