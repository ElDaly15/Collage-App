import 'dart:async';

import 'package:baby/core/models/data_user_model.dart';
import 'package:baby/features/LoginAndRegister/presentation/views/widgets/header_of_main_page_register_and_login.dart';
import 'package:baby/features/home/presentation/views/widget/custom_profile_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key, required this.email});
  final String email;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String? name;
  String? grade;
  String? group;
  String? uni;
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
            name = dataUserModel.name;
            grade = dataUserModel.grade;
            group = dataUserModel.group;
            uni = dataUserModel.collage;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription
        .cancel(); // Cancel the subscription when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(child: SizedBox()),
          Header(),
          CustomListTile(
            object: name == null ? 'Loading ...' : name!,
            IconO: Icons.person,
          ),
          CustomListTile(
            object: widget.email,
            IconO: Icons.email,
          ),
          CustomListTile(
            object: grade == null ? 'Loading ...' : grade!,
            IconO: Icons.grade,
          ),
          CustomListTile(
            object: 'Group : ${group == null ? 'Loading ... ' : group!}',
            IconO: Icons.group,
          ),
          CustomListTile(
            object: uni == null ? 'Loading ...' : uni!,
            IconO: Icons.school,
          ),
        ],
      ),
    );
  }
}
