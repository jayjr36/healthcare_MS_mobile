import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_management_system/components/loginForm.dart';
import 'package:healthcare_management_system/screens/registerPage.dart';
import 'package:healthcare_management_system/utils/config.dart';
import 'package:healthcare_management_system/utils/text.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Config().init(context);

    bool isloading = false;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: SizedBox(
                    width: w * 0.3,
                    height: h * 0.3,
                    child: Image.network(
                        "https://img.clipart-library.com/2/clip-physicians/clip-physicians-17.jpg"),
                  ),
                ),
                Center(
                  child: Text(
                    'Meet Your Doctor',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 156, 16, 6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Login To Your Account',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Config.spaceSmall,
                LoginForm(),
                Config.spaceSmall,
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "  Register here",
                              style: const TextStyle(
                                color: Colors.black,
                                decorationStyle: TextDecorationStyle.solid,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterPage(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
