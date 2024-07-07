import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../constants.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static const String id = 'Signup Screen';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      color: kPrimaryColor,
      progressIndicator: const CircularProgressIndicator(
        color: kSecondaryColor,
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kPrimaryColor,
        ),
        backgroundColor: kPrimaryColor,
        body: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 42),
                  CustomTextFormField(
                    hint: 'Username',
                    iconn: Icons.person,
                    textType: TextInputType.name,
                    controller: usernameController,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    hint: 'Email',
                    iconn: Icons.email,
                    textType: TextInputType.emailAddress,
                    controller: emailController,
                    validate: validateEmail,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    hint: 'Password',
                    iconn: Icons.lock,
                    textType: TextInputType.visiblePassword,
                    hideText: true,
                    controller: passwordController,
                    validate: validatePassword,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    splashColor: Colors.purple,
                    borderRadius: BorderRadius.circular(24),
                    backgroundColor: kSecondaryColor,
                    height: 50,
                    width: double.infinity,
                    onTap: _signUp,
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (!Navigator.canPop(context)) {
                            Navigator.pushNamed(context, LoginScreen.id);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          '  Log in',
                          style: TextStyle(
                            color: Color(0xffC9624B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    if (_key.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        final newUser = await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        await _firestore.collection('users').doc(newUser.user!.uid).set({
          'uid': newUser.user!.uid,
          'email': emailController.text,
          'username': usernameController.text,
        });
        if (context.mounted) {
          if (!Navigator.canPop(context)) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ));
          } else {
            Navigator.pop(context);
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showSnackBar(context, 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          showSnackBar(context, 'The account already exists for that email.');
        } else {
          showSnackBar(context, e.message.toString());
        }
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: const TextStyle(
            color: Colors.red,
          ),
        ),
        backgroundColor: kPrimaryColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(24),
      ),
    );
  }

  String? validateEmail(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) {
      return 'Email Address is required.';
    }

    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formEmail)) {
      return 'Invalid Email Address format.';
    }
    return null;
  }

  String? validatePassword(String? formPassword) {
    if (formPassword == null || formPassword.isEmpty) {
      return 'Password is required.';
    }

    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~-]).{8,}$';

    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formPassword)) {
      return '''
      Password must be at least 8 characters,
      include an uppercase letter, number and symbol.
      ''';
    }

    return null;
  }
}
