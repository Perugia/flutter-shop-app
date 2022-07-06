import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

var userProductsScreenIsInit = true;

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-products';

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  var _isLoading = false;

  @override
  void initState() {
    if (userProductsScreenIsInit) {
    userProductsScreenIsInit = false;
    _refreshProducts(context);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: productsData.items.isEmpty
                    ? ListView(
                        padding: EdgeInsets.all(30),
                        children: [
                          Center(
                            child: Text(
                              "No current product found",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Icon(Icons.hourglass_empty_sharp)
                        ],
                      )
                    : ListView.builder(
                        itemCount: productsData.items.length,
                        itemBuilder: (_, i) => Column(
                          children: [
                            UserProductItem(
                              productsData.items[i].id,
                              productsData.items[i].title,
                              productsData.items[i].imageUrl,
                            ),
                            Divider(),
                          ],
                        ),
                      ),
              ),
            ),
    );
  }

  Future<void> _refreshProducts(BuildContext context) async {
    var status = true;
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Products>(context, listen: false)
        .fetchProducts()
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
