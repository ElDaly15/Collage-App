import 'package:baby/core/models/attendes_modal.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'get_attendens_history_data_state.dart';

class GetAttendensHistoryDataCubit extends Cubit<GetAttendensHistoryDataState> {
  GetAttendensHistoryDataCubit() : super(GetAttendensHistoryDataInitial());
  List<AttendesModal> attendesData = [];

  get_attendens_data({required docName, required Date}) {
    try {
      emit(GetAttendensHistoryDataLoading());
      FirebaseFirestore.instance
          .collection('${docName} in ${Date}')
          .snapshots()
          .listen((querySnapshot) {
        attendesData = querySnapshot.docs
            .map((doc) =>
                AttendesModal.jsonData(doc.data() as Map<String, dynamic>))
            .toList();
        emit(GetAttendensHistoryDataSucceess());
      });
    } catch (e) {
      emit(GetAttendensHistoryDataFailuer());
    }
  }
}
