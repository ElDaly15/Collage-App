import 'package:baby/core/models/data_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContainerOfRequest extends StatelessWidget {
  const ContainerOfRequest({super.key, required this.dataUserModel});

  final DataUserModel dataUserModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: 200,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(
                        dataUserModel.image,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      width: constraints.maxWidth * 0.5,
                      child: Text(
                        dataUserModel.name,
                        style: TextStyle(
                            fontFamily: 'Gilroy-Bold',
                            fontSize: 18,
                            color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.email,
                    color: Colors.red,
                  ),
                  title: Text(
                    dataUserModel.email,
                    style: TextStyle(
                        fontFamily: 'Gilroy-Bold',
                        fontSize: 16,
                        color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.grade,
                    color: Colors.red,
                  ),
                  title: Text(
                    dataUserModel.grade,
                    style: TextStyle(
                        fontFamily: 'Gilroy-Bold',
                        fontSize: 16,
                        color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.group,
                    color: Colors.red,
                  ),
                  title: Text(
                    dataUserModel.group,
                    style: TextStyle(
                        fontFamily: 'Gilroy-Bold',
                        fontSize: 16,
                        color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.school,
                    color: Colors.red,
                  ),
                  title: Text(
                    dataUserModel.collage,
                    style: TextStyle(
                        fontFamily: 'Gilroy-Bold',
                        fontSize: 16,
                        color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async {
                        QuerySnapshot querySnapshot = await FirebaseFirestore
                            .instance
                            .collection('UsersData')
                            .where('email', isEqualTo: dataUserModel.email)
                            .limit(1)
                            .get();

                        DocumentSnapshot documentSnapshot =
                            querySnapshot.docs.first;
                        DocumentReference docRef = documentSnapshot.reference;

                        await docRef
                            .update({
                              'status': 1,
                            })
                            .then((_) => print('Done'))
                            .catchError((error) => print('Not Done'));
                      },
                      child: Text(
                        'Approve',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Gilroy-Bold'),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        QuerySnapshot querySnapshot = await FirebaseFirestore
                            .instance
                            .collection('UsersData')
                            .where('email', isEqualTo: dataUserModel.email)
                            .limit(1)
                            .get();

                        DocumentSnapshot documentSnapshot =
                            querySnapshot.docs.first;
                        DocumentReference docRef = documentSnapshot.reference;

                        await docRef
                            .update({
                              'status': -1,
                            })
                            .then((_) => print('Done'))
                            .catchError((error) => print('Not Done'));

                        await docRef.delete();
                      },
                      child: Text(
                        'Reject',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Gilroy-Bold'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
