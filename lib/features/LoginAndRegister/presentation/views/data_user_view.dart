import 'dart:io';

import 'package:baby/core/widget/custom_text_field.dart';
import 'package:baby/features/LoginAndRegister/presentation/manager/submit_data_user_cubit/submit_data_user_cubit.dart';
import 'package:baby/features/home/presentation/views/home_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart';

class DataUserView extends StatefulWidget {
  const DataUserView({super.key, required this.email});
  final String email;

  @override
  State<DataUserView> createState() => _DataUserViewState();
}

class _DataUserViewState extends State<DataUserView> {
  String? name;
  String? age;
  String? collage;
  String? group;
  String? grade;
  int? status = 0;
  File? file;
  String? url;
  bool isLoading = false;

  bool isAsync = false;
  final formKeyData = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  getImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? imageCamera =
        await picker.pickImage(source: ImageSource.gallery);

    if (imageCamera != null) {
      file = File(imageCamera.path);

      var imageName = basename(imageCamera.path);
      var refStorage = FirebaseStorage.instance.ref(imageName);
      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();
      setState(() {});
    }
  }

  Future<void> _submitData(BuildContext context) async {
    if (grade == null) {
      _showMessage('Please select your grade', context);
      return;
    }
    if (group == null) {
      _showMessage('Please select your group', context);
      return;
    }
    if (url == null) {
      _showMessage('Please select an image', context);
      return;
    }

    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      await BlocProvider.of<SubmitDataUserCubit>(context).SubmitData(
        email: widget.email,
        name: name!,
        age: age!,
        collage: collage!,
        grade: grade,
        group: group,
        image: url,
        status: status!,
      );

      if (mounted) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return HomeView(email: widget.email);
        }));
      }
    } catch (e) {
      _showMessage('Error submitting data', context);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: TextStyle(fontFamily: 'Gilroy'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return ModalProgressHUD(
      color: Colors.black,
      progressIndicator: CircularProgressIndicator(
        color: Colors.black,
      ),
      inAsyncCall: isAsync,
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  autovalidateMode: autovalidateMode,
                  key: formKeyData,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: isPortrait ? 50 : 20),
                      CustomTextField(
                        mainText: 'Full Name',
                        onChange: (value) {
                          name = value;
                        },
                        obscure: false,
                        textInputType: TextInputType.emailAddress,
                        hint: 'Enter Full Name',
                        isPassword: false,
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        mainText: 'Age',
                        onChange: (value) {
                          age = value;
                        },
                        obscure: false,
                        textInputType: TextInputType.number,
                        hint: 'Enter Age',
                        isPassword: false,
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        mainText: 'Collage',
                        onChange: (value) {
                          collage = value;
                        },
                        obscure: false,
                        textInputType: TextInputType.emailAddress,
                        hint: 'Enter Collage',
                        isPassword: false,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Select Your Grade : ',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Gilroy-Bold',
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 16,
                        runSpacing: 10,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                              backgroundColor: Colors.black,
                              minimumSize: Size(80, 40),
                            ),
                            onPressed: () {
                              setState(() {
                                grade = 'Grade 1';
                              });
                            },
                            child: Text(
                              'Grade 1 ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                              backgroundColor: Colors.black,
                              minimumSize: Size(80, 40),
                            ),
                            onPressed: () {
                              setState(() {
                                grade = 'Grade 2';
                              });
                            },
                            child: Text(
                              'Grade 2 ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                              backgroundColor: Colors.black,
                              minimumSize: Size(80, 40),
                            ),
                            onPressed: () {
                              setState(() {
                                grade = 'Grade 3';
                              });
                            },
                            child: Text(
                              'Grade 3 ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Select Your Group : ',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Gilroy-Bold',
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 16,
                        runSpacing: 10,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                              backgroundColor: Colors.black,
                              minimumSize: Size(80, 40),
                            ),
                            onPressed: () {
                              setState(() {
                                group = 'A';
                              });
                            },
                            child: Text(
                              'A ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                              backgroundColor: Colors.black,
                              minimumSize: Size(80, 40),
                            ),
                            onPressed: () {
                              setState(() {
                                group = 'B';
                              });
                            },
                            child: Text(
                              'B ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Select Good Picture Of You : ',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Gilroy-Bold',
                          fontSize: 16,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          backgroundColor: Colors.black,
                          minimumSize: Size(150, 40),
                        ),
                        onPressed: () async {
                          url = null;
                          try {
                            setState(() {
                              isAsync = true;
                            });
                            await getImage();
                            url != null
                                ? ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.black,
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        'Image Uploaded Successfully',
                                        style: TextStyle(fontFamily: 'Gilroy'),
                                      ),
                                    ),
                                  )
                                : null;
                            setState(() {
                              isAsync = false;
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.black,
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  'Error While Uploading Image.',
                                  style: TextStyle(fontFamily: 'Gilroy'),
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Pick Image',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 150),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.1,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            backgroundColor: Colors.grey,
                            minimumSize: Size(double.infinity, 60),
                          ),
                          onPressed: () {
                            if (formKeyData.currentState != null &&
                                formKeyData.currentState!.validate()) {
                              _submitData(context);
                            }
                          },
                          child: Text(
                            'Submit Data',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontFamily: 'Gilroy-Bold',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
