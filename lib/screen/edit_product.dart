import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class EditProduct extends StatefulWidget {
  static const String routeName = '/EditProduct';

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _pricNods = FocusNode();
  final _descripNods = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageNodes = FocusNode();
  final _form = GlobalKey<FormState>();

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isloading = false;
  var _editproduct =
      Product(id: null, title: '', price: 0.0, description: '', imageUrl: '');
  void _updateImageUrl() {
    if (!_imageNodes.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    _imageNodes.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageNodes.removeListener(_updateImageUrl);
    _pricNods.dispose();
    _descripNods.dispose();
    _imageNodes.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_editproduct.id != null) {
      try {
        // setState(() {
        //   _isloading = true;
        // });
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editproduct.id, _editproduct);
        //Navigator.of(context).pop();
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Hi We are So Sorrey For this !!!'),
                  content: Text('Something Worng Happen We Solve it Soon'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Thanks'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      }
    } else {
      setState(() {
        _isloading = true;
      });
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editproduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Hi We are So Sorrey For this !!!'),
                  content: Text('Something Worng Happen We Solve it Soon'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Thanks'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      } //finally {
      //  Navigator.of(context).pop();
     // }
    }
    setState(() {
      _isloading = true;
    });
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editproduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editproduct.title,
          'description': _editproduct.description,
          'price': _editproduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editproduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      initialValue: _initValues['title'],
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_pricNods);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Title .';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editproduct = Product(
                            title: value,
                            price: _editproduct.price,
                            description: _editproduct.description,
                            imageUrl: _editproduct.imageUrl,
                            id: _editproduct.id,
                            isFavorite: _editproduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Price'),
                      initialValue: _initValues['price'],
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _pricNods,
                      maxLines: 1,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descripNods);
                      },
                      onSaved: (value) {
                        _editproduct = Product(
                            title: _editproduct.title,
                            price: double.parse(value),
                            description: _editproduct.description,
                            imageUrl: _editproduct.imageUrl,
                            id: _editproduct.id,
                            isFavorite: _editproduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Discription'),
                      keyboardType: TextInputType.multiline,
                      focusNode: _descripNods,
                      initialValue: _initValues['description'],
                      maxLines: 3,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageNodes);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editproduct = Product(
                            title: _editproduct.title,
                            price: _editproduct.price,
                            description: value,
                            imageUrl: _editproduct.imageUrl,
                            id: _editproduct.id,
                            isFavorite: _editproduct.isFavorite);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          margin: EdgeInsets.fromLTRB(2, 8, 10, 0),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Image Url')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageNodes,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image URL.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editproduct = Product(
                                  title: _editproduct.title,
                                  price: _editproduct.price,
                                  description: _editproduct.description,
                                  imageUrl: value,
                                  id: _editproduct.id,
                                  isFavorite: _editproduct.isFavorite);
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )),
    );
  }
}
