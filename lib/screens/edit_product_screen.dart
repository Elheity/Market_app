import 'package:firebasetest/providers/product.dart';
import 'package:firebasetest/providers/products.dart';
import 'package:firebasetest/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    phone: 0,
    imgUrl: '',
  );
  var _initialValues = {
    'title': '',
    'description': '',
    'price': '',
    'phone':'',
    'imgUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initialValues = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price.toString(),
          'phone':_editProduct.phone.toString(),
          'imgUrl': '',
        };
        _imageUrlController.text = _editProduct.imgUrl;
      }
      _isInit = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _phoneFocusNode.dispose();
    _descriptionFocusNode.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
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

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProducts(_editProduct);
      } catch (e) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occurred'),
                  content: Text(e),
                  actions: [
                    FlatButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('Okay'),
                    )
                  ],
                ));
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        backgroundColor: Colors.grey[800],
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initialValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter your field';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          title: value,
                          description: _editProduct.description,
                          price: _editProduct.price,
                          imgUrl: _editProduct.imgUrl,
                          phone: _editProduct.phone,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initialValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_phoneFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter your field';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please Enter a valid Price';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please Enter a number greater than zero';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          title: _editProduct.title,
                          description: _editProduct.description,
                          price: double.parse(value),
                          phone: _editProduct.phone,
                          imgUrl: _editProduct.imgUrl,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initialValues['phone'],
                      decoration: InputDecoration(labelText: 'Phone'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _phoneFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter your field';
                        }
                        if (value.length > 11) {
                          return 'Please Enter  phone number less than 11 character ';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please Enter a valid phone number';
                        }
                        if (int.parse(value) <= 0) {
                          return 'Please Enter a valid real number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          title: _editProduct.title,
                          description: _editProduct.description,
                          price: _editProduct.price,
                          phone: int.parse(value),
                          imgUrl: _editProduct.imgUrl,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initialValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter your field';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          title: _editProduct.title,
                          description: value,
                          price: _editProduct.price,
                          phone: _editProduct.phone,
                          imgUrl: _editProduct.imgUrl,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                    ),
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Center(child: Text('your Image'))
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _imageUrlController,
                            decoration: InputDecoration(labelText: 'ImageUrl'),
                            keyboardType: TextInputType.url,
                            focusNode: _imageUrlFocusNode,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter your field';
                              }
                              if((!_imageUrlController.text.startsWith('http') &&
                                  !_imageUrlController.text.startsWith('https'))){
                                return 'Please a valid Url image';
                              }
                              if((!_imageUrlController.text.endsWith('.png') &&
                                  !_imageUrlController.text.endsWith('.jpg') &&
                                  !_imageUrlController.text.endsWith('.jpeg'))){
                                return 'Please a valid Url image';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editProduct = Product(
                                id: _editProduct.id,
                                title: _editProduct.title,
                                description: _editProduct.description,
                                price: _editProduct.price,
                                phone: _editProduct.phone,
                                imgUrl: value,
                                isFavorite: _editProduct.isFavorite,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
      drawer: AppDrawer(),
    );
  }
}
