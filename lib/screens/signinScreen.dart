import 'package:dar_elanaqa/logic/models/user.dart';
import 'package:dar_elanaqa/widgets/AlertMSG.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isVisiable = true;
  bool isLoading = false;
  var auth = FirebaseAuth.instance;
  var formKey = GlobalKey<FormState>();
  var user = UserLogin(Password: "", Email: "");

  void SaveForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();
      ////////////////
      // await register();
      await login();
    }
  }

  login() async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: user.Email, password: user.Password);
      formKey.currentState?.reset();
      Navigator.of(context).pushReplacementNamed("/main");
    } catch (e) {
      showAlertDialog(
          context: context,
          title: "Sign in Error",
          content:
              "No user found for that email.\n or Wrong password provided for that user.",
          defaultActionText: "Try Again!",
          onOkPressed: () {
            Navigator.of(context).pop();
          },
          show: false);
    }
  }

  register() async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
          email: user.Email, password: user.Password);
      print(credential.user);
      formKey.currentState?.reset();

      Navigator.of(context).pushReplacementNamed("/main");
    } catch (e) {
      showAlertDialog(
          context: context,
          title: "Sign up Error",
          content:
              "The account already exists for that email.\n or The password provided is too weak.",
          defaultActionText: "Try Again!",
          onOkPressed: () {
            Navigator.of(context).pop();
          },
          show: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "تسجيل دخول",
          textAlign: TextAlign.end,
        ),
        actions: [
          IconButton(
              onPressed: () {
                formKey.currentState?.reset();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: formKey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        user.Email = value!;
                      });
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.black)),
                      label: Text("Email"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    onSaved: (value) {
                      setState(() {
                        user.Password = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                    obscureText: isVisiable,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.black)),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isVisiable = !isVisiable;
                            });
                          },
                          child: Icon(
                            isVisiable
                                ? Icons.remove_red_eye_outlined
                                : Icons.remove_red_eye,
                          ),
                        ),
                        label: Text("Password")),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: OutlinedButton(
                    child: Text(
                      "تسجيل دخول",
                    ),
                    onPressed: SaveForm,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
