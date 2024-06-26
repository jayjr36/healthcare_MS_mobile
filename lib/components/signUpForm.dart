import 'package:flutter/material.dart';
import 'package:healthcare_management_system/models/authModel.dart';
import 'package:healthcare_management_system/providers/dioProvider.dart';
import 'package:healthcare_management_system/screens/loginPage.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../utils/config.dart';
import 'button.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _passController2 = TextEditingController();
  bool obsecurePass = true;
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      constraints: BoxConstraints(
        maxHeight: h * 0.8,
      ),
      child: Form(
        key: _formKey,
        child: LoadingOverlay(
          isLoading: isloading,
          progressIndicator: CircularProgressIndicator(
            color: Colors.red,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                cursorColor: Config.primaryColor,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  labelText: 'Username',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.person_outlined),
                  prefixIconColor: Config.primaryColor,
                ),
                onChanged: (val) {
                  setState(() {
                    fullName = val;
                  });
                },
                validator: (val) {
                  if (val!.isNotEmpty) {
                    return null;
                  } else {
                    return "Name cannot be empty";
                  }
                },
              ),
              Config.spaceSmall,
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Config.primaryColor,
                decoration: const InputDecoration(
                  hintText: 'Email Address',
                  labelText: 'Email',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.email_outlined),
                  prefixIconColor: Config.primaryColor,
                ),
                validator: (val) {
                  return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val!)
                      ? null
                      : "Please enter a valid email";
                },
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              Config.spaceSmall,
              TextFormField(
                controller: _passController,
                keyboardType: TextInputType.visiblePassword,
                cursorColor: Config.primaryColor,
                obscureText: obsecurePass,
                decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'Password',
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    prefixIconColor: Config.primaryColor,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obsecurePass = !obsecurePass;
                          });
                        },
                        icon: obsecurePass
                            ? const Icon(
                                Icons.visibility_off_outlined,
                                color: Colors.black38,
                              )
                            : const Icon(
                                Icons.visibility_outlined,
                                color: Config.primaryColor,
                              ))),
                validator: (val) {
                  if (val!.length < 8) {
                    return "Password must be at least 8 characters";
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              Config.spaceSmall,
              TextFormField(
                controller: _passController2,
                keyboardType: TextInputType.visiblePassword,
                cursorColor: Config.primaryColor,
                obscureText: obsecurePass,
                decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    labelText: 'Confirm Password',
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    prefixIconColor: Config.primaryColor,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obsecurePass = !obsecurePass;
                          });
                        },
                        icon: obsecurePass
                            ? const Icon(
                                Icons.visibility_off_outlined,
                                color: Colors.black38,
                              )
                            : const Icon(
                                Icons.visibility_outlined,
                                color: Config.primaryColor,
                              ))),
                validator: (val) {
                  if (_passController.text != _passController2.text) {
                    return "Passwords do not match";
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),

              Config.spaceSmall,
              Consumer<AuthModel>(builder: (context, auth, child) {
                return Button(
                  width: double.infinity,
                  title: 'Sign Up',
                  onPressed: () async {
                    setState(() {
                      isloading = true;
                    });
                    final userRegistration = await DioProvider().registerUser(
                        _nameController.text,
                        _emailController.text,
                        _passController.text);

                    if (userRegistration) {
                      final token = await DioProvider().loginUser(
                          _emailController.text, _passController.text);

                      if (token) {
                        auth.loginSuccess();
                        MyApp.navigatorKey.currentState!.pushNamed('home');
                        setState(() {
                          isloading = false;
                        });
                      }
                    } else {
                      print('Register not successful!');
                      setState(() {
                        isloading = false;
                      });
                    }
                    setState(() {
                      isloading = false;
                    });
                  },
                  disable: false,
                );
              }),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => LoginPage())));
                  },
                  child: Text('Sign In'))
            ],
          ),
        ),
      ),
    );
  }
}
