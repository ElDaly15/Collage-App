import 'dart:async';
import 'dart:io';

import 'package:baby/core/models/attendes_modal.dart';
import 'package:baby/core/models/data_user_model.dart';
import 'package:baby/core/models/setion_modal.dart';
import 'package:baby/features/section/presentation/manager/get_admin_for_check_cubit/get_admin_for_check_cubit.dart';
import 'package:baby/features/section/presentation/manager/submit_attend_cubit/submit_attend_verify_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart' as Path;

class SetionCreateContainer extends StatefulWidget {
  SetionCreateContainer(
      {super.key, required this.setionModel, required this.name});

  final SetionModel setionModel;
  final String name;

  @override
  State<SetionCreateContainer> createState() => _SetionCreateContainerState();
}

class _SetionCreateContainerState extends State<SetionCreateContainer> {
  final DateFormat inputFormat = DateFormat('dd.MM.yyyy HH:mm:ss');
  String? name;
  String? image;
  File? file;
  String? url;
  String? group;
  int? status;
  List<AttendesModal> attendens = [];
  bool checkBar = false;
  bool checkAdmin = false;
  bool checkAttend = false;
  bool checkerPhoto = false;

  StreamSubscription<QuerySnapshot>? attendensSubscription;
  StreamSubscription<QuerySnapshot>? attendensSubscriptionUser;
  StreamSubscription<QuerySnapshot>? statusSubscription;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchAttendensData();
    fetchStatusCode();
    fetchAttendensDataUser();
    checkAdmin = BlocProvider.of<GetAdminForCheckCubit>(context).checkAdmin;
  }

  @override
  void dispose() {
    attendensSubscription?.cancel();
    statusSubscription?.cancel();
    attendensSubscriptionUser?.cancel();
    super.dispose();
  }

  Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageCamera =
        await picker.pickImage(source: ImageSource.camera);

    if (imageCamera != null) {
      file = File(imageCamera.path);
      var imageName = Path.basename(imageCamera.path);
      var refStorage = FirebaseStorage.instance.ref(imageName);
      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();
      setState(() {});
    }
  }

  Future<void> fetchUserData() async {
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
            image = user.image;
            group = user.group;
          });
        }
      }
    } catch (e) {
      print('Failed to fetch user data: $e');
    }
  }

  void fetchAttendensData() {
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

  void fetchAttendensDataUser() {
    try {
      attendensSubscriptionUser = FirebaseFirestore.instance
          .collection(
              '${widget.setionModel.docName} in ${widget.setionModel.date}')
          .where('name', isEqualTo: name)
          .limit(1)
          .snapshots()
          .listen((querySnapshot) {
        if (mounted) {
          setState(() {
            checkAttend = querySnapshot.docs.isNotEmpty;
          });
        }
      });
    } catch (e) {
      print('Failed to fetch user attendance data: $e');
    }
  }

  void fetchStatusCode() {
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

  Future<void> closeSetion() async {
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
          if (!checkBar) {
            checkBar = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.black,
                behavior: SnackBarBehavior.floating,
                content: Text(
                  'You Verified Your Attendens Success',
                  style: TextStyle(fontFamily: 'Gilroy'),
                ),
              ),
            );
            checkBar = false;
          }
        } else if (state is SubmitAttendVerifyFailuer) {
          if (!checkBar) {
            checkBar = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.black,
                behavior: SnackBarBehavior.floating,
                content: Text(
                  'You Already Submitted!',
                  style: TextStyle(fontFamily: 'Gilroy'),
                ),
              ),
            );
            checkBar = false;
          }
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
                borderRadius: BorderRadius.circular(8),
                color: Colors.black,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Setion For Dr/ ${widget.setionModel.docName ?? 'Loading '} in ${widget.setionModel.date ?? ' ... '}',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Gilroy-Bold',
                    ),
                  ),
                  Text(
                    'Attendens Now [Group ${widget.setionModel.group ?? 'Loading'}]: ${attendens.length}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Gilroy-Bold',
                    ),
                  ),
                  BlocListener<GetAdminForCheckCubit, GetAdminForCheckState>(
                    listener: (context, state) {
                      setState(() {
                        checkAdmin =
                            BlocProvider.of<GetAdminForCheckCubit>(context)
                                .checkAdmin;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        !checkAdmin
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  minimumSize: Size(20, 10),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    checkerPhoto = true;
                                  });
                                  url = null;
                                  if (url == null && !checkAttend) {
                                    await getImage();
                                  }

                                  if (url != null && !checkAttend) {
                                    BlocProvider.of<SubmitAttendVerifyCubit>(
                                            context)
                                        .get_attend_verify(
                                      atttendImage: url!,
                                      name: name!,
                                      doctorName: widget.setionModel.docName!,
                                      date: widget.setionModel.date,
                                      image: image,
                                      group: group,
                                    );
                                    setState(() {
                                      checkerPhoto = false;
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.black,
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(
                                          'You Already Submitted!',
                                          style:
                                              TextStyle(fontFamily: 'Gilroy'),
                                        ),
                                      ),
                                    );
                                    setState(() {
                                      checkerPhoto = false;
                                    });
                                  }
                                },
                                child: checkerPhoto
                                    ? SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.0,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        'Attend Verify',
                                        style: TextStyle(color: Colors.white),
                                      ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  minimumSize: Size(20, 10),
                                ),
                                onPressed: closeSetion,
                                child: Text(
                                  'Close Setion',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
