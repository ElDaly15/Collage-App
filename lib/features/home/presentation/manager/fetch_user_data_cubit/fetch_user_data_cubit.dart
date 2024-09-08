import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'fetch_user_data_state.dart';

class FetchUserDataCubit extends Cubit<FetchUserDataState> {
  FetchUserDataCubit() : super(FetchUserDataInitial());

  String? name;
  String? grade;
  String? group;

  fetch_user_data({required String email}) {
    FirebaseFirestore.instance
        .collection('UsersData')
        .where('email', isEqualTo: email)
        .limit(1)
        .snapshots()
        .listen((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;

        grade = doc.get('grade');
        name = doc.get('name');
        group = doc.get('group');
      }
      emit(FetchUserDataSuccess());
    });
  }
}
