import 'package:baby/features/LoginAndRegister/presentation/manager/submit_data_user_cubit/submit_data_user_cubit.dart';
import 'package:baby/features/LoginAndRegister/presentation/views/startApp.dart';
import 'package:baby/features/home/presentation/manager/fetch_user_data_cubit/fetch_user_data_cubit.dart';
import 'package:baby/features/home/presentation/manager/get_doctor_data_cubit/get_doctor_data_cubit.dart';
import 'package:baby/features/home/presentation/manager/get_verify_request_cubit/get_verify_request_cubit.dart';
import 'package:baby/features/home/presentation/manager/update_user_data_cubit/update_user_data_cubit.dart';
import 'package:baby/features/home/presentation/views/home_view.dart';
import 'package:baby/features/section/presentation/manager/get_admin_for_check_cubit/get_admin_for_check_cubit.dart';
import 'package:baby/features/section/presentation/manager/get_attendens_history_cubit/get_attendens_history_data_cubit.dart';
import 'package:baby/features/section/presentation/manager/get_setion_data_cubit/get_setion_data_cubit.dart';
import 'package:baby/features/section/presentation/manager/get_status_of_container/get_status_of_container_cubit.dart';
import 'package:baby/features/section/presentation/manager/remove_history_of_student_attendens_cubit/delete_history_of_student_attendens_cubit.dart';
import 'package:baby/features/section/presentation/manager/submit_attend_cubit/submit_attend_verify_cubit.dart';
import 'package:baby/firebase_options.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "baby",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(DevicePreview(enabled: false, builder: (context) => BabyApp()));
}

class BabyApp extends StatelessWidget {
  const BabyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SubmitDataUserCubit(),
        ),
        BlocProvider(
          create: (context) => GetVerifyRequestCubit(),
        ),
        BlocProvider(
          create: (context) => UpdateUserDataCubit(),
        ),
        BlocProvider(
          create: (context) => GetDoctorDataCubit(),
        ),
        BlocProvider(
          create: (context) => GetSetionDataCubit(),
        ),
        BlocProvider(
          create: (context) => SubmitAttendVerifyCubit(),
        ),
        BlocProvider(
          create: (context) => GetStatusOfContainerCubit(),
        ),
        BlocProvider(
          create: (context) => GetAttendensHistoryDataCubit(),
        ),
        BlocProvider(
          create: (context) => GetAdminForCheckCubit(),
        ),
        BlocProvider(
          create: (context) => FetchUserDataCubit(),
        ),
        BlocProvider(
          create: (context) => DeleteHistoryOfStudentAttendensCubit(),
        )
      ],
      child: MaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData(fontFamily: 'Gilroy'),
        debugShowCheckedModeBanner: false,
        home: Startapp(),
      ),
    );
  }
}
