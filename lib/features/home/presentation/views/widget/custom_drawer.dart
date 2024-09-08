import 'package:baby/features/LoginAndRegister/presentation/views/login_view.dart';
import 'package:baby/features/home/presentation/views/Verify_Requset_view.dart';
import 'package:baby/features/home/presentation/views/edit_profile.dart';
import 'package:baby/features/home/presentation/views/profile_view.dart';
import 'package:baby/features/home/presentation/views/widget/custom_container_for_drawer.dart';
import 'package:baby/features/section/presentation/manager/get_admin_for_check_cubit/get_admin_for_check_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key, required this.email});
  final String email;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool checkAdmin = false;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetAdminForCheckCubit>(context)
        .get_admin(email: widget.email);
    checkAdmin = BlocProvider.of<GetAdminForCheckCubit>(context).checkAdmin;
    print(checkAdmin);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          CustomContainerForDrawer(email: widget.email),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(' My Profile '),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ProfileView(
                  email: widget.email,
                );
              }));
            },
          ),
          checkAdmin == true
              ? ListTile(
                  leading: const Icon(Icons.book),
                  title: const Text(' Verify Requests '),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return VerifyRequsetView();
                    }));
                  },
                )
              : ListTile(
                  leading: const Icon(Icons.book),
                  title: const Text('Contact Info'),
                  onTap: () {},
                ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text(' Edit Profile '),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return EditProfile(
                  email: widget.email,
                );
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return LoginView();
              }));
            },
          ),
        ],
      ),
    );
  }
}
