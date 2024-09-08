import 'package:baby/features/LoginAndRegister/presentation/views/login_view.dart';
import 'package:baby/features/LoginAndRegister/presentation/views/register_view.dart';
import 'package:flutter/material.dart';

class Startapp extends StatelessWidget {
  const Startapp({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonHeight = screenHeight * 0.08;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: screenHeight * 0.2,
          ),
          Image.asset(
            'assets/images/app_main.png',
            height: screenHeight * 0.2,
          ),
          Text(
            'Welcome To Collage App',
            style: TextStyle(
              fontFamily: 'Gilroy-Bold',
              fontSize: screenWidth * 0.06,
            ),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          SizedBox(
            width: screenWidth * 0.8,
            child: Text(
              'The Best App To Communicate With Your Mentors And Doctors and take your degree of attendance',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: screenWidth * 0.04,
              ),
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.16,
              vertical: screenHeight * 0.02,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                backgroundColor: Colors.black,
                minimumSize: Size(double.infinity, buttonHeight),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return LoginView();
                  }),
                );
              },
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.06,
                  fontFamily: 'Gilroy-Bold',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                backgroundColor: Colors.grey,
                minimumSize: Size(double.infinity, buttonHeight),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return RegisterView();
                  }),
                );
              },
              child: Text(
                'Register',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * 0.06,
                  fontFamily: 'Gilroy-Bold',
                ),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.1,
          ),
        ],
      ),
    );
  }
}
