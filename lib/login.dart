import 'package:coffeehouse/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

const double logoSize = 300.0;

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void Function()? signIn(String email, String password) {
    context.read<AuthService>().signIn(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: const Color(0xFFFCFCFC),
      margin: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(
                child: SvgPicture.asset(
                  'assets/Coffeehouse.svg',
                  color: Colors.white,
                ),
                width: logoSize,
                height: 100,
              ),
              SizedBox(
                child: SvgPicture.asset(
                  'assets/Logo.svg',
                  color: Colors.white,
                ),
                width: logoSize,
                height: 100,
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                contentPadding: const EdgeInsets.all(16),
                fillColor: const Color(0xFF865243),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                contentPadding: const EdgeInsets.all(16),
                fillColor: const Color(0xFF865243),
              ),
              style: const TextStyle(color: Colors.white),
              obscureText: true,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: ElevatedButton(
                onPressed: signIn(emailController.text.trim(),
                    passwordController.text.trim()),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    primary: const Color(0xFFFF3700),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10)),
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  child: const Text(
                    "Prijavi se",
                    style: TextStyle(fontSize: 24),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
