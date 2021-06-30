import 'package:e_commerce_app/error/http_exceptions/http_exceptions.dart';
import 'package:e_commerce_app/screen/loading_screen.dart';
import 'package:e_commerce_app/services/database.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as user;
import 'package:e_commerce_app/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum AuthMode { LOGIN, SIGNUP, RESET }

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.LOGIN;
  Animation<double>? _opacityAnim; // fade in animation
  Animation<Offset>? _slideAnim;
  AnimationController? _controller;
  var _loading = false;
  var userInfo = user.User(
    uuid: "",
    fullName: "",
    // token: "",
    // expiryDate: null,
    email: "",
    password: "",
  ); // slide transition animation

  final offsetX = -1.5;
  final offsetY = 0.0;
  final beginOpacity = 0.0;
  final endOpacity = 1.0;

  @override
  void initState() {
    // init
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _opacityAnim = Tween<double>(begin: beginOpacity, end: endOpacity)
        .animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeOutQuad,
    ));
    _slideAnim = Tween<Offset>(
            begin: Offset(offsetX, offsetY), end: Offset(0, 0))
        .animate(
            CurvedAnimation(parent: _controller!, curve: Curves.easeOutQuad));

    super.initState();
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('an error occured'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Okay!'),
          )
        ],
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _loading = true;
    });
    try {
      if (_authMode == AuthMode.LOGIN) {
        // login user
        // print('user logged in info\n');
        // print('email: ${userInfo.email}\npassword:${userInfo.password}\n');
        await Provider.of<DatabaseServices>(context, listen: false)
            .signIn(userInfo);
      } else {
        // sign up user
        // print('user signed up info\n');
        // print(
        //     'email: ${userInfo.email}\npassword:${userInfo.password}\nFullName:${userInfo.fullName}\n');
        await Provider.of<DatabaseServices>(context, listen: false)
            .signUp(userInfo);
      }
    } on HttpException catch (error) {
      print('catch error is ${error.toString()}');
      var errorMessage = 'Authentication failed.';
      if (error.toString().contains('The password is invalid')) {
        errorMessage = 'invalid password';
        print(errorMessage);
      } else if (error
          .toString()
          .contains('already in use by another account.')) {
        errorMessage = 'email address is already in use.';
      } else if (error.toString().contains('operation not allowed')) {
        errorMessage = 'OPERATION_NOT_ALLOWED';
      } else if (error.toString().contains('many failed login attempts')) {
        errorMessage =
            'Access to this account has been temporarily disabled due to many failed login attempts\n. You can immediately restore it by resetting your password or you can try again later.';
      } else if (error.toString().contains('no user record')) {
        errorMessage = 'could not find email address provided';
      } else if (error.toString().contains('account has been disabled')) {
        errorMessage = 'The user account has been disabled by an administrator';
      } else if (error.toString().contains('password is weak')) {
        errorMessage = 'the password is weak.';
      } else if (error.toString().contains('email doesnt exist')) {
        errorMessage = 'this email doesnt exist';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      const errorMessage = 'could not authenticate you. please try later';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _loading = false;
    });
  }

  void _toggleAuthMode() {
    if (_authMode == AuthMode.LOGIN) {
      setState(() {
        _authMode = AuthMode.SIGNUP;
      });
      _controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.LOGIN;
      });
      _controller!.reverse();
    }

    // _controller!.addStatusListener((status) {
    //   if (status == AnimationStatus.dismissed) {
    //     print('status: $status\n');
    //     _controller!.reverse(from: endOpacity);
    //   }
    //   // else {
    //   //   print('status: $status\n');
    //   // }
    // });

    print('AuthMode is $_authMode\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // top: true,
        child: _loading
            ? Loading()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    // height: 300,
                    // width: double.infinity,
                    child: Image.asset(
                      'images/e_logo.png',
                      fit: BoxFit.cover,
                      height: 100,
                      width: double.infinity,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Text(
                              _authMode == AuthMode.LOGIN ? 'Login' : 'Sign up',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          Form(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                if (_authMode == AuthMode.SIGNUP)
                                  FadeTransition(
                                    opacity: _opacityAnim!,
                                    child: SlideTransition(
                                      position: _slideAnim!,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          textAlign: TextAlign.center,
                                          decoration: kTextField.copyWith(
                                            hintStyle: TextStyle(
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                            hintText: 'Enter full name',
                                            labelText: 'Full Name',
                                            prefixIcon: Icon(Icons.person),
                                          ),
                                          onSaved: (enteredName) {
                                            userInfo = userInfo.copyWith(
                                                fullName: enteredName);
                                          },
                                          validator: (enteredVal) {
                                            if (enteredVal!.isEmpty) {
                                              return 'Please enter first and last name';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    decoration: kTextField.copyWith(
                                      hintStyle: TextStyle(
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                    onSaved: (enterEmail) {
                                      userInfo =
                                          userInfo.copyWith(email: enterEmail);
                                    },
                                    validator: (enteredVal) {
                                      if (_authMode == AuthMode.SIGNUP) {
                                        if (enteredVal!.isEmpty) {
                                          return 'Email cannot be empty.';
                                        } else if (!enteredVal.isValidEmail()) {
                                          return 'Please enter valid email';
                                        }
                                        return null;
                                      } else {
                                        if (enteredVal!.isEmpty) {
                                          return 'Email cannot be empty.';
                                        }
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    obscureText: true,
                                    textAlign: TextAlign.center,
                                    decoration: kTextField.copyWith(
                                      helperText: _authMode == AuthMode.SIGNUP
                                          ? 'must be at least 8 characters long.'
                                          : "",
                                      hintText: 'enter password',
                                      prefixIcon: Icon(Icons.lock),
                                      labelText: 'password',
                                      hintStyle: TextStyle(
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                    onSaved: (enteredText) {
                                      userInfo = userInfo.copyWith(
                                        password: enteredText,
                                      );
                                      // print('password: ${userInfo.password}\n');
                                    },
                                    onChanged: (enteredText) {
                                      userInfo = userInfo.copyWith(
                                        password: enteredText,
                                      );
                                      // print('password: ${userInfo.password}\n');
                                    },
                                    validator: (enteredVal) {
                                      if (_authMode == AuthMode.SIGNUP) {
                                        if (enteredVal!.isEmpty) {
                                          return 'Password cannot be empty.';
                                        } else if (enteredVal.length < 8) {
                                          return 'password must be at least 8 characters long';
                                        }
                                      } else {
                                        if (enteredVal!.isEmpty) {
                                          return 'Password cannot be empty.';
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                if (_authMode == AuthMode.LOGIN)
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'forget password',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (_authMode == AuthMode.SIGNUP)
                                  FadeTransition(
                                    opacity: _opacityAnim!,
                                    child: SlideTransition(
                                      position: _slideAnim!,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              obscureText: true,
                                              textAlign: TextAlign.center,
                                              decoration: kTextField.copyWith(
                                                hintText: 'confirm password',
                                                prefixIcon: Icon(Icons.lock),
                                                labelText: 'Confirm password',
                                                helperText:
                                                    '* both password must match.',
                                                hintStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                              ),
                                              validator: (enteredVal) {
                                                if (enteredVal!.isEmpty) {
                                                  return 'confrim Password cannot be empty.';
                                                } else if (enteredVal !=
                                                    userInfo.password) {
                                                  print('no match\n');
                                                  return 'password must match';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 10),
                                  child: ElevatedButton(
                                    onPressed: _submit,
                                    child: Text(_authMode == AuthMode.LOGIN
                                        ? 'Login'
                                        : 'Sign up'),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 20,
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      text: _authMode == AuthMode.SIGNUP
                                          ? 'Already have an Account? '
                                          : "don't have account? ",
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: _authMode == AuthMode.SIGNUP
                                              ? 'Login '
                                              : 'Sign up here',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              _toggleAuthMode();
                                            },
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
