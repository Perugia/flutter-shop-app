import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';
import '../widgets/custom_snackbar.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool ignoring = false;
  Timer? timer;

  void setIgnoring(bool newValue) {
    setState(() {
      ignoring = newValue;
    });
    timer = Timer(const Duration(seconds: 4), () {
      setState(() {
        ignoring = !newValue;
      });
    });
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          IconButton(
              onPressed: () {
                cart.totalAmount > 0
                    ? showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: const Text("Are you sure?"),
                              content: const Text(
                                  "Do you want to remove all items in the cart?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    cart.clear();
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text("Yes"),
                                )
                              ],
                            ))
                    : customSnack(
                        context: context,
                        content: const Text(
                          'Your cart is empty!',
                          textAlign: TextAlign.center,
                        ),
                      );
              },
              icon: const Icon(
                Icons.delete,
              ))
        ],
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '${cart.totalAmount.toStringAsFixed(2)} TL',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6!.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  IgnorePointer(
                    ignoring: ignoring,
                    child: TextButton(
                      child: const Text('ORDER NOW'),
                      onPressed: cart.totalAmount <= 0
                          ? null
                          : () async {
                              var isWrong = true;
                              await Provider.of<Orders>(context, listen: false)
                                  .addOrder(
                                cart.items.values.toList(),
                                cart.totalAmount,
                              )
                                  .catchError((status) {
                                isWrong = false;
                                print("false");
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                customSnack(
                                  context: context,
                                  content: const Text(
                                    'An error occurred while executing the order.',
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              });

                              if (isWrong == true) {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                customSnack(
                                  context: context,
                                  content: const Text(
                                    'Your order is successful!',
                                    textAlign: TextAlign.center,
                                  ),
                                );
                                cart.clear();
                              }
                            },
                      style: TextButton.styleFrom(
                          primary: Theme.of(context).colorScheme.primary),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
            ),
          )
        ],
      ),
    );
  }
}
