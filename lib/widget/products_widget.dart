import 'package:flutter/material.dart';
import './productItem.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductsWidget extends StatelessWidget {
  final bool showFavs;

  ProductsWidget(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final pruductsList =
        showFavs ? productsData.favoriteItems : productsData.itemsProduct;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: pruductsList.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            value: pruductsList[i],
            child: ProductItems(),
          ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
