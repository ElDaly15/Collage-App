import 'package:baby/core/models/attendes_modal.dart';
import 'package:baby/features/LoginAndRegister/presentation/views/widgets/header_of_main_page_register_and_login.dart';
import 'package:baby/features/section/presentation/manager/get_attendens_history_cubit/get_attendens_history_data_cubit.dart';
import 'package:baby/features/section/presentation/views/widgets/attendens_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryOfAttendens extends StatefulWidget {
  const HistoryOfAttendens(
      {super.key, required this.docName, required this.date});
  final String docName;
  final String date;

  @override
  State<HistoryOfAttendens> createState() => _HistoryOfAttendensState();
}

class _HistoryOfAttendensState extends State<HistoryOfAttendens> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetAttendensHistoryDataCubit>(context)
        .get_attendens_data(docName: widget.docName, Date: widget.date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SafeArea(child: SizedBox())),
          SliverToBoxAdapter(child: Header()),
          BlocBuilder<GetAttendensHistoryDataCubit,
              GetAttendensHistoryDataState>(
            builder: (context, state) {
              if (state is GetAttendensHistoryDataSucceess) {
                List<AttendesModal> attendesData =
                    BlocProvider.of<GetAttendensHistoryDataCubit>(context)
                        .attendesData;
                if (attendesData.isNotEmpty) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return HistoryContainer(
                          docNAme: widget.docName,
                          Date: widget.date,
                          attendesModal: attendesData[index],
                        );
                      },
                      childCount: attendesData.length,
                    ),
                  );
                } else {
                  return SliverToBoxAdapter(
                    child: Center(child: Text('No Attendens')),
                  );
                }
              } else if (state is GetAttendensHistoryDataLoading) {
                return SliverToBoxAdapter(
                  child: CircularProgressIndicator(),
                );
              } else {
                return SliverToBoxAdapter(
                  child: Text('An Error Occured'),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
