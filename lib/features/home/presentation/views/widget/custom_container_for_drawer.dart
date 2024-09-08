import 'package:baby/core/models/data_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class CustomContainerForDrawer extends StatefulWidget {
  CustomContainerForDrawer({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<CustomContainerForDrawer> createState() =>
      _CustomContainerForDrawerState();
}

class _CustomContainerForDrawerState extends State<CustomContainerForDrawer> {
  String? name;
  String? imageUrl;

  List<DataUserModel> dataUser = [];

  @override
  void initState() {
    super.initState();

    fetchUserData();
  }

  void fetchUserData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('UsersData')
          .where('email', isEqualTo: widget.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        DataUserModel user = DataUserModel.jsonData(documentSnapshot.data()!);
        setState(() {
          name = user.name;
          imageUrl = user.image;
        });
      } else {
        print("No document found for the provided query.");
      }
    } catch (e) {
      print("Failed to fetch user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black),
      width: double.infinity,
      child: DrawerHeader(
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: imageUrl != null
                  ? NetworkImage(imageUrl!)
                  : NetworkImage(
                      'https://i.pinimg.com/564x/6c/cc/73/6ccc7364fddee013ccc20f659dc0b7be.jpg',
                    ), // Provide a placeholder image if imageUrl is null
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              name ?? 'Loading...', // Show 'Loading...' until name is fetched
              style: TextStyle(color: Colors.white),
            ),
            Text(
              widget.email,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
