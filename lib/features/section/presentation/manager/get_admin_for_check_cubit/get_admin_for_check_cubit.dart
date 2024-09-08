import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'get_admin_for_check_state.dart';

class GetAdminForCheckCubit extends Cubit<GetAdminForCheckState> {
  GetAdminForCheckCubit() : super(GetAdminForCheckInitial());

  bool checkAdmin = false;

  get_admin({required email}) {
    FirebaseFirestore.instance
        .collection('admins')
        .where('admin', isEqualTo: email)
        .limit(1)
        .snapshots()
        .listen((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        checkAdmin = true;
        emit(GetAdminForCheckSuccess());
      } else {
        checkAdmin = false;

        emit(GetAdminForCheckFailuer());
      }
    });
  }
}
