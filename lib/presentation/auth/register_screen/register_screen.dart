import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:online_auction_platform/data/api/api.dart';
import 'package:online_auction_platform/data/controller/login_controller.dart';
import 'package:online_auction_platform/presentation/auth/login_screen/login_screen.dart';
import 'package:online_auction_platform/presentation/landing_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' show window;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final LoginController loginController = Get.put(LoginController());

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // FocusNode for controll focus and transfer focus between TextInput Field
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordConfirmFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();

  //Assign TextEditingControllers text to variable
  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  String get _passwordConfirm => _passwordConfirmController.text;
  String get _name => _nameController.text;

  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    try {
      final bool emailisValid = EmailValidator.validate(_email);
      if (!emailisValid) {
        loginController.changeResponse('Add Correct Email');

        return;
      } else if (_email.isNotEmpty) {
        //validate the email
      }

      if (_name.isEmpty) {
        loginController.changeResponse('Name is required');
        return;
      } else if (_password.isEmpty) {
        loginController.changeResponse('Password is required');
        return;
      } else if (_passwordConfirm.isEmpty) {
        loginController.changeResponse('Password Confirm is required');
        return;
      } else if (_password != _passwordConfirm) {
        loginController
            .changeResponse('Password and Password Confirm must be the same');
        return;
      }
      final response = await http.post(
        Uri.parse(Api.register),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': _email,
          'password': _password,
          'name': _name,
          'role': "USER"
        }),
      );
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        window.localStorage["token"] = data['token'];
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) {
            return const LandinPage();
          },
        ));
      } else {
        print('Response Status Code: ${response.body}');
        loginController.changeResponse(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      loginController.changeResponse(e.toString());
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            // bg : f7f4ed

            color: const Color(0xffF7F4ED),
            height: 100.h,
            width: 100.w,
            child: Row(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 100.h,
                      width: 50.w,
                      // child: Lottie.asset('assets/lottie/login.json'),
                    )
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 100.h,
                      width: 50.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'REGISTER',
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 300,
                          ),
                          Obx(() => loginController.response.value == ''
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Text(
                                      loginController.response.value,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                  ],
                                )),
                          emailInput(),
                          const SizedBox(
                            height: 20.0,
                          ),
                          nameInput(),
                          const SizedBox(
                            height: 20.0,
                          ),
                          passwordInput(),
                          const SizedBox(
                            height: 20.0,
                          ),
                          passwordConfirmInput(),
                          const SizedBox(
                            height: 50.0,
                          ),
                          SizedBox(
                            height: 50.0,
                            width: 320.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                    Radius.circular(50.0),
                                  ))),
                              onPressed: _submit,
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) {
                                    return const LoginScreen();
                                  },
                                ));
                              },
                              child: const Text(
                                "Have an account ? Login",
                                style: TextStyle(color: Colors.black),
                              ))
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )));
  }

  SizedBox passwordInput() {
    return SizedBox(
      width: 320.0,
      height: 55.0,
      child: TextField(
        controller: _passwordController,
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 216, 122, 0),
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          hintText: 'Password',
          labelText: 'Enter your Password',
          // errorText: "widget.invalidEmailErrorText",
          hintStyle: TextStyle(
            fontSize: 15,
          ),
          labelStyle: TextStyle(
            fontSize: 15,
          ),
        ),
        autocorrect: false,
        obscureText: true,
        onChanged: (email) => _updateState(),
      ),
    );
  }

  SizedBox passwordConfirmInput() {
    return SizedBox(
      width: 320.0,
      height: 55.0,
      child: TextField(
        controller: _passwordConfirmController,
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 216, 122, 0),
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          hintText: 'Password Confirm',
          labelText: 'Enter your Password again',
          hintStyle: TextStyle(
            fontSize: 15,
          ),
          labelStyle: TextStyle(
            fontSize: 15,
          ),
        ),
        autocorrect: false,
        obscureText: true,
        onChanged: (passwordagain) => _updateState(),
      ),
    );
  }

  SizedBox emailInput() {
    return SizedBox(
      width: 320.0,
      height: 55.0,
      child: TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 216, 122, 0),
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          hintText: 'Enter your Email',
          labelText: 'Email',
          hintStyle: TextStyle(
            fontSize: 15,
          ),
          labelStyle: TextStyle(
            fontSize: 15,
          ),
        ),
        onChanged: (password) => _updateState(),
      ),
    );
  }

  SizedBox nameInput() {
    return SizedBox(
      width: 320.0,
      height: 55.0,
      child: TextField(
        controller: _nameController,
        focusNode: _nameFocusNode,
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 216, 122, 0),
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          hintText: 'Enter your Name',
          labelText: 'Name',
          hintStyle: TextStyle(
            fontSize: 15,
          ),
          labelStyle: TextStyle(
            fontSize: 15,
          ),
        ),
        onChanged: (name) => _updateState(),
      ),
    );
  }

  _updateState() {
    setState(() {});
  }
}
