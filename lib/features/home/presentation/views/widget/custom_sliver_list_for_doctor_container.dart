import 'dart:async';

import 'package:baby/core/models/doctor_model.dart';
import 'package:baby/features/home/presentation/manager/fetch_user_data_cubit/fetch_user_data_cubit.dart';
import 'package:baby/features/home/presentation/manager/get_doctor_data_cubit/get_doctor_data_cubit.dart';
import 'package:baby/features/home/presentation/views/widget/doctor_detailes_container.dart';
import 'package:baby/features/section/presentation/manager/get_admin_for_check_cubit/get_admin_for_check_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSliverListForDoctorContainer extends StatefulWidget {
  const CustomSliverListForDoctorContainer({super.key, required this.name});
  final String name;

  @override
  State<CustomSliverListForDoctorContainer> createState() =>
      _CustomSliverListForDoctorContainerState();
}

class _CustomSliverListForDoctorContainerState
    extends State<CustomSliverListForDoctorContainer> {
  StreamSubscription? gradeSubscription;

  @override
  void initState() {
    super.initState();
    // Fetch initial user data
    BlocProvider.of<FetchUserDataCubit>(context)
        .fetch_user_data(email: widget.name);

    // Check if the user is an admin
    BlocProvider.of<GetAdminForCheckCubit>(context)
        .get_admin(email: widget.name);

    gradeSubscription =
        BlocProvider.of<FetchUserDataCubit>(context).stream.listen((state) {
      if (state is FetchUserDataSuccess) {
        final grade = BlocProvider.of<FetchUserDataCubit>(context).grade;
        final name = BlocProvider.of<FetchUserDataCubit>(context).name;
        final checkAdmin =
            BlocProvider.of<GetAdminForCheckCubit>(context).checkAdmin;
        if (checkAdmin) {
          BlocProvider.of<GetDoctorDataCubit>(context)
              .get_doctor_data_by_name(name: name);
        } else {
          BlocProvider.of<GetDoctorDataCubit>(context)
              .get_doctor_data(grade: grade);
        }
      }
    });
  }

  @override
  void dispose() {
    gradeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetAdminForCheckCubit, GetAdminForCheckState>(
      listener: (context, state) {
        if (state is GetAdminForCheckSuccess ||
            state is GetAdminForCheckFailuer) {
          BlocProvider.of<FetchUserDataCubit>(context)
              .fetch_user_data(email: widget.name);
        }
      },
      child: BlocBuilder<GetDoctorDataCubit, GetDoctorDataState>(
        builder: (context, state) {
          if (state is GetDoctorDataSuccess) {
            List<DoctorModel> docData =
                BlocProvider.of<GetDoctorDataCubit>(context).docData;
            print(docData.length);

            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return DoctorDetailsContainer(
                  name: widget.name,
                  doctorModel: docData[index],
                );
              }, childCount: docData.length),
            );
          } else if (state is GetDoctorDataLoading) {
            return const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()));
          } else {
            return const SliverToBoxAdapter(
                child: Center(child: Text('Error Occurred')));
          }
        },
      ),
    );
  }
}
