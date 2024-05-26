import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_management_system/components/signUpForm.dart';
import 'package:healthcare_management_system/screens/loginPage.dart';
import 'package:healthcare_management_system/utils/config.dart';
import 'package:healthcare_management_system/utils/text.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Config().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
               
                Center(
                  child: SizedBox(
                    width: w*0.3,
                    height: h*0.3,
                    child: Image.network(
                        "https://img.clipart-library.com/2/clip-physicians/clip-physicians-17.jpg"),
              
                  ),
                ),
               
                Center(
                  child: Text(
                    AppText.enText['register_text']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Config.spaceSmall,
                SignUpForm(),
                Config.spaceSmall,
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 15,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "  Login now",
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
