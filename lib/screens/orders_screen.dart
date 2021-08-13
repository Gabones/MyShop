import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  // @override
  // void initState() {
  //   _isLoading = true;
  //   Provider.of<Orders>(context, listen: false)
  //       .fetchAndSetOrders()
  //       .then((value) => setState(() {
  //             _isLoading = false;
  //           }));
  //   super.initState();
  // }

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) async {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Suas ordens de Compra'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapShot) {
          if(dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.black));
          } else {
            if(dataSnapShot.error != null) {
              return Center(child: Text('An error ocurred'));
            } else {
              return Consumer<Orders>(builder: (ctx, orderData, child) => ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
              ));
            }
          }
        },
      )
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   final orderData = Provider.of<Orders>(context);
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('Suas ordens de Compra'),
//     ),
//     drawer: AppDrawer(),
//     body: _isLoading
//         ? Center(child: CircularProgressIndicator(color: Colors.black))
//         : ListView.builder(
//       itemCount: orderData.orders.length,
//       itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
//     ),
//   );
// }