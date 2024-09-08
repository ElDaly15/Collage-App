import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'submit_data_user_state.dart';

class SubmitDataUserCubit extends Cubit<SubmitDataUserState> {
  SubmitDataUserCubit() : super(SubmitDataUserInitial());
  CollectionReference usersData =
      FirebaseFirestore.instance.collection('UsersData');

  SubmitData({
    required String email,
    required String name,
    required String age,
    required String collage,
    String? grade,
    String? group,
    String? image,
    required int status,
  }) async {
    try {
      emit(SubmitDataUserLoading());

      Map<String, dynamic> data = {
        'email': email,
        'name': name,
        'age': age,
        'collage': collage,
        'status': status
      };

      if (grade != null && grade.isNotEmpty) {
        data['grade'] = grade;
      }
      if (group != null && group.isNotEmpty) {
        data['group'] = group;
      }
      if (image != null && image.isNotEmpty) {
        data['image'] = image;
      }

      await usersData.add(data);
      emit(SubmitDataUserSuccess());
    } catch (e) {
      emit(SubmitDataUserFailuer(error: 'Oops An Error Occuerd'));
    }
  }
}
