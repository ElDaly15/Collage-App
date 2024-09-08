import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:baby/core/models/data_user_model.dart';
import 'package:baby/core/widget/custom_text_field.dart';
import 'package:baby/features/LoginAndRegister/presentation/manager/submit_data_user_cubit/submit_data_user_cubit.dart';
import 'package:baby/features/LoginAndRegister/presentation/views/data_user_view.dart';
import 'package:baby/features/LoginAndRegister/presentation/views/register_view.dart';
import 'package:baby/features/LoginAndRegister/presentation/views/widgets/divider_of_or_text.dart';
import 'package:baby/features/LoginAndRegister/presentation/views/widgets/header_of_main_page_register_and_login.dart';
import 'package:baby/features/home/presentation/views/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isAsync = false;
  final formKey = GlobalKey<FormState>();
  String? email, password;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  List<DataUserModel> dataUserModel = [];
  Future<void> loginUser() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      setState(() {
        isAsync = true;
        autovalidateMode = AutovalidateMode.disabled;
      });

      try {
        UserCredential credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email!, password: password!);

        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.black,
              behavior: SnackBarBehavior.floating,
              content: Text(
                'Login Done Successfully',
                style: TextStyle(fontFamily: 'Gilroy'),
              ),
            ),
          );
          BlocProvider.of<SubmitDataUserCubit>(context)
              .usersData
              .snapshots()
              .listen((data) {
            for (int i = 0; i < data.docs.length; i++) {
              dataUserModel.add(DataUserModel.jsonData(data.docs[i].data()));
            }
          });

          QuerySnapshot querySnapshot =
              await BlocProvider.of<SubmitDataUserCubit>(context)
                  .usersData
                  .where('email', isEqualTo: email)
                  .limit(1)
                  .get();

          print(querySnapshot);

          if (querySnapshot.docs.isNotEmpty) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return HomeView(email: email!);
            }));
          } else {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return DataUserView(email: email!);
            }));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.black,
              behavior: SnackBarBehavior.floating,
              content: Text(
                'Verify Your Email Now, To Can Login',
                style: TextStyle(fontFamily: 'Gilroy'),
              ),
            ),
          );
          Timer(
            const Duration(seconds: 3),
            () {
              FirebaseAuth.instance.currentUser!.sendEmailVerification();
            },
          );
        }
      } on FirebaseAuthException catch (e) {
        print('FirebaseAuthException: ${e.code}');
        if (e.code == 'user-not-found') {
          print('User not found');
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'User Not Found',
            descTextStyle: TextStyle(color: Colors.red),
            btnOkOnPress: () {},
          ).show();
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'Wrong Password',
            btnOkOnPress: () {},
          ).show();
        } else if (e.code == 'invalid-credential') {
          print('Invalid credential');
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.bottomSlide,
            title: 'Error',
            desc: 'Password Or Email Was Incorrect',
            btnOkOnPress: () {},
            btnOkColor: Colors.red,
          ).show();
        }
      }

      setState(() {
        isAsync = false;
      });
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

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
              autovalidateMode: autovalidateMode,
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    child: SizedBox(
                      height: screenHeight * 0.02,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Text(
                    'Let\'s Sign You in',
                    style: TextStyle(fontFamily: 'Gilroy-Bold', fontSize: 27),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Text(
                    'Welcome Back ',
                    style: TextStyle(
                        fontFamily: 'Gilroy', fontSize: 22, color: Colors.grey),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Text(
                    'You have been missed !',
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
                      Text('Don\'t Have An Account ?'),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return RegisterView();
                            }));
                          },
                          icon: Icon(FontAwesomeIcons.registered))
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
                      onPressed: loginUser,
                      child: Text(
                        'Login',
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
