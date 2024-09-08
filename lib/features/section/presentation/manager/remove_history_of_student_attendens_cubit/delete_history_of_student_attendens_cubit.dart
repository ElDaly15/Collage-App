import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'delete_history_of_student_attendens_state.dart';

class DeleteHistoryOfStudentAttendensCubit
    extends Cubit<DeleteHistoryOfStudentAttendensState> {
  DeleteHistoryOfStudentAttendensCubit()
      : super(DeleteHistoryOfStudentAttendensInitial());

  delete_Student_history(
      {required String Name, required String docName, required String date}) {
    try {
      emit(DeleteHistoryOfStudentAttendensLoading());
      FirebaseFirestore.instance
          .collection('${docName} in ${date}')
          .where('name', isEqualTo: Name)
          .limit(1)
          .snapshots()
          .listen(
        (data) {
          if (data.docs.isNotEmpty) {
            var doc = data.docs.first;
            var ref = doc.reference;
            ref.delete();
          }
          emit(DeleteHistoryOfStudentAttendensSuccess());
        },
      );
    } catch (e) {
      emit(DeleteHistoryOfStudentAttendensFailuer());
    }
  }
}
