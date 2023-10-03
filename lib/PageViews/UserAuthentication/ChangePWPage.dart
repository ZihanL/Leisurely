import 'package:flutter/material.dart';
import 'package:Leisurely/Toolbox/HttpClient.dart';
import 'package:Leisurely/Toolbox/CustomWidgetLib.dart';
import '../../Models/User.dart';

class ChangePWPage extends StatefulWidget {
  const ChangePWPage({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  _ChangePWPageState createState() => _ChangePWPageState();
}

class _ChangePWPageState extends State<ChangePWPage> {
  //final ForgotFWPageController _pageController=ForgotFWPageController();
  final TextEditingController _currentpwController=TextEditingController();
  final TextEditingController _newpwController=TextEditingController();
  final TextEditingController _confirmpwController=TextEditingController();
  @override
  void initState() {
    super.initState();
    //_pageController.user=widget.user;

  }

  @override
  void dispose() {
    //_pageController.dispose();
    super.dispose();
  }

  void _saveInfo(){
    if(_currentpwController.text!=widget.user.password){
      PromptMessage(context, "Current password incorrect",Colors.redAccent);
    }
    else{
      if(_confirmpwController.text!=_newpwController.text){
        PromptMessage(context, "Mismatching new password and confirm password",Colors.redAccent);
      }
      else{
        widget.user.password=_newpwController.text;
        _currentpwController.clear();
        _newpwController.clear();
        _confirmpwController.clear();
        updateUser(widget.user);
        Navigator.pop(context);
      }
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
          title: const Text('Change Password'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: _saveInfo,
                icon: const Icon(Icons.check_rounded)
            )
          ],
        ),
        body:Padding(
            padding: const EdgeInsets.all(20),
            child:Container(
              decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
              ),
              padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(
                  children: [
                    LabelWrapper('Current Password', PasswordField(_currentpwController,_saveInfo,true,password: widget.user.password)),
                    SizedBox(height: 15),
                    LabelWrapper('New Password', PasswordField(_newpwController,_saveInfo,false)),
                    SizedBox(height: 15),
                    LabelWrapper('Confirm New Password', PasswordField(_confirmpwController,_saveInfo,true,password: _newpwController.text)),
              ],
            ))
       ))
    );


    // return AlertDialog(
    //   title: Text('Change Password?'),
    //   // To display the title it is optional
    //   content: Text('You are about to change your password'),
    //   // Message which will be pop up on the screen
    //   // Action widget which will provide the user to acknowledge the choice
    //   actions: [
    //     TextButton(
    //       onPressed: () {},
    //       // function used to perform after pressing the button
    //       child: const Text('Proceed'),
    //     ),
    //     TextButton(
    //       onPressed: () {},
    //       child: const Text('Cancel'),
    //     ),
    //   ],
    // );

  }
}