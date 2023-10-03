import 'package:flutter/material.dart';
import 'package:Leisurely/Toolbox/HttpClient.dart';
import 'package:Leisurely/Toolbox/CustomWidgetLib.dart';
import 'package:Leisurely/PageViews/UserAuthentication/LoginPage.dart';
import '../../Models/User.dart';
import '../ObsoletePages/xxxLoginPage.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  //final ForgotFWPageController _pageController=ForgotFWPageController();
  //TODO: text controller for password field
  final _passwordController=TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    //_pageController.dispose();
    super.dispose();
  }

  void _onPressNext(){
    //TODO: Validate password and delete account
    if(_passwordController.text!=widget.user.password){
      PromptMessage(context, "Password incorrect",Colors.redAccent);
      //TODO: alert box incorrect password
    }
    else{
      //TODO: optional alert box are you sure deleting?
      deleteUser(widget.user.uId);
      //go back to login page
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => LoginPage(),
        ),
            (route) => false,//if you want to disable back feature set to false
      );

    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.navigate_before_rounded, size: 30),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Delete Account'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: _onPressNext,
                icon: const Icon(Icons.navigate_next_rounded),
                disabledColor: Colors.black12,
            )
          ],

        ),
        body:  Padding(
        padding: const EdgeInsets.all(20),
        child:Container(
          decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
              child: LabelWrapper('Enter your password to continue',
                  PasswordField(_passwordController,_onPressNext,true,
                      password: widget.user.password)),
          ))
        )
    );


  }
}