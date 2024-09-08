import 'dart:async';

import 'package:baby/core/models/data_user_model.dart';
import 'package:baby/core/widget/custom_text_field.dart';
import 'package:baby/features/LoginAndRegister/presentation/views/widgets/header_of_main_page_register_and_login.dart';
import 'package:baby/features/home/presentation/manager/update_user_data_cubit/update_user_data_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.email});
  final String email;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? newGrade;
  String? newGroup;
  String? newName;
  String? newCollage;

  String? oldGroup;
  String? oldGrade;
  String? oldCollage;
  String? oldName;

  late StreamSubscription<QuerySnapshot> _subscription;

  @override
  void initState() {
    super.initState();
    FetchUserData();
  }

  void FetchUserData() async {
    _subscription = FirebaseFirestore.instance
        .collection('UsersData')
        .where('email', isEqualTo: widget.email)
        .limit(1)
        .snapshots()
        .listen((data) {
      if (data.docs.isNotEmpty) {
        var doc = data.docs.first;
        DataUserModel dataUserModel = DataUserModel.jsonData(doc);
        if (mounted) {
          setState(() {
            oldName = dataUserModel.name;
            oldGrade = dataUserModel.grade;
            oldGroup = dataUserModel.group;
            oldCollage = dataUserModel.collage;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<UpdateUserDataCubit, UpdateUserDataState>(
      listener: (context, state) {
        if (state is UpdateUserDataSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.black,
              behavior: SnackBarBehavior.floating,
              content: Text(
                'Data Updated Successfully',
                style: TextStyle(fontFamily: 'Gilroy'),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(child: SizedBox()),
              Header(),
              CustomTextField(
                mainText: 'Name',
                onChange: (value) {
                  newName = value;
                },
                obscure: false,
                textInputType: TextInputType.text,
                hint: 'Enter New Name',
                isPassword: false,
              ),
              SizedBox(height: 10),
              CustomTextField(
                mainText: 'Collage',
                onChange: (value) {
                  newCollage = value;
                },
                obscure: false,
                textInputType: TextInputType.text,
                hint: 'Enter New Collage',
                isPassword: false,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Select Your New Grade : ',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Gilroy-Bold',
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),
              Wrap(
                spacing: 16.0, // Horizontal spacing between buttons
                runSpacing: 8.0, // Vertical spacing between lines
                children: ['Grade 1', 'Grade 2', 'Grade 3'].map((grade) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Colors.black,
                      minimumSize: Size(screenWidth * 0.25, 40),
                    ),
                    onPressed: () {
                      setState(() {
                        newGrade = grade;
                      });
                    },
                    child: Text(
                      grade,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              Text(
                'Select Your New Group : ',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Gilroy-Bold',
                  fontSize: screenWidth * 0.04,
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 16.0, // Horizontal spacing between buttons
                runSpacing: 8.0, // Vertical spacing between lines
                children: ['A', 'B'].map((group) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Colors.black,
                      minimumSize: Size(screenWidth * 0.25, 40),
                    ),
                    onPressed: () {
                      setState(() {
                        newGroup = group;
                      });
                    },
                    child: Text(
                      group,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.grey,
                    minimumSize: Size(double.infinity, 60),
                  ),
                  onPressed: () {
                    BlocProvider.of<UpdateUserDataCubit>(context)
                        .update_user_data(
                            name: newName ?? oldName!,
                            collage: newCollage ?? oldCollage!,
                            group: newGroup ?? oldGroup!,
                            grade: newGrade ?? oldGrade!,
                            email: widget.email);
                  },
                  child: Text(
                    'Submit Data',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.05,
                      fontFamily: 'Gilroy-Bold',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
