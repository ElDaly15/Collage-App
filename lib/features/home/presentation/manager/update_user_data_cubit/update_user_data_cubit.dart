import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'update_user_data_state.dart';

class UpdateUserDataCubit extends Cubit<UpdateUserDataState> {
  UpdateUserDataCubit() : super(UpdateUserDataInitial());

  update_user_data(
      {required String name,
      required String collage,
      required String group,
      required String grade,
      required String email}) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('UsersData')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        var ref = doc.reference;

        await ref.update(
            {'name': name, 'collage': collage, 'group': group, 'grade': grade});
        emit(UpdateUserDataSuccess());
      }
    } catch (e) {
      emit(UpdateUserDataFailuer());
    }
  }
}
