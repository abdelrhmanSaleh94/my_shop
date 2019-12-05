import 'package:flutter/material.dart';
import '../widget/products_widget.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widget/badge.dart';
import '../screen/cart_screen.dart';
import '../widget/app_drawer.dart';
import '../providers/products.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverViewScreen extends StatefulWidget {
  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var _showOnlyFavorites = false;
  var _intiSat = true;
  var _isloadingInd = false;
  @override
  void didChangeDependencies() {
    if (_intiSat) {
      try {
        setState(() {
          _isloadingInd = true;
        });
        Provider.of<Products>(context).fetchProduct().then((_) {
          setState(() {
            _isloadingInd = false;
          });
        });
      } catch (erroe) {
        print(erroe);
      }
    }
    _intiSat = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
                  child: ch,
                  value: cart.itemCount.toString(),
                ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routName);
              },
            ),
          ),
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    ),
                  ])
        ],
      ),
      body: _isloadingInd?Center(child: CircularProgressIndicator(),): ProductsWidget(_showOnlyFavorites),
      drawer: AppDrawer(),
    );
  }
}
