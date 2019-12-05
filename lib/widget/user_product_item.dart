import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import '../screen/edit_product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imagUrl;
  final double price;

  const UserProductItem(
      {@required this.id,
      @required this.title,
      @required this.imagUrl,
      @required this.price});

  @override
  Widget build(BuildContext context) {
    final _scafold = Scaffold.of(context);
    return ListTile(
      title: Text(
        title,
        style: TextStyle(textBaseline: TextBaseline.ideographic),
        softWrap: true,
      ),
      subtitle: Text('\$$price'),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imagUrl),
      ),
      trailing: Container(
        width: 100,
        margin: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.pushNamed(context, EditProduct.routeName,
                    arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                try {
                  Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  _scafold.showSnackBar(SnackBar(
                    content: Text(
                      'Delete Failed',
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.redAccent,
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
