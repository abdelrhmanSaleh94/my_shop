import 'package:flutter/material.dart';
import '../screen/product_detils.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItems extends StatelessWidget {
  // final String id;
  // final String imageUrl;
  // final String title;

  // const ProductItems(this.id, this.imageUrl, this.title);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
    final authData = Provider.of<Auth>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ProductDetils.routeName,
                  arguments: product.id);
            },
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder:
                    AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: Consumer<Product>(
              builder: (ctx, product, _child) => IconButton(
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    try {
                      product.toggelFav(
                          product.id, authData.token, authData.userId);
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                          product.isFavorite
                              ? 'Add To Favorite'
                              : 'Remove From Favorite ',
                          style: TextStyle(
                              fontFamily: 'Anton',
                              fontSize: 18,
                              fontStyle: FontStyle.italic),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ));
                    } catch (error) {}
                  }),
            ),
            title: Text(
              product.title,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Add To Cart',
                    style: TextStyle(
                        fontFamily: 'Anton',
                        fontSize: 18,
                        fontStyle: FontStyle.italic),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSinglItem(product.id);
                    },
                  ),
                ));
              },
            ),
          )),
    );
  }
}
