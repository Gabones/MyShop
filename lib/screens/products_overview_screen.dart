import 'package:flutter/material.dart';

import '../widgets/product_grid.dart';


class ProductsOverviewScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          'Autoria035',
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),
      body: ProductGrid(),
    );
  }
}
