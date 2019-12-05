import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../widget/user_product_item.dart';
import '../widget/app_drawer.dart';
import '../screen/edit_product.dart';

class UserProducts extends StatelessWidget {
  static final String routeName = '/UserProducts';
  Future<void> _refershData(BuildContext context) async {
    await Provider.of<Products>(context).fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products '),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProduct.routeName);
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refershData(context),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: ListView.builder(
              itemCount: product.itemsProduct.length,
              itemBuilder: (_, i) => Column(
                    children: <Widget>[
                      UserProductItem(
                        id: product.itemsProduct[i].id,
                        price: product.itemsProduct[i].price,
                        imagUrl: product.itemsProduct[i].imageUrl,
                        title: product.itemsProduct[i].title,
                      ),
                      Divider()
                    ],
                  )),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
