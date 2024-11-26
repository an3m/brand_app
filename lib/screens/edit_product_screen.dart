import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({super.key});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  // bool _imageUrlValid = false;
  var _isInit = true;
  var isEditing = false; ///////////////
  var _isLoading = false;
  Product _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  @override
  void initState() {
    _imageUrlController.addListener(_updateImageUrl);
    // _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments.toString();

      if (productId != "null") {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId)!;
        isEditing = true;
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
      return;
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // _imageUrlFocusNode.removeListener(_updateImageUrl);
    // _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    // if (!_imageUrlFocusNode.hasFocus) {
    //   setState(() {});
    // }
    final RegExp urlRegExp = RegExp(
      r'^https?:\/\/.+',
      caseSensitive: false,
      multiLine: false,
    );
    if (_imageUrlController.text.isEmpty ||
        !urlRegExp.hasMatch(_imageUrlController.text) ||
        (!_imageUrlController.text.endsWith('.png') &&
            !_imageUrlController.text.endsWith('.jpg') &&
            !_imageUrlController.text.endsWith('.jpeg'))) {
      return;
    } //that make sure that the preview image rendered exept when the URL is valid
    else {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      // Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        // ignore: use_build_context_synchronously
        await showDialog<void>(
          context: context,
          builder: (cxt) => AlertDialog(
            title: const Text('An error occured!'),
            content: const Text('Something went wrong!'),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(cxt).pop(); //not context
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      } finally {
        // setState(() {
        //   _isLoading = false;
        // });
        // Navigator.of(context).pop();
      }
    }
    setState(() {
      _isLoading = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(); // only generated when the await fuctions done
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Products' : 'Add Products'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a title';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          isFavorite: _editedProduct.isFavorite,
                          id: _editedProduct.id,
                          title: newValue!,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      // focusNode: _priceFocusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price.';
                        }
                        //tryParse returns null if the throwing value is invalid double
                        final double? parsedValue = double.tryParse(value);
                        // Check if parsing succeeded and if the parsed value is not null
                        if (parsedValue == null) {
                          return 'Please enter a valid number.';
                        }
                        if (parsedValue <= 0) {
                          return 'Please enter a number greater than zero';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          isFavorite: _editedProduct.isFavorite,
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(newValue as String),
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a description';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          isFavorite: _editedProduct.isFavorite,
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: newValue as String,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? const Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              // keyboardAppearance: Brightness.light,
                              decoration:
                                  const InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an image URL.';
                                }
                                // Regular expression pattern to validate URL
                                final RegExp urlRegExp = RegExp(
                                  r'^https?:\/\/.+',
                                  caseSensitive: false,
                                  multiLine: false,
                                );
                                // Check if the entered value matches the URL pattern
                                if (!urlRegExp.hasMatch(value)) {
                                  return 'Please enter a valid URL.';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Please enter a valid image URL.';
                                }
                                // Input is a valid URL, return null to indicate no error
                                return null;
                              },

                              controller: _imageUrlController,
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                  isFavorite: _editedProduct.isFavorite,
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: newValue!,
                                );
                              },
                              // focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) => _saveForm(),
                              //to point at a function inside another function  as this case, we should put the pranthese ()
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
