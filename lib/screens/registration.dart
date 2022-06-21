import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:pictureapp/screens/login.dart';
import 'package:pictureapp/services/misc.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
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
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
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
                      borderSide:
                          const BorderSide(color: Colors.transparent, width: 0),
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
                  Firebase.initializeApp();
                  final auth = FirebaseAuth.instance;
                  final CollectionReference usersRef =
                      FirebaseFirestore.instance.collection("users");

                  final userid = await auth.createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: paswordController.text,
                  );

                  await usersRef.doc(userid.user!.uid).set({
                    'userid': userid.user!.uid,
                    'email': emailController.text.toString(),
                    'password': paswordController.text.toString(),
                  });

                  Fluttertoast.showToast(
                      msg: "Successfully registered",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0);

                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignIn()),
                  );
                } catch (e) {
                  if (e.toString().contains(
                      'The email address is already in use by another account.')) {
                    Fluttertoast.showToast(
                        msg: "Email is already used",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.lightBlue,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                  // ignore: avoid_print
                  print(e);
                }
                setState(() {
                  showSpinner = false;
                });
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
                          'Register',
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignIn()),
              );
            },
            child: const Center(
              child: Text(
                ' Log in',
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
