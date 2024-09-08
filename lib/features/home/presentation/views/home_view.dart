import 'dart:async';

import 'package:baby/features/LoginAndRegister/presentation/manager/submit_data_user_cubit/submit_data_user_cubit.dart';
import 'package:baby/features/home/presentation/views/widget/verify_done_widget.dart';
import 'package:baby/features/home/presentation/views/widget/wait_verify.dart';
import 'package:baby/features/section/presentation/manager/get_admin_for_check_cubit/get_admin_for_check_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.email});
  final String email;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int? status;
  late StreamSubscription<QuerySnapshot> _subscription;

  @override
  void initState() {
    super.initState();
    getUserStatus();

    BlocProvider.of<GetAdminForCheckCubit>(context)
        .get_admin(email: widget.email);
  }

  void getUserStatus() {
    _subscription = BlocProvider.of<SubmitDataUserCubit>(context)
        .usersData
        .snapshots()
        .listen(
      (data) async {
        for (var doc in data.docs) {
          if (doc['email'] == widget.email) {
            if (mounted) {
              setState(() {
                status = doc['status'];
              });
            }
            break;
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocListener<SubmitDataUserCubit, SubmitDataUserState>(
          listener: (context, state) {
            if (state is SubmitDataUserSuccess) {
              getUserStatus();
            }
          },
          child: BlocBuilder<SubmitDataUserCubit, SubmitDataUserState>(
            builder: (context, state) {
              if (status == null) {
                return CircularProgressIndicator();
              } else if (status == 0) {
                return WaitVerifyWidget();
              } else {
                return VerifyDoneWidget(
                  email: widget.email,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
