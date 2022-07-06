import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

var OrdersScreenIsInit = true;

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;

  @override
  void initState() {
    if (OrdersScreenIsInit) {
      OrdersScreenIsInit = false;
      _refreshOrders(context);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: const AppDrawer(),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => _refreshOrders(context),
                child: orderData.orders.isEmpty
                    ? ListView(
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
              ));
  }

  Future<void> _refreshOrders(BuildContext context) async {
    var status = true;
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Orders>(context, listen: false)
        .fetchOrders()
        .catchError((statusCode) {
      setState(() {
        _isLoading = false;
      });

      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("An error occurred!"),
          content: Text("Something went wrong \n Error code : ${statusCode}"),
          actions: [
            TextButton(onPressed: Navigator.of(ctx).pop, child: Text("Close"))
          ],
        ),
      );
    });
    if (status) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
