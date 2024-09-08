import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'submit_attend_verify_state.dart';

class SubmitAttendVerifyCubit extends Cubit<SubmitAttendVerifyState> {
  SubmitAttendVerifyCubit() : super(SubmitAttendVerifyInitial());

  get_attend_verify(
      {required String name,
      required String doctorName,
      required date,
      required image,
      required group,
      required atttendImage}) async {
    try {
      emit(SubmitAttendVerifyLoading());
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('${doctorName} in ${date}')
          .where('name', isEqualTo: name)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        FirebaseFirestore.instance.collection('${doctorName} in ${date}').add({
          'name': name,
          'image': image,
          'group': group,
          'attendImage': atttendImage
        });
        emit(SubmitAttendVerifySuccess());
      } else {
        emit(SubmitAttendVerifyFailuer());
      }
    } on Exception catch (e) {
      emit(SubmitAttendVerifyFailuer());
    }
  }
}
