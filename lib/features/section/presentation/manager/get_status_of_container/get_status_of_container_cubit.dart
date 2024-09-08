import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'get_status_of_container_state.dart';

class GetStatusOfContainerCubit extends Cubit<GetStatusOfContainerState> {
  GetStatusOfContainerCubit() : super(GetStatusOfContainerInitial());
  int? status;
  changeAndGetStatus({required name, required data}) async {
    try {
      await FirebaseFirestore.instance // Get Data You Want To Update First
          .collection('setions')
          .where('name', isEqualTo: name)
          .where('data', isEqualTo: data)
          .limit(1)
          .snapshots()
          .listen((data) {
        if (data.docs.isNotEmpty) {
          var doc = data.docs.first;
          status = doc.get('status');
        }

        if (status == 1) {
          emit(GetStatusOfContainerSuccess());
        } else {
          emit(GetStatusOfContainerFailuer());
        }
      });
    } catch (e) {
      emit(GetStatusOfContainerFailuer());
    }
  }
}
