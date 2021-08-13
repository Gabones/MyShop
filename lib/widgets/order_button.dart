import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../providers/cart.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: TextButton(
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.black)
            : Text(
                'Order Now',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.items.values.toList(), widget.cart.totalAmount);
                widget.cart.clear();
                setState(() {
                  _isLoading = false;
                });
              },
      ),
    );
  }
}
