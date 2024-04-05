import 'package:flutter/material.dart';
import 'package:flutter_app/components/round_bottom.dart';
import 'package:flutter_app/screens/login_screen.dart';
import 'package:flutter_app/screens/singin.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(image: AssetImage('images/logo.jpg')),
              SizedBox(
                height: 30,
              ),
              RoundButton(
                title: 'Login',
                onPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              ),
              SizedBox(
                height: 30,
              ),
              RoundButton(
                title: 'Register',
                onPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SingIn()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
