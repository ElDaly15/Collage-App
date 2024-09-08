import 'package:baby/core/models/doctor_model.dart';
import 'package:baby/features/section/presentation/views/section_view.dart';
import 'package:flutter/material.dart';

class DoctorDetailsContainer extends StatelessWidget {
  const DoctorDetailsContainer(
      {super.key, required this.doctorModel, required this.name});

  final DoctorModel doctorModel;
  final String name;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AspectRatio(
      aspectRatio: screenWidth > 600 ? 4 / 2 : 16 / 9,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.04,
          horizontal: screenWidth * 0.03,
        ),
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.black,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.1,
                    backgroundImage: NetworkImage(doctorModel.doctorImage ??
                        'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=600'),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctorModel.doctorName ?? 'Loading ...',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy-Bold',
                            fontSize: screenWidth * 0.05,
                          ),
                        ),
                        Text(
                          doctorModel.doctorSubject ?? 'Loading ...',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenWidth * 0.04),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(
                    vertical: screenWidth * 0.02,
                    horizontal: screenWidth * 0.1,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return SectionView(
                          subject: doctorModel.doctorSubject!,
                          name: name,
                          docName: doctorModel.doctorName!,
                        );
                      },
                    ),
                  );
                },
                child: Text(
                  'Enter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
