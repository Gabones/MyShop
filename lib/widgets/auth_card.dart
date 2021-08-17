import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/auth_screen.dart';
import '../models/http_exception.dart';

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Erro'),
              content: Text(message),
          actions: [
            TextButton(
              child: Text('Ok', style: TextStyle(color: Colors.black)),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
            )
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'], _authData['password']);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .singUp(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authenticate Failed.';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'Este email já esta sendo usado.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Por favor informe um email válido.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Senha fraca.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Email não encontrado.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Senha incorreta.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey.shade300,
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    child: Text(
                      _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.button!.color,
                      ),
                    ),
                    onPressed: _submit,
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 8.0)),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor)),
                  ),
                TextButton(
                  child: Text(
                    '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onPressed: _switchAuthMode,
                  style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 4)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
