import 'package:flutter/material.dart';
import 'package:SmartBudget/chat/constants/color_constants.dart';
import 'package:SmartBudget/chat/pages/pages.dart';
import 'package:SmartBudget/chat/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkSignedIn();
  }

  void _checkSignedIn() async {
    final authProvider = context.read<AuthProvider>();
    bool isLoggedIn = await authProvider.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => LoginPage()),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "images/app_icon.png",
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            Container(
              width: 20,
              height: 20,
              child:
                  CircularProgressIndicator(color: ColorConstants.themeColor),
            ),
          ],
        ),
      ),
    );
  }
}
