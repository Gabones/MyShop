import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate = DateTime.now();
  late String _userId;

  static const _key = 'AIzaSyCS7jEVInweLXN_d1cn7uHb3LSKwRIoH8k';

  //Auth(this._token, this._expiryDate, this._userId);

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null) {
      //print('teste datetime deu after');
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(String? email, String? password, String urlSegment) async {
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$_key');
    try{
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData?['expiresIn'])));
      // print(responseData['expiresIn']);
      // print(_expiryDate);
      notifyListeners();
    } catch(error) {
      throw error;
    }

  }

  Future<void> singUp(String? email, String? password) async {
    return _authenticate(email, password, 'singUp');
  }

  Future<void> login(String? email, String? password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
