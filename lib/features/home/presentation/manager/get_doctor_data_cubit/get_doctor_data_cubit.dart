import 'package:baby/core/models/doctor_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'get_doctor_data_state.dart';

class GetDoctorDataCubit extends Cubit<GetDoctorDataState> {
  GetDoctorDataCubit() : super(GetDoctorDataInitial());
  List<DoctorModel> docData = [];

  get_doctor_data({required grade}) {
    try {
      emit(GetDoctorDataLoading());
      FirebaseFirestore.instance
          .collection('Doctors')
          .where('Grade', isEqualTo: grade)
          .snapshots()
          .listen((querySnapshot) {
        docData = querySnapshot.docs
            .map((doc) => DoctorModel.jsonData(doc.data()))
            .toList();

        emit(GetDoctorDataSuccess());
      });
    } catch (e) {
      emit(GetDoctorDataFailuer());
    }
  }

  get_doctor_data_by_name({required name}) {
    try {
      emit(GetDoctorDataLoading());
      FirebaseFirestore.instance
          .collection('Doctors')
          .where('doctorName', isEqualTo: name)
          .snapshots()
          .listen((querySnapshot) {
        docData = querySnapshot.docs
            .map((doc) => DoctorModel.jsonData(doc.data()))
            .toList();

        emit(GetDoctorDataSuccess());
      });
    } catch (e) {
      emit(GetDoctorDataFailuer());
    }
  }
}
