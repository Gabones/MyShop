import 'package:flutter/material.dart';

import '../widgets/product_grid.dart';

enum FilterOptions {
  Favorites,
  All
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Autoria035',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if(selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert, color: Colors.black,),
              itemBuilder: (_) => [
                PopupMenuItem(child: Text('Favorites'), value: FilterOptions.Favorites,),
                PopupMenuItem(child: Text('Show All'), value: FilterOptions.All,)
              ],
          )
        ],
      ),
      body: ProductGrid(_showOnlyFavorites),
    );
  }
}
