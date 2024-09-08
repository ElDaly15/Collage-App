import 'package:baby/core/models/attendes_modal.dart';
import 'package:baby/features/section/presentation/manager/get_admin_for_check_cubit/get_admin_for_check_cubit.dart';
import 'package:baby/features/section/presentation/manager/remove_history_of_student_attendens_cubit/delete_history_of_student_attendens_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryContainer extends StatefulWidget {
  const HistoryContainer(
      {super.key,
      required this.attendesModal,
      required this.docNAme,
      required this.Date});
  final AttendesModal attendesModal;
  final String docNAme, Date;

  @override
  State<HistoryContainer> createState() => _HistoryContainerState();
}

class _HistoryContainerState extends State<HistoryContainer> {
  bool isAdmin = false;

  @override
  void initState() {
    isAdmin = BlocProvider.of<GetAdminForCheckCubit>(context).checkAdmin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: EdgeInsets.all(12),
        height: 340,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(widget.attendesModal.image ??
                      'https://i.pinimg.com/564x/6c/cc/73/6ccc7364fddee013ccc20f659dc0b7be.jpg'),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  children: [
                    Text(
                      widget.attendesModal.name ?? 'Loading ...',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Gilroy-Bold',
                          fontSize: 16),
                    ),
                    Text(
                      'Group :${widget.attendesModal.group ?? 'Loading ... '}',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Gilroy-Bold',
                          fontSize: 16),
                    ),
                  ],
                ),
                Spacer(
                  flex: 1,
                ),
                BlocListener<GetAdminForCheckCubit, GetAdminForCheckState>(
                  listener: (context, state) {
                    setState(() {
                      isAdmin = BlocProvider.of<GetAdminForCheckCubit>(context)
                          .checkAdmin;
                    });
                  },
                  child: isAdmin
                      ? BlocListener<DeleteHistoryOfStudentAttendensCubit,
                          DeleteHistoryOfStudentAttendensState>(
                          listener: (context, state) {
                            if (state
                                is DeleteHistoryOfStudentAttendensSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.black,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    'Delete Done',
                                    style: TextStyle(fontFamily: 'Gilroy'),
                                  ),
                                ),
                              );
                            } else if (state
                                is DeleteHistoryOfStudentAttendensFailuer) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.black,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    'Error While Delete This Student',
                                    style: TextStyle(fontFamily: 'Gilroy'),
                                  ),
                                ),
                              );
                            }
                          },
                          child: IconButton(
                              onPressed: () {
                                BlocProvider.of<
                                            DeleteHistoryOfStudentAttendensCubit>(
                                        context)
                                    .delete_Student_history(
                                        Name: widget.attendesModal.name!,
                                        docName: widget.docNAme,
                                        date: widget.Date);
                                print('done');
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        )
                      : Text(
                          '+0.5',
                          style: TextStyle(
                              color: Colors.green,
                              fontFamily: 'Gilroy-Bold',
                              fontSize: 18),
                        ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 1,
                    height: 1.5,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text("Live Photo"),
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    height: 1.5,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: CachedNetworkImage(
                height: 210,
                width: 200,
                imageUrl: widget.attendesModal.attendUrl!,
                placeholder: (context, url) => SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
