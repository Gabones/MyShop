import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Cap',
    //   description: 'Style black cap by Autoria035.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://instagram.fcxj3-1.fna.fbcdn.net/v/t51.2885-15/e35/s1080x1080/169083859_118111817022241_9172647398783829585_n.jpg?_nc_ht=instagram.fcxj3-1.fna.fbcdn.net&_nc_cat=101&_nc_ohc=SXKqccAGUekAX96VtLU&edm=AP_V10EBAAAA&ccb=7-4&oh=880ef7852a3b9f3e067c25f99f66a72d&oe=6116A093&_nc_sid=4f375e',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //     id: 'p5',
    //     title: 'Purple Short',
    //     description: 'Incredible purple short',
    //     price: 59.99,
    //     imageUrl:
    //         'https://instagram.fcxj3-1.fna.fbcdn.net/v/t51.2885-15/e35/p1080x1080/129181703_670238113852842_4707354183429729902_n.jpg?_nc_ht=instagram.fcxj3-1.fna.fbcdn.net&_nc_cat=106&_nc_ohc=fGdNdEviSsEAX_QfHWr&edm=AP_V10EBAAAA&ccb=7-4&oh=02748c47ff02a4998bbae108f9fdf4ae&oe=611690FF&_nc_sid=4f375e'),
    // Product(
    //     id: 'p6',
    //     title: 'Black Short',
    //     description: 'Incredible Black short',
    //     price: 59.99,
    //     imageUrl:
    //         'https://instagram.fcxj3-1.fna.fbcdn.net/v/t51.2885-15/e35/p1080x1080/128270414_420518072310386_9138796884129738836_n.jpg?_nc_ht=instagram.fcxj3-1.fna.fbcdn.net&_nc_cat=102&_nc_ohc=vRW4ZinsNtUAX-8Ctgt&edm=AP_V10EBAAAA&ccb=7-4&oh=3285f2c5c9f483c3e959f1d213f4688b&oe=611592A3&_nc_sid=4f375e'),
  ];
  //bool _showFavoritesOnly = false;

  List<Product> get items {
    // if(_showFavoritesOnly) {
    //   return items.where((item) => item.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  //O que não fazer

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }
  //
  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.https(
        'flutter-course-f37f6-default-rtdb.firebaseio.com', '/products.json');
    try {
      final dataProduct = await http.get(url);
      final decodedData = json.decode(dataProduct.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      decodedData.forEach((keyProdId, valProdData) {
        loadedProducts.add(Product(
          id: keyProdId,
          title: valProdData['title'],
          description: valProdData['description'],
          price: valProdData['price'],
          imageUrl: valProdData['imageUrl'],
          isFavorite: valProdData['isFavorite']
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw(e);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.https(
        'flutter-course-f37f6-default-rtdb.firebaseio.com', '/products.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          }));
      print(json.decode(response.body));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (onError) {
      print(onError);
      throw onError;
    }
  }

  // Future<void> addProduct(Product product) {
  //   final url = Uri.https('flutter-course-f37f6-default-rtdb.firebaseio.com', '/products.json');
  //   return http.post(url, body: json.encode({
  //     'title': product.title,
  //     'description': product.description,
  //     'price': product.price,
  //     'imageUrl': product.imageUrl,
  //     'isFavorite': product.isFavorite,
  //   })).then((response) {
  //     print(json.decode(response.body));
  //     final newProduct = Product(
  //         id: json.decode(response.body)['name'],
  //         title: product.title,
  //         description: product.description,
  //         price: product.price,
  //         imageUrl: product.imageUrl
  //     );
  //     _items.add(newProduct);
  //     notifyListeners();
  //   }).catchError((onError) {
  //     print(onError);
  //     throw onError;
  //   });
  // }

  Future<void> editProduct(String id, Product editedProduct) async {
    final indexProd = _items.indexWhere((prod) => prod.id == id);
    if (indexProd >= 0) {
      final url = Uri.https('flutter-course-f37f6-default-rtdb.firebaseio.com', '/products/$id.json');
      await http.patch(url, body: json.encode({
        'title': editedProduct.title,
        'description': editedProduct.description,
        'price': editedProduct.price,
        'imageUrl': editedProduct.imageUrl,
      }));
      _items[indexProd] = editedProduct;
      notifyListeners();
    } else {
      print('fail');
    }
  }

  void deleteProduct(String id) {
    final url = Uri.https('flutter-course-f37f6-default-rtdb.firebaseio.com', '/products/$id.json');
    final oldIndex = _items.indexWhere((prod) => prod.id == id);
    final oldProd = _items[oldIndex];
    http.delete(url).then((response) {
      if(response.statusCode >= 400){
        _items.insert(oldIndex, oldProd);
        notifyListeners();
      }
    });
    _items.removeAt(oldIndex);
    notifyListeners();
  }
}
