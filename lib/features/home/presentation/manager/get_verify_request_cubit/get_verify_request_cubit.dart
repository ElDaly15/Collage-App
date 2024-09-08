import 'package:baby/core/models/data_user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'get_verify_request_state.dart';

class GetVerifyRequestCubit extends Cubit<GetVerifyRequestState> {
  GetVerifyRequestCubit() : super(GetVerifyRequestInitial());

  List<DataUserModel> dataUserModelList = [];

  void getOrders() {
    try {
      emit(GetVerifyRequestLoading());

      FirebaseFirestore.instance
          .collection('UsersData')
          .where('status', isEqualTo: 0)
          .snapshots()
          .listen((querySnapshot) {
        dataUserModelList = querySnapshot.docs
            .map((doc) =>
                DataUserModel.jsonData(doc.data() as Map<String, dynamic>))
            .toList();
        emit(GetVerifyRequestSuccess());
      }, onError: (error) {
        emit(GetVerifyRequestFailuer());
      });
    } catch (e) {
      emit(GetVerifyRequestFailuer());
    }
  }
}
