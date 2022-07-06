import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import './custom_snackbar.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({Key? key, required this.updateFav}) : super(key: key);

  final Function updateFav;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  // final String id;
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl != ""
                ? product.imageUrl
                : "https://miro.medium.com/max/400/1*UL9RWkTUtJlyHW7kGm20hQ.png",
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                widget.updateFav(product);
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              if (cart.items.containsKey(product.id)) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                customSnack(
                  context: context,
                  content: const Text(
                    'Already in your cart!',
                    textAlign: TextAlign.center,
                  ),
                );
                return;
              }
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              customSnack(
                context: context,
                content: const Text('Successfully added to cart!'),
                action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      cart.removeItem(product.id);
                    }),
                duration: const Duration(seconds: 3),
              );
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
