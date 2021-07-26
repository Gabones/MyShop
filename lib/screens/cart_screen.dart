import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';

import '../providers/cart.dart';


class CartScreen extends StatelessWidget {

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('\$${cart.totalAmount}', style: TextStyle(color: Colors.white),),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Order Now', style: TextStyle(color: Theme.of(context).accentColor),),
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
