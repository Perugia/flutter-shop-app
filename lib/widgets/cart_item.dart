import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  // ignore: use_key_in_widget_constructors
  const CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("Are you sure?"),
                  content:
                      const Text("Do you want to remove the item from cart?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: const Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: const Text("Yes"),
                    )
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 74,
                      width: 70,
                      padding: const EdgeInsets.all(8),
                      child: CircleAvatar(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: FittedBox(
                            child: Text(
                              '$price TL',
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formatTextResp(title),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Total: ${(price * quantity)} TL')
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Provider.of<Cart>(context, listen: false)
                              .increase(productId);
                        },
                        icon: const Icon(Icons.add)),
                    Text('$quantity x'),
                    IconButton(
                        onPressed: () {
                          Provider.of<Cart>(context, listen: false)
                              .decreaseItem(productId);
                        },
                        icon: const Icon(Icons.remove)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatTextResp(String text) {
    String formattedText = text;
    if (text.length > 20) {
      formattedText = formattedText.substring(0, 20) + "...";
    }
    return formattedText;
  }
}
