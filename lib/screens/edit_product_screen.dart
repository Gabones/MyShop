import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName ='/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  @override
  void dispose() {
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_priceFocus),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Price'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_descriptionFocus),
              focusNode: _priceFocus,

            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.multiline,
              focusNode: _descriptionFocus,
              maxLines: 3,
            ),
          ],
        ),),
      ),
    );
  }
}
