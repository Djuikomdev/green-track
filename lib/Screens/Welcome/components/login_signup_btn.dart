import 'package:flutter/material.dart';

import '../../../components/button.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';
import '../../Signup/signup_screen.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButon(

          onPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const LoginScreen();
              },
            ),
          );
        }, title: 'Se connecter', color: Colors.green,),

        const SizedBox(height: 16),
        CustomButon(
          onPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const SignUpScreen();
              },
            ),
          );
        }, title: 'S\'inscrire', color: kPrimaryColor,
        ),

      ],
    );
  }
}
