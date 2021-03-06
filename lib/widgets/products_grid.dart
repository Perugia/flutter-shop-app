import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatefulWidget {
  final bool showFavs;

  // ignore: use_key_in_widget_constructors
  const ProductsGrid(this.showFavs);

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  void updateFav(Product product) {
    setState(() {
      product.toggleFavoriteStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        widget.showFavs ? productsData.favoriteItems : productsData.items;
    return products.isEmpty
        ? ListView(
            children: [
              SizedBox(
                height: 100,
                width: double.infinity,
                child: Center(
                  child: widget.showFavs
                      ? Text(
                          "You don't have any favorite products.",
                          style: TextStyle(fontSize: 18),
                        )
                      : Text(
                          "No current product found",
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
              Icon(Icons.hourglass_empty_sharp)
            ],
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: products.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              // builder: (c) => products[i],
              value: products[i],
              child: ProductItem(
                updateFav: updateFav,
                // products[i].id,
                // products[i].title,
                // products[i].imageUrl,
              ),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
  }
}
