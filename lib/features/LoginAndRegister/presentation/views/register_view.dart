import 'package:baby/core/widget/custom_text_field.dart';
import 'package:baby/features/LoginAndRegister/presentation/views/data_user_view.dart';
import 'package:baby/features/LoginAndRegister/presentation/views/login_view.dart';
import 'package:baby/features/LoginAndRegister/presentation/views/widgets/divider_of_or_text.dart';
import 'package:baby/features/LoginAndRegister/presentation/views/widgets/header_of_main_page_register_and_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterView extends StatefulWidget {
  RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool isAsync = false;
  final formKeyReg = GlobalKey<FormState>();
  String? email, password;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        color: Colors.black,
      ),
      color: Colors.black,
      inAsyncCall: isAsync,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Form(
              key: formKeyReg,
              autovalidateMode: autovalidateMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    child: SizedBox(
                      height: screenHeight * 0.02,
                    ),
                  ),
                  Header(),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Text(
                    'Let\'s Sign You Up',
                    style: TextStyle(fontFamily: 'Gilroy-Bold', fontSize: 27),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Text(
                    'Welcome To Our App!',
                    style: TextStyle(
                        fontFamily: 'Gilroy', fontSize: 22, color: Colors.grey),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Text(
                    'We are pleased to have you!',
                    style: TextStyle(
                        fontFamily: 'Gilroy', fontSize: 22, color: Colors.grey),
                  ),
                  SizedBox(
                    height: screenHeight * 0.1,
                  ),
                  CustomTextField(
                    mainText: 'Email',
                    onChange: (value) {
                      email = value;
                    },
                    obscure: false,
                    textInputType: TextInputType.emailAddress,
                    hint: 'Enter Your Email',
                    isPassword: false,
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  CustomTextField(
                    mainText: 'Password',
                    onChange: (value) {
                      password = value;
                    },
                    obscure: true,
                    textInputType: TextInputType.emailAddress,
                    hint: 'Enter Your Password',
                    isPassword: true,
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  DividerOfOrText(),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.35),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          backgroundColor: Colors.grey,
                          minimumSize: Size(double.infinity, 60),
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.google,
                              color: Colors.white,
                            ),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already Have An Account?'),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return LoginView();
                            }));
                          },
                          icon: Icon(FontAwesomeIcons.signInAlt))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.2, vertical: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        backgroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 60),
                      ),
                      onPressed: () async {
                        if (formKeyReg.currentState != null &&
                            formKeyReg.currentState!.validate()) {
                          setState(() {
                            isAsync = true;
                          });

                          try {
                            UserCredential credential = await FirebaseAuth
                                .instance
                                .createUserWithEmailAndPassword(
                              email: email!,
                              password: password!,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.black,
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  'Register Done Successfully. Please verify your email.',
                                  style: TextStyle(fontFamily: 'Gilroy'),
                                ),
                              ),
                            );

                            setState(() {
                              isAsync = false;
                            });

                            await FirebaseAuth.instance.currentUser!
                                .sendEmailVerification();

                            bool emailVerified = false;
                            while (!emailVerified) {
                              await Future.delayed(Duration(seconds: 3));
                              await FirebaseAuth.instance.currentUser!.reload();
                              emailVerified = FirebaseAuth
                                  .instance.currentUser!.emailVerified;
                            }

                            if (emailVerified) {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return LoginView();
                              }));
                            } else {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return LoginView();
                              }));
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.black,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    'The password provided is too weak.',
                                    style: TextStyle(fontFamily: 'Gilroy'),
                                  ),
                                ),
                              );
                            } else if (e.code == 'email-already-in-use') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.black,
                                  behavior: SnackBarBehavior.floating,
                                  content: FirebaseAuth
                                          .instance.currentUser!.emailVerified
                                      ? Text(
                                          'The account already exists for that email.',
                                          style:
                                              TextStyle(fontFamily: 'Gilroy'),
                                        )
                                      : Text(
                                          'The account already exists for that email, verify your email to login.',
                                          style:
                                              TextStyle(fontFamily: 'Gilroy'),
                                        ),
                                ),
                              );
                            }
                          } catch (e) {
                            setState(() {
                              isAsync = false;
                            });
                          }
                        } else {
                          setState(() {
                            autovalidateMode = AutovalidateMode.always;
                          });
                        }
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'Gilroy-Bold'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
