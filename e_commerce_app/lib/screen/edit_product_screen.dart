import 'dart:math';

import 'package:e_commerce_app/data_source/dummy_data.dart';
import 'package:e_commerce_app/provider/products.dart';
import 'package:e_commerce_app/screen/loading_screen.dart';
import 'package:e_commerce_app/screen/product_details_screen.dart';
import 'package:e_commerce_app/services/database.dart';
import 'package:e_commerce_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/product.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/EditProductScreen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  var sizeTextFormCounter = 1;
  var colorTextFormCounter = 1;
  var _selectedCategory = "";
  Color? _colorVal;
  var _isAdding = false;
  String _selectedColor = "";
  Set<String> _selectColors = {};
  final _priceNode = FocusNode();
  final _descNode = FocusNode();
  final _sizeNode = FocusNode();
  final _colorNode = FocusNode();
  final _imageNode = FocusNode();
  final _categoryNode = FocusNode();
  // var _imageController1 = TextEditingController();
  // var _imageController2 = TextEditingController();
  // var _imageController3 = TextEditingController();
  var _imageURL1 = "";
  var _imageURL2 = "";
  var _imageURL3 = "";
  var _currenIndex = 0;

  var userProduct = Product(
    id: "",
    title: "",
    description: "",
    price: 0.0,
    images: {},
    // creatorID: "",
    categories: {},
    colors: {},
    size: {},
    creatorID: "",
  );
  var _init = true;

  int _imageCounterForm = 1;

  void _submitData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final db = Provider.of<DatabaseServices>(context, listen: false);
    _formKey.currentState!.save();
    setState(() {
      _isAdding = true;
    });
    if (userProduct.id.isNotEmpty) {
      userProduct = userProduct.copyWith(
        categories: userProduct.categories,
        colors: userProduct.colors,
        creatorID: userProduct.creatorID,
        description: userProduct.description,
        id: userProduct.id,
        images: userProduct.images,
        price: userProduct.price,
        size: userProduct.size,
        title: userProduct.title,
      );
      await Provider.of<Products>(context, listen: false)
          .updateProduct(userProduct, context);
    } else {
      userProduct.categories.add('c1');
      // userProduct = userProduct.copyWith(id: Uuid().v4());
      userProduct = userProduct.copyWith(colors: _selectColors);
      await Provider.of<Products>(context, listen: false)
          .addProduct(userProduct, context, db.user.user!.uid);
    }

    // if (userProduct.size.isNotEmpty) {
    //   userProduct.size.forEach((size) {
    //     print('Size : $size');
    //   });
    // }
    // if (userProduct.images.isNotEmpty) {
    //   userProduct.images.forEach((image) {
    //     print('Images links : $image');
    //   });
    // }
    // if (userProduct.colors.isNotEmpty) {
    //   userProduct.colors.forEach((color) {
    //     print('Colors $color');
    //   });
    // }
    // if (_selectColors.isNotEmpty) {
    //   _selectColors.forEach((element) {
    //     int value = int.parse(element);
    //     Color color = Color(value).withOpacity(1);
    //     print('Color as String : $element\n');
    //     print('Color : $color\n');

    //   });
    //   userProduct = userProduct.copyWith(colors: _selectColors);
    // }

    setState(() {
      _isAdding = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    // TODO: implement initState

    _imageNode.addListener(_updateImageFocus);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      final Set<String> colors = {};
      final id = ModalRoute.of(context)!.settings.arguments as String;
      if (id.isNotEmpty) {
        userProduct =
            Provider.of<Products>(context, listen: false).findProductByID(id);
        userProduct.categories.forEach((category) {
          if (!category.contains('c1')) {
            // print(category);
            categoryList.forEach((element) {
              if (category == element.id) {
                int index = categoryList.indexOf(element);
                print(index);
                setState(() {
                  _selectedCategory = categoryList[index].title;
                });
              }
            });
          }
        });

        userProduct.colors.forEach((element) {
          int value = int.parse(element);
          Color color = Color(value).withOpacity(1);
          lookUpColor.keys.forEach((key) {
            Color? value = lookUpColor[key];
            if (value == color) {
              print('key : $key  -- > value: $value\n color: $color\n');
              colors.add(key);
            }
          });
        });

        setState(() {
          sizeTextFormCounter = userProduct.size.length;
          _imageCounterForm = userProduct.images.length;
          colorTextFormCounter = userProduct.colors.length;
          _selectColors = colors;
        });
        print('${userProduct.size.length}');
      }
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _colorNode.dispose();
    _descNode.dispose();
    _imageNode.dispose();
    _sizeNode.dispose();
    _priceNode.dispose();
    _categoryNode.dispose();
    // _imageController1.dispose();
    // _imageController2.dispose();
    // _imageController3.dispose();
    if (!mounted) return;
    _imageNode.removeListener(_updateImageFocus);
    super.dispose();
  }

  void _updateImageFocus() {
    if (!_imageNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userProduct.size.isEmpty ? 'Add Product' : 'Edit Product'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _submitData),
        ],
      ),
      body: _isAdding
          ? Loading()
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: userProduct.title.isNotEmpty
                              ? userProduct.title
                              : "",
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(labelText: 'title'),
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'tittle cannot be empty';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_priceNode);
                          },
                          onSaved: (enteredValue) {
                            userProduct =
                                userProduct.copyWith(title: enteredValue);
                          },
                        ),
                        TextFormField(
                          initialValue: userProduct.price != 0
                              ? userProduct.price.toString()
                              : "",
                          focusNode: _priceNode,
                          decoration: InputDecoration(labelText: 'price'),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'price field cannot be empty';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_descNode);
                          },
                          onSaved: (enteredValue) {
                            userProduct = userProduct.copyWith(
                                price: double.parse(enteredValue!));
                          },
                        ),
                        TextFormField(
                          initialValue: userProduct.description.isNotEmpty
                              ? userProduct.description
                              : "",
                          focusNode: _descNode,
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'desc cannot be empty';
                            }
                            return null;
                          },
                          onSaved: (enteredValue) {
                            userProduct =
                                userProduct.copyWith(description: enteredValue);
                          },
                        ),
                        SizedBox(height: 10),
                        textWidget(
                          'Select the Item category below',
                          kTitleText.copyWith(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: DropdownButtonFormField(
                            focusNode: _categoryNode,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onSaved: (category) {
                              print('on saved category is $category\n');
                              // saved data

                              categoryList.forEach((e) {
                                if (e.title == category) {
                                  int index = categoryList.indexOf(e);
                                  print('index found at $index');
                                  userProduct.categories
                                      .add(categoryList[index].id);
                                }
                              });
                            },
                            validator: (_) {
                              if (_selectedCategory.isEmpty) {
                                return '* select category';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                gapPadding: 10.0,
                                borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                gapPadding: 10.0,
                                borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                  width: 1.0,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                gapPadding: 10.0,
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            onChanged: (category) {
                              setState(() {
                                _selectedCategory = category as String;
                                print(
                                    'Selected category is : $_selectedCategory\n');
                              });
                            },
                            hint: _selectedCategory.isEmpty
                                ? Text('Select Caregory')
                                : Text(_selectedCategory),
                            items: [
                              // if (userProduct.categories.isNotEmpty)
                              //   for (int i = 0;
                              //       i < userProduct.categories.length;
                              //       i++)
                              //     if (!userProduct.categories[i].contains('c1'))
                              //       DropdownMenuItem(
                              //         child: Text(userProduct.categories[i]),
                              //         value: userProduct.categories[i],
                              //       ),
                              // if (userProduct.categories.isEmpty)
                              for (int i = 1; i < categoryList.length; i++)
                                DropdownMenuItem(
                                  child: Text(categoryList[i].title),
                                  value: categoryList[i].title,
                                ),
                            ],
                          ),
                        ),

                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('* Add more size text form or remove!'),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    sizeTextFormCounter++;
                                    setState(() {});
                                    // print('counter : $counterForm');
                                  },
                                  icon: Icon(Icons.add),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (sizeTextFormCounter > 1) {
                                      sizeTextFormCounter--;

                                      setState(() {});
                                      // print('counter : $counterForm');
                                    }
                                  },
                                  icon: Icon(Icons.remove),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        if (userProduct.size.isNotEmpty &&
                            sizeTextFormCounter == userProduct.size.length)
                          ...List.generate(
                            userProduct.size.length,
                            (index) => TextFormField(
                              initialValue: userProduct.size.elementAt(index),
                              focusNode: _sizeNode,
                              decoration: InputDecoration(
                                  labelText:
                                      'Enter size of each item if applicable'),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {},
                              autovalidateMode: AutovalidateMode.always,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Size  cannot be empty';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) =>
                                  FocusScope.of(context)
                                      .requestFocus(_colorNode),
                              onSaved: (enteredValue) {
                                userProduct.size.add(enteredValue!);
                                userProduct = userProduct.copyWith(
                                  size: userProduct.size,
                                );
                              },
                            ),
                          ).toList(),
                        if (userProduct.size.isEmpty ||
                            sizeTextFormCounter > userProduct.size.length)
                          ...List.generate(
                            sizeTextFormCounter,
                            (index) => TextFormField(
                              focusNode: _sizeNode,
                              decoration: InputDecoration(
                                  labelText:
                                      'Enter size of each item if applicable'),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {},
                              autovalidateMode: AutovalidateMode.always,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Size  cannot be empty';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) =>
                                  FocusScope.of(context)
                                      .requestFocus(_colorNode),
                              onSaved: (enteredValue) {
                                userProduct.size.add(enteredValue!);
                                userProduct = userProduct.copyWith(
                                  size: userProduct.size,
                                );
                              },
                            ),
                          ).toList(),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('* Add more color text form or remove!'),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    colorTextFormCounter++;

                                    setState(() {});
                                    // print('counter : $counterForm');
                                  },
                                  icon: Icon(Icons.add),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (colorTextFormCounter > 1) {
                                      colorTextFormCounter--;
                                      setState(() {});
                                      // print('counter : $counterForm');
                                    }
                                  },
                                  icon: Icon(Icons.remove),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (_selectColors.isNotEmpty &&
                            colorTextFormCounter == _selectColors.length)
                          ...List.generate(
                            _selectColors.length,
                            (index) => Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: DropdownButtonFormField(
                                value: _selectColors.elementAt(index),
                                focusNode: _colorNode,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onSaved: (selectedColor) {
                                  // saved data
                                  // late final
                                  lookUpColor.keys.forEach((e) {
                                    if (e == selectedColor) {
                                      // Color color =
                                      //     Color(lookUpColor[selectedColor]!.value)
                                      //         .withOpacity(1);
                                      Color color = lookUpColor[selectedColor]!;
                                      _selectColors.add(color.value.toString());
                                      // userProduct.colors.add(_colorVal!);
                                    }
                                  });
                                  setState(() {});
                                },
                                validator: (selected) {
                                  if (selected == null) {
                                    return '* select color';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  enabledBorder: OutlineInputBorder(
                                    gapPadding: 10.0,
                                    borderSide: BorderSide(
                                      color: Theme.of(context).accentColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    gapPadding: 10.0,
                                    borderSide: BorderSide(
                                      color: Theme.of(context).accentColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    gapPadding: 10.0,
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                onChanged: (category) {
                                  setState(() {
                                    _selectedCategory = category as String;
                                    print(
                                        'Selected color is : $_selectedCategory\n');
                                  });
                                },
                                hint: _selectedCategory.isEmpty
                                    ? Text(
                                        'Select Item color',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                      )
                                    : Text(_selectedColor),
                                items: [
                                  for (int i = 0;
                                      i < lookUpColor.keys.length;
                                      i++)
                                    DropdownMenuItem(
                                      child: Text(lookUpColor.keys.toList()[i]),
                                      value: lookUpColor.keys.toList()[i],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        if (_selectColors.isEmpty ||
                            colorTextFormCounter > _selectColors.length)
                          ...List.generate(
                            colorTextFormCounter,
                            (index) => Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: DropdownButtonFormField(
                                focusNode: _colorNode,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onSaved: (selectedColor) {
                                  // saved data
                                  // late final
                                  lookUpColor.keys.forEach((e) {
                                    if (e == selectedColor) {
                                      // Color color =
                                      //     Color(lookUpColor[selectedColor]!.value)
                                      //         .withOpacity(1);
                                      Color color = lookUpColor[selectedColor]!;
                                      _selectColors.add(color.value.toString());
                                      // userProduct.colors.add(_colorVal!);
                                    }
                                  });
                                  setState(() {});
                                },
                                validator: (selected) {
                                  if (selected == null) {
                                    return '* select color';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  enabledBorder: OutlineInputBorder(
                                    gapPadding: 10.0,
                                    borderSide: BorderSide(
                                      color: Theme.of(context).accentColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    gapPadding: 10.0,
                                    borderSide: BorderSide(
                                      color: Theme.of(context).accentColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    gapPadding: 10.0,
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                onChanged: (category) {
                                  setState(() {
                                    _selectedCategory = category as String;
                                    print(
                                        'Selected color is : $_selectedCategory\n');
                                  });
                                },
                                hint: _selectedCategory.isEmpty
                                    ? Text(
                                        'Select Item color',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                      )
                                    : Text(_selectedColor),
                                items: [
                                  for (int i = 0;
                                      i < lookUpColor.keys.length;
                                      i++)
                                    DropdownMenuItem(
                                      child: Text(lookUpColor.keys.toList()[i]),
                                      value: lookUpColor.keys.toList()[i],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('* Add more Image Url text form or remove!'),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (_imageCounterForm < 3) {
                                      _imageCounterForm++;
                                      _currenIndex++;
                                    }

                                    setState(() {});

                                    // print('counter : $counterForm');
                                  },
                                  icon: Icon(Icons.add),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (_imageCounterForm > 1) {
                                      _imageCounterForm--;
                                      _currenIndex--;

                                      setState(() {});
                                      // print('counter : $counterForm');
                                    }
                                  },
                                  icon: Icon(Icons.remove),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (userProduct.images.isNotEmpty &&
                            _imageCounterForm == userProduct.images.length)
                          ...List.generate(
                            userProduct.images.length,
                            (index) => Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey[500]!),
                                      ),
                                      height: 100,
                                      width: 100,
                                      child: Image.network(
                                        userProduct.images.elementAt(index),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          children: [
                                            Wrap(
                                              children: [
                                                TextFormField(
                                                  focusNode: _imageNode,
                                                  initialValue: userProduct
                                                      .images
                                                      .elementAt(index),
                                                  decoration: InputDecoration(
                                                      labelText: 'Image URL'),
                                                  keyboardType:
                                                      TextInputType.url,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  onEditingComplete: () {
                                                    setState(() {});
                                                  },
                                                  autovalidateMode:
                                                      AutovalidateMode.always,
                                                  validator: (val) {
                                                    var validImage = val!
                                                            .contains('jpg') ||
                                                        val.contains('png') ||
                                                        val.contains('image');
                                                    print(
                                                        'valid: $validImage\n');
                                                    if (val.isEmpty) {
                                                      return 'Image URL cannot be empty';
                                                    }
                                                    if (!validImage) {
                                                      return 'invalid image URL';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (val) {
                                                    if (_imageCounterForm ==
                                                        1) {
                                                      _imageURL1 = val;
                                                    } else if (_imageCounterForm ==
                                                        2) {
                                                      _imageURL2 = val;
                                                    } else {
                                                      _imageURL3 = val;
                                                    }

                                                    // setState(() {});
                                                  },
                                                  onSaved: (enteredValue) {
                                                    userProduct.images
                                                        .add(enteredValue!);
                                                    userProduct =
                                                        userProduct.copyWith(
                                                            images: userProduct
                                                                .images);
                                                  },
                                                  // onFieldSubmitted: (_) => _submitData,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        if (userProduct.images.isEmpty ||
                            _imageCounterForm > userProduct.images.length)
                          ...List.generate(
                            _imageCounterForm,
                            (index) => Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey[500]!),
                                      ),
                                      height: 100,
                                      width: 100,
                                      child: (_imageURL1.isEmpty &&
                                                  _imageCounterForm == 1) ||
                                              (_imageURL2.isEmpty &&
                                                  _imageCounterForm == 2) ||
                                              (_imageURL3.isEmpty &&
                                                  _imageCounterForm == 3)
                                          ? Text('Please Enter URL')
                                          : _imageURL1.isNotEmpty &&
                                                  _imageCounterForm == 1
                                              // &&
                                              // index == _currenIndex
                                              ? Image.network(
                                                  _imageURL1,
                                                  fit: BoxFit.cover,
                                                )
                                              : _imageURL2.isNotEmpty &&
                                                      _imageCounterForm == 2
                                                  // &&
                                                  // index == _currenIndex
                                                  ? Image.network(
                                                      _imageURL2,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(
                                                      _imageURL3,
                                                      fit: BoxFit.cover,
                                                    ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          children: [
                                            Wrap(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.spaceBetween,
                                              children: [
                                                TextFormField(
                                                  focusNode: _imageNode,
                                                  // controller: _imageCounterForm == 1
                                                  //     ? _imageController1
                                                  //     : _imageCounterForm == 2
                                                  //         ? _imageController2
                                                  //         : _imageController3,
                                                  decoration: InputDecoration(
                                                      labelText: 'Image URL'),
                                                  keyboardType:
                                                      TextInputType.url,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  onEditingComplete: () {
                                                    setState(() {});
                                                  },
                                                  autovalidateMode:
                                                      AutovalidateMode.always,
                                                  validator: (val) {
                                                    var validImage = val!
                                                            .contains('jpg') ||
                                                        val.contains('png') ||
                                                        val.contains('image');
                                                    print(
                                                        'valid: $validImage\n');
                                                    if (val.isEmpty) {
                                                      return 'Image URL cannot be empty';
                                                    }
                                                    if (!validImage) {
                                                      return 'invalid image URL';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (val) {
                                                    if (_imageCounterForm ==
                                                        1) {
                                                      _imageURL1 = val;
                                                    } else if (_imageCounterForm ==
                                                        2) {
                                                      _imageURL2 = val;
                                                    } else {
                                                      _imageURL3 = val;
                                                    }

                                                    // setState(() {});
                                                  },
                                                  onSaved: (enteredValue) {
                                                    userProduct.images
                                                        .add(enteredValue!);
                                                    userProduct =
                                                        userProduct.copyWith(
                                                            images: userProduct
                                                                .images);
                                                  },
                                                  // onFieldSubmitted: (_) => _submitData,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.end,
                        //   children: [
                        //     Container(
                        //       decoration: BoxDecoration(
                        //         border: Border.all(color: Colors.grey[500]!),
                        //       ),
                        //       height: 100,
                        //       width: 100,
                        //       child: Padding(
                        //         padding: const EdgeInsets.only(left: 8.0, top: 10),
                        //         child: Text('Please Enter URL'),
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: Padding(
                        //         padding: const EdgeInsets.only(left: 8.0),
                        //         child: Column(
                        //           children: [
                        //             Wrap(
                        //               // mainAxisAlignment:
                        //               //     MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 Text('* Add more color text form or remove!'),
                        //                 Row(
                        //                   children: [
                        //                     IconButton(
                        //                       onPressed: () {
                        //                         _imageCounterForm++;

                        //                         setState(() {});
                        //                         // print('counter : $counterForm');
                        //                       },
                        //                       icon: Icon(Icons.add),
                        //                     ),
                        //                     IconButton(
                        //                       onPressed: () {
                        //                         if (_imageCounterForm > 1) {
                        //                           _imageCounterForm--;
                        //                           setState(() {});
                        //                           // print('counter : $counterForm');
                        //                         }
                        //                       },
                        //                       icon: Icon(Icons.remove),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //             ...List.generate(
                        //               _imageCounterForm,
                        //               (index) => TextFormField(
                        //                 decoration:
                        //                     InputDecoration(labelText: 'Image URL'),
                        //                 keyboardType: TextInputType.url,
                        //                 textInputAction: TextInputAction.done,
                        //                 onEditingComplete: () {},
                        //                 autovalidateMode: AutovalidateMode.always,
                        //                 validator: (val) {
                        //                   if (val!.isEmpty) {
                        //                     return 'Image URL cannot be empty';
                        //                   }
                        //                   return null;
                        //                 },
                        //                 onSaved: (enteredValue) {},
                        //                 onFieldSubmitted: (_) => _saveData(),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10.0,
                            top: 10,
                          ),
                          child: ElevatedButton(
                            onPressed: _submitData,
                            child: Text('post'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// TextFormField(
//                       focusNode: _colorNode,
//                       decoration: InputDecoration(
//                           labelText: 'Enter color of each item if applicable'),
//                       keyboardType: TextInputType.text,
//                       textInputAction: TextInputAction.next,
//                       onEditingComplete: () {},
//                       autovalidateMode: AutovalidateMode.always,
//                       validator: (val) {
//                         if (val!.isEmpty) {
//                           return 'color  cannot be empty';
//                         }
//                         return null;
//                       },
//                       onFieldSubmitted: (_) =>
//                           FocusScope.of(context).requestFocus(_imageNode),
//                       onSaved: (enteredValue) {
//                         lookUpColor.entries.forEach((element) {
//                           if (element.key == enteredValue) {
//                             userProduct.colors.add(enteredValue!);
//                             userProduct = userProduct.copyWith(
//                                 colors: userProduct.colors);
//                           }
//                         });
//                       },
//                     ),
//                   ).toList(),
