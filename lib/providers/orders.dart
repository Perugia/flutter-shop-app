import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_shop_app/models/http_exception.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        "https://flutter-shop-app-7db3a-default-rtdb.europe-west1.firebasedatabase.app/orders.json");

    try {
      final response = await http.get(url);
      if (response.statusCode >= 300) {
        throw HttpException("An error occurred while executing the order.");
      }
      if (!response.headers["content-type"]!.contains('application/json')) {
        throw HttpException("An unexpected error has occurred");
      }
      if (response.body != "null") {
        final fetchedOrders =
            json.decode(response.body) as Map<String, dynamic>;
        final List<OrderItem> loadedOrders = [];

        fetchedOrders.forEach((orId, orData) {
          // final List<dynamic> fetchedOrProducts = orData["products"];
          // final List<CartItem> loadedOrProducts = [];

          // fetchedOrProducts.forEach((pValue) {
          //   loadedOrProducts.add(CartItem(
          //       id: pValue["id"] ?? "",
          //       title: pValue["title"] ?? "",
          //       quantity: pValue["quantity"] ?? 0,
          //       price: pValue["price"] ?? 0));
          // });

          loadedOrders.add(OrderItem(
            id: orId,
            amount: orData["amount"].toDouble(),
            dateTime: DateTime.parse(orData["dateTime"]),
            products: (orData["products"] as List<dynamic>)
                .map((item) => CartItem(
                    id: item["id"] ?? "",
                    title: item["title"] ?? "",
                    quantity: item["quantity"] ?? 0,
                    price: item["price"].toDouble() ?? 0.0))
                .toList(),
          ));
        });

        _orders = loadedOrders.reversed.toList();

        notifyListeners();
      } else {
        _orders.clear();
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        "https://flutter-shop-app-7db3a-default-rtdb.europe-west1.firebasedatabase.app/orders.json");
    final timestamp = DateTime.now();

    try {
      final response = await http.post(url,
          body: json.encode({
            "amount": total,
            "dateTime": timestamp.toIso8601String(),
            "products": cartProducts
                .map((cp) => {
                      "id": cp.id,
                      "title": cp.title,
                      "quantity": cp.quantity,
                      "price": cp.price,
                    })
                .toList(),
          }));
      if (response.statusCode >= 400) {
        throw HttpException("An error occurred while executing the order.");
      }
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)["name"],
          amount: total,
          dateTime: DateTime.now(),
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
