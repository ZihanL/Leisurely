import 'package:flutter/material.dart';
import 'package:Leisurely/Toolbox/CustomWidgetLib.dart';
import '../../Models/User.dart';

class ForgotPWPage extends StatefulWidget {
  const ForgotPWPage({Key? key}) : super(key: key);
  @override
  _ForgotPWPageState createState() => _ForgotPWPageState();
}

class _ForgotPWPageState extends State<ForgotPWPage> {
  //final ForgotFWPageController _pageController=ForgotFWPageController();
  final TextEditingController _emailController=TextEditingController();
  @override
  void initState() {
    super.initState();
    //_pageController.user=widget.user;
    _emailController.text="please@linkemail";//TODO: link to user's email

  }

  @override
  void dispose() {
    //_pageController.dispose();
    _emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.navigate_before_rounded, size: 30),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Forgot Password'),

        ),
        body:Column(
          children: [
            LabelWrapper('Please enter your email address', EmailField(_emailController)),
            const Text('We will send the password to this email'),
            CustomButton('Confirm', onPressConfirm)
          ],

        )
    );


  }
  void onPressConfirm(){
    //TODO: validate email
  }
}