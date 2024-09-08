import 'package:baby/features/home/presentation/views/widget/custom_drawer.dart';
import 'package:baby/features/home/presentation/views/widget/custom_sliver_list_for_doctor_container.dart';
import 'package:baby/features/home/presentation/views/widget/doctor_detailes_container.dart';
import 'package:baby/features/home/presentation/views/widget/verify_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VerifyDoneWidget extends StatelessWidget {
  VerifyDoneWidget({super.key, required this.email});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: CustomDrawer(
        email: email,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SafeArea(child: SizedBox())),
          SliverToBoxAdapter(
            child: VerifyDoneHeader(
              globalKey: scaffoldKey,
            ),
          ),
          CustomSliverListForDoctorContainer(
            name: email,
          ),
        ],
      ),
    );
  }
}
