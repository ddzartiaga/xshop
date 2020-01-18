import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../viewmodels/product_viewmodel.dart';
import '../userproducts/user_products_screen.dart';

class ProductFormScreen extends StatefulWidget {
  static const route = '/user-product-form';

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceNode = FocusNode();
  final _descNode = FocusNode();
  final _imageUrlNode = FocusNode();
  final _imageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var _imageUrlWasFocused = false;
  var _didLoadData = false;
  var _isLoading = false;

  var _viewModel = ProductViewModel(
    id: '',
    title: '',
    price: 0.0,
    description: '',
    imageUrl: '',
  );

  @override
  void initState() {
    super.initState();

    _imageUrlWasFocused = false;
    _imageUrlNode.addListener(previewImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoadData) {
      String id = ModalRoute.of(context).settings.arguments as String;
      if (id != null && id.isNotEmpty) {
        final prod =
            Provider.of<ProductsProvider>(context, listen: false).getById(id);
        _viewModel.id = prod.id;
        _viewModel.title = prod.title;
        _viewModel.description = prod.description;
        _viewModel.price = prod.price;
        _viewModel.imageUrl = prod.imageUrl;
        _viewModel.isFavorite = prod.isFavorite;
        _imageController.text = _viewModel.imageUrl;
      }

      _didLoadData = true;
    }
  }

  @override
  void dispose() {
    _priceNode.dispose();
    _descNode.dispose();
    _imageUrlNode.removeListener(previewImage);
    _imageUrlNode.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void previewImage() {
    bool isFocus = _imageUrlNode.hasFocus;

    if (isFocus) _imageUrlWasFocused = true;

    if (_imageUrlWasFocused && !isFocus) {
      setState(() {}); // just work around, force widget to re-build
      _imageUrlWasFocused = false;
    }
  }

  String isRequired(String val) {
    if (val.isEmpty) return 'Please enter a value.';

    return null;
  }

  String validNumber(String val) {
    if (isRequired(val) != null)
      return 'Please enter a value.';
    else if (double.tryParse(val) == null)
      return 'Please enter a valid number.';
    else if (double.tryParse(val) < 1.0)
      return 'Please enter a number greater than zero.';

    return null;
  }

  String minCharCount(int count, String val) {
    if (isRequired(val) != null)
      return 'Please enter a value.';
    else if (val.length < count)
      return 'The description should be more than $count characters.';

    return null;
  }

  Future<void> _saveProduct() async {
    _formKey.currentState.validate(); // fire validation
    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_viewModel.id.isEmpty) {
        await Provider.of<ProductsProvider>(context, listen: false)
            .insertProduct(_viewModel);
      } else {
        print('UPDATE');
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_viewModel);
      }
    } catch (ex) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error Occured'),
          content: Text('Oooops! Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('OKAY'),
              onPressed: () {
                Navigator.of(ctx).pop('NOPE');
              },
            )
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop(); // close top most page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Information'),
        actions: <Widget>[
          SaveProductButton(_saveProduct),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _viewModel.title,
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.newline,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceNode);
                        },
                        validator: (val) {
                          return isRequired(val);
                        },
                        onSaved: (val) {
                          _viewModel.title = val;
                        },
                      ),
                      TextFormField(
                        initialValue: _viewModel.price.toString(),
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        focusNode: _priceNode,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.newline,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descNode);
                        },
                        validator: (val) => validNumber(val),
                        onSaved: (val) {
                          _viewModel.price = double.parse(val);
                        },
                      ),
                      TextFormField(
                        initialValue: _viewModel.description,
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        focusNode: _descNode,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        validator: (val) => minCharCount(10, val),
                        onSaved: (val) {
                          _viewModel.description = val;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 10, right: 12),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: _imageController.text.isNotEmpty
                                ? Image.network(
                                    _imageController.text,
                                    fit: BoxFit.cover,
                                  )
                                : Center(
                                    child: Text('Enter URL'),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Image URL',
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageController,
                              focusNode: _imageUrlNode,
                              onFieldSubmitted: (_) => _saveProduct(),
                              validator: (val) => minCharCount(10, val),
                              onSaved: (val) {
                                _viewModel.imageUrl = _imageController.text;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class SaveProductButton extends StatelessWidget {
  final Function _saveProduct;

  SaveProductButton(this._saveProduct);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.save),
      onPressed: () {
        _saveProduct();

        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('A product was added/updated!'),
          action: SnackBarAction(
            label: 'SHOW LIST',
            onPressed: () {
              Navigator.of(context).pushNamed(UserProductsScreen.route);
            },
          ),
        ));
      },
    );
  }
}
