import 'package:baby/core/models/setion_modal.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'get_setion_data_state.dart';

class GetSetionDataCubit extends Cubit<GetSetionDataState> {
  GetSetionDataCubit() : super(GetSetionDataInitial());

  List<SetionModel> setionData = [];

  get_setion_data(
      {required String doctorName,
      required String group,
      required String subject}) {
    try {
      emit(GetSetionDataLoading());
      FirebaseFirestore.instance
          .collection('setions')
          .where('name', isEqualTo: doctorName)
          .where('Group', isEqualTo: group)
          .where('Subject', isEqualTo: subject)
          .orderBy('realTime', descending: true)
          .snapshots()
          .listen((querySnapshot) {
        setionData = querySnapshot.docs
            .map((doc) => SetionModel.jsonData(doc.data()))
            .toList();

        emit(GetSetionDataSuccess());
      });
    } catch (e) {
      emit(GetSetionDataFailuer());
    }
  }

  get_all_data({required String doctorName, required String subject}) {
    try {
      emit(GetSetionDataLoading());
      FirebaseFirestore.instance
          .collection('setions')
          .where('name', isEqualTo: doctorName)
          .where('Subject', isEqualTo: subject)
          .orderBy('realTime', descending: true)
          .snapshots()
          .listen((querySnapshot) {
        setionData = querySnapshot.docs
            .map((doc) => SetionModel.jsonData(doc.data()))
            .toList();

        emit(GetSetionDataSuccess());
      });
    } catch (e) {
      emit(GetSetionDataFailuer());
    }
  }
}
