import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // FocusNode for controll focus and transfer focus between TextInput Field
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  //Assign TextEditingControllers text to variable
  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    try {} catch (e) {
      print(e.toString());
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
                      child: Lottie.asset('assets/lottie/login.json'),
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
                          SizedBox(
                            height: 300,
                          ),
                          EmailInput(),
                          const SizedBox(
                            height: 20.0,
                          ),
                          PasswordInput(),
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
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              onPressed: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //   builder: (_) {
                                //     // return UserRegister();
                                //   },
                                // ));
                              },
                              child: Text(
                                "No account ? Register",
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

  SizedBox PasswordInput() {
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

  SizedBox EmailInput() {
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

  _updateState() {
    setState(() {});
  }
}
