import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pictureapp/screens/dashboard.dart';
import 'package:pictureapp/screens/registration.dart';
import 'package:pictureapp/services/misc.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final paswordController = TextEditingController();
  bool obsecurepassword = true;

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 50,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                style: const TextStyle(
                    fontFamily: 'AvenirNext', fontWeight: FontWeight.w600),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.transparent, width: 0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    filled: true,
                    hintText: 'Email',
                    hintStyle: const TextStyle(
                      fontFamily: 'AvenirNext',
                      fontWeight: FontWeight.w600,
                    )),
                onChanged: (value) {
                  setState(() {});
                },
                controller: emailController,
              ),
            ),
          ),
          SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                style: const TextStyle(
                    fontFamily: 'AvenirNext', fontWeight: FontWeight.w600),
                keyboardType: TextInputType.name,
                obscureText: obsecurepassword,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    filled: true,
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                      fontFamily: 'AvenirNext',
                      fontWeight: FontWeight.w600,
                    )),
                onChanged: (value) {
                  setState(() {});
                },
                controller: paswordController,
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              if (emailController.text.isEmpty ||
                  paswordController.text.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Complete the form",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else if (Misc.validateEmail(emailController.text) != null) {
                Fluttertoast.showToast(
                    msg: "Email provided is not valid",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                setState(() {
                  showSpinner = true;
                });
                try {
                  final auth = FirebaseAuth.instance;
                  // ignore: unused_local_variable
                  var response = await auth.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: paswordController.text);

                  Fluttertoast.showToast(
                      msg: "Successful Sign In",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0);

                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Dashboard()),
                  );
                  setState(() {
                    showSpinner = false;
                  });
                } catch (e) {
                  if (e.toString().contains(
                      'The password is invalid or the user does not have a password.')) {
                    Fluttertoast.showToast(
                        msg: "Password is invalid",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    setState(() {
                      showSpinner = false;
                    });
                  } else if (e.toString().contains(
                      'There is no user record corresponding to this identifier')) {
                    Fluttertoast.showToast(
                        msg: "No such user exists",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    setState(() {
                      showSpinner = false;
                    });
                  }
                  // ignore: avoid_print
                  print(e);
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                width: 400,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: showSpinner == false
                      ? const Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w600),
                        )
                      : const SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignUp()),
              );
            },
            child: const Center(
              child: Text(
                'Sign Up',
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'AvenirNext',
                    fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
    );
  }
}
