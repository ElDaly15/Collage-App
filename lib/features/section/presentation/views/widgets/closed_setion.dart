import 'dart:async';

import 'package:baby/core/models/attendes_modal.dart';
import 'package:baby/core/models/data_user_model.dart';
import 'package:baby/core/models/setion_modal.dart';
import 'package:baby/features/section/presentation/manager/get_admin_for_check_cubit/get_admin_for_check_cubit.dart';
import 'package:baby/features/section/presentation/manager/submit_attend_cubit/submit_attend_verify_cubit.dart';
import 'package:baby/features/section/presentation/views/history_of_attendens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ClosedSetion extends StatefulWidget {
  ClosedSetion({super.key, required this.setionModel, required this.name});

  final SetionModel setionModel;
  final String name;

  @override
  State<ClosedSetion> createState() => _ClosedSetionState();
}

class _ClosedSetionState extends State<ClosedSetion> {
  var inputFormat = DateFormat('dd.MM.yyyy HH:mm:ss');
  String? name;
  int? status;
  List<AttendesModal> attendens = [];
  bool checkBar = false;
  bool checkAdmin = false;

  StreamSubscription<QuerySnapshot>? attendensSubscription;
  StreamSubscription<QuerySnapshot>? statusSubscription;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchAttendensData();
    fetchStatusCode();
    checkAdmin = BlocProvider.of<GetAdminForCheckCubit>(context).checkAdmin;
  }

  @override
  void dispose() {
    attendensSubscription?.cancel();
    statusSubscription?.cancel();
    super.dispose();
  }

  fetchUserData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('UsersData')
          .where('email', isEqualTo: widget.name)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        DataUserModel user = DataUserModel.jsonData(
            documentSnapshot.data()! as Map<String, dynamic>);
        if (mounted) {
          setState(() {
            name = user.name;
          });
        }
      }
    } catch (e) {
      print('Failed to fetch user data: $e');
    }
  }

  fetchAttendensData() {
    try {
      attendensSubscription = FirebaseFirestore.instance
          .collection(
              '${widget.setionModel.docName} in ${widget.setionModel.date}')
          .snapshots()
          .listen((querySnapshot) {
        if (mounted) {
          setState(() {
            attendens = querySnapshot.docs
                .map((doc) =>
                    AttendesModal.jsonData(doc.data() as Map<String, dynamic>))
                .toList();
          });
        }
      });
    } catch (e) {
      print('Failed to fetch attendance data: $e');
    }
  }

  fetchStatusCode() {
    try {
      statusSubscription = FirebaseFirestore.instance
          .collection('setions')
          .where('name', isEqualTo: widget.setionModel.docName)
          .where('data', isEqualTo: widget.setionModel.date)
          .limit(1)
          .snapshots()
          .listen((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          var doc = querySnapshot.docs.first;
          SetionModel setionModel =
              SetionModel.jsonData(doc.data() as Map<String, dynamic>);
          if (mounted) {
            setState(() {
              status = setionModel.status;
              print('Fetched status: $status');
            });
          }
        }
      });
    } catch (e) {
      print('Failed to fetch status code: $e');
    }
  }

  void closeSetion() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('setions')
          .where('name', isEqualTo: widget.setionModel.docName)
          .where('data', isEqualTo: widget.setionModel.date)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        await doc.reference.update({'status': 1});
        setState(() {
          status = 1;
          print('Closed session, status updated to: $status');
        });
      }
    } catch (e) {
      print('Failed to update status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubmitAttendVerifyCubit, SubmitAttendVerifyState>(
      listener: (context, state) {
        if (state is SubmitAttendVerifySuccess) {
          fetchAttendensData();
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          double padding = constraints.maxWidth * 0.02;
          return Padding(
            padding: EdgeInsets.all(padding),
            child: Container(
              padding: EdgeInsets.all(padding),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.black),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Setion For Dr/ ${widget.setionModel.docName ?? 'Loading '} in ${widget.setionModel.date ?? ' ... '}',
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'Gilroy-Bold'),
                  ),
                  Text(
                      'Attendens For This Setion [Group ${widget.setionModel.group ?? 'Loading'}] : ${attendens.length}',
                      style: TextStyle(
                          color: Colors.grey, fontFamily: 'Gilroy-Bold')),
                  checkAdmin
                      ? BlocListener<GetAdminForCheckCubit,
                          GetAdminForCheckState>(
                          listener: (context, state) {
                            checkAdmin =
                                BlocProvider.of<GetAdminForCheckCubit>(context)
                                    .checkAdmin;
                          },
                          child: BlocBuilder<GetAdminForCheckCubit,
                              GetAdminForCheckState>(
                            builder: (context, state) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Setion Closed',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Gilroy-Bold'),
                                  ),
                                  SizedBox(width: 20),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return HistoryOfAttendens(
                                            docName:
                                                widget.setionModel.docName!,
                                            date: widget.setionModel.date!,
                                          );
                                        }));
                                      },
                                      icon: Icon(Icons.history,
                                          color: Colors.white))
                                ],
                              );
                            },
                          ),
                        )
                      : BlocListener<GetAdminForCheckCubit,
                          GetAdminForCheckState>(
                          listener: (context, state) {
                            checkAdmin =
                                BlocProvider.of<GetAdminForCheckCubit>(context)
                                    .checkAdmin;
                          },
                          child: BlocBuilder<GetAdminForCheckCubit,
                              GetAdminForCheckState>(
                            builder: (context, state) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Setion Closed',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Gilroy-Bold'),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
