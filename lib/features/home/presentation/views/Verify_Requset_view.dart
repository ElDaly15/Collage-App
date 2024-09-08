import 'package:baby/core/models/data_user_model.dart';
import 'package:baby/core/widget/custom_header.dart';
import 'package:baby/features/home/presentation/manager/get_verify_request_cubit/get_verify_request_cubit.dart';
import 'package:baby/features/home/presentation/views/widget/conatiner_of_req.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyRequsetView extends StatefulWidget {
  const VerifyRequsetView({super.key});

  @override
  State<VerifyRequsetView> createState() => _VerifyRequsetViewState();
}

class _VerifyRequsetViewState extends State<VerifyRequsetView> {
  void initState() {
    super.initState();
    BlocProvider.of<GetVerifyRequestCubit>(context).getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<GetVerifyRequestCubit, GetVerifyRequestState>(
      builder: (context, state) {
        if (state is GetVerifyRequestSuccess) {
          List<DataUserModel> dataUser =
              BlocProvider.of<GetVerifyRequestCubit>(context).dataUserModelList;
          if (dataUser.isEmpty) {
            return Column(
              children: [
                SafeArea(
                  child: SizedBox(),
                ),
                CustomHeader(),
                Text(
                  'No Request Avilable Now ...',
                  style: TextStyle(fontFamily: 'Gilroy-Bold'),
                )
              ],
            );
          } else {
            return Column(
              children: [
                SafeArea(
                  child: SizedBox(),
                ),
                CustomHeader(),
                Expanded(
                  child: ListView.builder(
                      itemCount: dataUser.length,
                      itemBuilder: (context, index) {
                        return ContainerOfRequest(
                            dataUserModel: dataUser[index]);
                      }),
                )
              ],
            );
          }
        } else if (state is GetVerifyRequestLoading) {
          return CircularProgressIndicator();
        } else {
          return Column(
            children: [
              SafeArea(
                child: SizedBox(),
              ),
              CustomHeader(),
              Text(
                'An Error Occured ...',
                style: TextStyle(fontFamily: 'Gilroy-Bold'),
              )
            ],
          );
        }
      },
    ));
  }
}
