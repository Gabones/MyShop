import 'package:flutter/material.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Cap',
      description: 'Style black cap by Autoria035.',
      price: 49.99,
      imageUrl:
      'https://instagram.fcxj3-1.fna.fbcdn.net/v/t51.2885-15/e35/131924208_3330188810441114_4116624755007902057_n.jpg?_nc_ht=instagram.fcxj3-1.fna.fbcdn.net&_nc_cat=102&_nc_ohc=RvPd166S8YMAX__Y2nR&tn=0qd9mAziK1IIAARq&edm=AP_V10EBAAAA&ccb=7-4&oh=2d0cd55254929d1de4190b26404b634d&oe=610567C5&_nc_sid=4f375e',
    ),
    Product(
      id: 'p2',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p5',
      title: 'Purple Short',
      description: 'Incredible purple short',
      price: 59.99,
      imageUrl:
      'https://instagram.fcxj3-1.fna.fbcdn.net/v/t51.2885-15/e35/134827209_252395452948921_4222229187501981846_n.jpg?_nc_ht=instagram.fcxj3-1.fna.fbcdn.net&_nc_cat=101&_nc_ohc=C8KS5j6cO3cAX9iZGbd&edm=AP_V10EBAAAA&ccb=7-4&oh=1eed7d8a1d573f53ff52c6892bda2c9b&oe=6106AC19&_nc_sid=4f375e'
    ),
    Product(
        id: 'p6',
        title: 'Black Short',
        description: 'Incredible Black short',
        price: 59.99,
        imageUrl:
        'https://instagram.fcxj3-1.fna.fbcdn.net/v/t51.2885-15/e35/p1080x1080/128467821_125613026025402_7453961432386993107_n.jpg?_nc_ht=instagram.fcxj3-1.fna.fbcdn.net&_nc_cat=106&_nc_ohc=q--Nl-qwxvYAX_PWFsU&edm=AP_V10EBAAAA&ccb=7-4&oh=7bcb7bbea907be301de93588f0b8c8e9&oe=6106C0BB&_nc_sid=4f375e'
    ),
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

  void addProduct() {
    //_items.add(value);
    notifyListeners();
  }
}