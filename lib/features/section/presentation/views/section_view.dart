import 'package:baby/features/LoginAndRegister/presentation/views/widgets/header_of_main_page_register_and_login.dart';
import 'package:baby/features/home/presentation/manager/fetch_user_data_cubit/fetch_user_data_cubit.dart';
import 'package:baby/features/section/presentation/manager/get_admin_for_check_cubit/get_admin_for_check_cubit.dart';
import 'package:baby/features/section/presentation/manager/get_setion_data_cubit/get_setion_data_cubit.dart';
import 'package:baby/features/section/presentation/views/widgets/setion_create_conatiner.dart';
import 'package:baby/features/section/presentation/views/widgets/sliver_list_for_setion_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SectionView extends StatefulWidget {
  SectionView({
    super.key,
    required this.docName,
    required this.name,
    required this.subject,
  });

  final String docName;
  final String name;
  final String subject;

  @override
  State<SectionView> createState() => _SectionViewState();
}

class _SectionViewState extends State<SectionView> {
  var inputFormat = DateFormat('dd.MM.yyyy HH:mm:ss');
  String group = 'A';
  int index = 0;
  String? studentGroup;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    final adminCubit = BlocProvider.of<GetAdminForCheckCubit>(context);
    final userDataCubit = BlocProvider.of<FetchUserDataCubit>(context);
    final sectionDataCubit = BlocProvider.of<GetSetionDataCubit>(context);

    isAdmin = adminCubit.checkAdmin;
    studentGroup = userDataCubit.group;

    if (studentGroup == 'A') {
      sectionDataCubit.get_setion_data(
          doctorName: widget.docName, group: 'A', subject: widget.subject);
    } else if (studentGroup == 'B') {
      sectionDataCubit.get_setion_data(
          doctorName: widget.docName, group: 'B', subject: widget.subject);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SafeArea(child: SizedBox())),
          SliverToBoxAdapter(child: Header()),
          SliverListForSetionContainer(
            subject: widget.subject,
            name: widget.name,
            docName: widget.docName,
          ),
          BlocListener<GetAdminForCheckCubit, GetAdminForCheckState>(
            listener: (context, state) {
              setState(() {
                isAdmin =
                    BlocProvider.of<GetAdminForCheckCubit>(context).checkAdmin;
              });
            },
            child: isAdmin ? _buildAdminSection() : SliverToBoxAdapter(),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return _buildModalContent();
              },
            );
          },
          child: Text(
            'Create Setion',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildModalContent() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Setion Group : ',
                  style: TextStyle(fontFamily: 'Gilroy-Bold'),
                ),
                _buildGroupSelectionButtons(setState),
                Center(
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: _createSection,
                    child: Text(
                      'Create',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Gilroy-Bold'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGroupSelectionButtons(StateSetter setState) {
    return Row(
      children: [
        _buildGroupButton(setState, 'A', 0),
        SizedBox(width: 16),
        _buildGroupButton(setState, 'B', 1),
      ],
    );
  }

  Widget _buildGroupButton(
      StateSetter setState, String groupName, int buttonIndex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          index = buttonIndex;
          group = groupName;
        });
      },
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          backgroundColor: index == buttonIndex
              ? Colors.black.withOpacity(0.2)
              : Colors.black,
          minimumSize: Size(20, 40),
        ),
        onPressed: () {
          setState(() {
            index = buttonIndex;
            group = groupName;
          });
        },
        child: Text(
          groupName,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _createSection() {
    try {
      FirebaseFirestore.instance.collection('setions').add({
        'name': widget.docName,
        'data': inputFormat.format(DateTime.now()),
        'status': 0,
        'realTime': DateTime.now(),
        'Subject': widget.subject,
        'Group': group,
      });

      FirebaseFirestore.instance.collection(
          '${widget.docName} in ${inputFormat.format(DateTime.now())}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Setion Created Successfully',
            style: TextStyle(fontFamily: 'Gilroy'),
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'An Error Occurred',
            style: TextStyle(fontFamily: 'Gilroy'),
          ),
        ),
      );
    }
  }
}
