import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
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
