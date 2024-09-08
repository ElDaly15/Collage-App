import 'dart:ffi';

import 'package:baby/core/models/setion_modal.dart';
import 'package:baby/features/home/presentation/manager/fetch_user_data_cubit/fetch_user_data_cubit.dart';
import 'package:baby/features/section/presentation/manager/get_admin_for_check_cubit/get_admin_for_check_cubit.dart';
import 'package:baby/features/section/presentation/manager/get_setion_data_cubit/get_setion_data_cubit.dart';
import 'package:baby/features/section/presentation/views/widgets/closed_setion.dart';
import 'package:baby/features/section/presentation/views/widgets/setion_create_conatiner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SliverListForSetionContainer extends StatefulWidget {
  const SliverListForSetionContainer(
      {super.key,
      required this.docName,
      required this.name,
      required this.subject});
  final String docName;
  final String name;
  final String subject;

  @override
  State<SliverListForSetionContainer> createState() =>
      _SliverListForSetionContainerState();
}

class _SliverListForSetionContainerState
    extends State<SliverListForSetionContainer> {
  String? studentGroup;
  bool? isAdmin;

  @override
  void initState() {
    super.initState();
    isAdmin = BlocProvider.of<GetAdminForCheckCubit>(context).checkAdmin;

    _fetchSetionData();
  }

  void _fetchSetionData() {
    if (isAdmin!) {
      BlocProvider.of<GetSetionDataCubit>(context)
          .get_all_data(doctorName: widget.docName, subject: widget.subject);
    } else {
      studentGroup = BlocProvider.of<FetchUserDataCubit>(context).group;
      if (studentGroup == 'A') {
        BlocProvider.of<GetSetionDataCubit>(context).get_setion_data(
            doctorName: widget.docName, group: 'A', subject: widget.subject);
      } else if (studentGroup == 'B') {
        BlocProvider.of<GetSetionDataCubit>(context).get_setion_data(
            doctorName: widget.docName, group: 'B', subject: widget.subject);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetAdminForCheckCubit, GetAdminForCheckState>(
      listener: (context, state) {
        if (state is GetAdminForCheckSuccess ||
            state is GetAdminForCheckFailuer) {
          isAdmin = BlocProvider.of<GetAdminForCheckCubit>(context).checkAdmin;
          _fetchSetionData();
        }
      },
      child: BlocBuilder<GetSetionDataCubit, GetSetionDataState>(
        builder: (context, state) {
          if (state is GetSetionDataSuccess) {
            List<SetionModel> setionData =
                BlocProvider.of<GetSetionDataCubit>(context).setionData;
            if (setionData.isEmpty) {
              return const SliverToBoxAdapter(
                child: Center(child: Text('No Setions Now ....')),
              );
            } else {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (setionData[index].status == 0) {
                      return SetionCreateContainer(
                        name: widget.name,
                        setionModel: setionData[index],
                      );
                    } else {
                      return ClosedSetion(
                        setionModel: setionData[index],
                        name: widget.name,
                      );
                    }
                  },
                  childCount: setionData.length,
                ),
              );
            }
          } else if (state is GetSetionDataLoading) {
            return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            return const SliverToBoxAdapter(
              child: Center(child: Text('An Error Occurred')),
            );
          }
        },
      ),
    );
  }
}
