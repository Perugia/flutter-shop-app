import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
                .copyWith(secondary: Colors.amber),
          ),
          home: ProductsOverviewScreen(),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case ProductDetailScreen.routeName:
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (_, __, ___) => const ProductDetailScreen(),
                );
              case CartScreen.routeName:
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (_, __, ___) => const CartScreen(),
                );
              case OrdersScreen.routeName:
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (_, __, ___) => const OrdersScreen(),
                );
              case UserProductsScreen.routeName:
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (_, __, ___) => UserProductsScreen(),
                );
              case EditProductScreen.routeName:
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (_, __, ___) => EditProductScreen(),
                );
              case "/home":
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (_, __, ___) => ProductsOverviewScreen(),
                );
              default:
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (_, __, ___) => const ProductsOverviewScreen(),
                );
            }
          }),
    );
  }
}
