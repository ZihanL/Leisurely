import 'package:flutter/material.dart';
import 'package:Leisurely/PageControllers/UserAuthentication/SignUpPageController.dart';
import 'package:Leisurely/PageViews/MainScreenView.dart';
import 'package:Leisurely/PageViews/UserAuthentication/LoginPage.dart';

import '../../Toolbox/HttpClient.dart';
import '../../Toolbox/Constants.dart';
import '../../Toolbox/CustomWidgetLib.dart';


// Create a Form widget.
class SignUpPage extends StatefulWidget {
  const SignUpPage(this.email, this.password, {super.key});
  final String email; //user's email
  final String password; //user's password
  @override
  _SignUpPageState createState() => _SignUpPageState();

}

class _SignUpPageState extends State<SignUpPage> {
  final _pageController=SignUpPageController();

  //Input field controllers
  final TextEditingController _bDayController=TextEditingController();
  final TextEditingController _usernameController=TextEditingController();
  //final TextEditingController _nameController=TextEditingController();
  final TextEditingController _lastNameController=TextEditingController();
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _pwController=TextEditingController();
  final TextEditingController _confirmPwController=TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  //InitState method
  void initState(){
    super.initState();
    _bDayController.text=_pageController.user.birthday.toString().substring(0,10);
    _emailController.text=widget.email;
    _pwController.text=widget.password;
    _confirmPwController.text=widget.password;
  }

  @override
  //Dispose method
  void dispose() {
    _bDayController.dispose();
    _usernameController.dispose();
    //_nameController.dispose();
    _lastNameController.dispose();
    _pageController.dispose();
    _emailController.dispose();
    _pwController.dispose();
    _confirmPwController.dispose();
    super.dispose();
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.navigate_before_rounded, size: 30),
            onPressed: (){
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) =>  LoginPage(),
                ),
                    (route) => false,//if you want to disable back feature set to false
              );
            },
          ),
          title: const Text('Sign Up'),
          actions: [
            IconButton(
                onPressed: _submitInfo,
                icon: const Icon(Icons.check_rounded)
            )],
        ),
        body:Form(
            key:_formKey,
            child:Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child:
                SingleChildScrollView(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //User Name
                        LabelWrapper('Username', TextBox(_usernameController,_pageController.setUsername)),
                        SizedBox(height: 10),
                        //Email
                        LabelWrapper('Email', TextBox(_emailController, _pageController.setEmail)),
                        SizedBox(height: 10),
                        LabelWrapper('Password', PasswordField(_pwController, _pageController.setPassword,false)),
                        SizedBox(height: 10),
                        LabelWrapper('Confirm Password', PasswordField(_confirmPwController, (){},true,password: _pwController.text)),
                        SizedBox(height: 10),
                        //Dropdown Menu for GenderF
                        LabelWrapper('Gender', CustomDropDownMenu(context, Gender.keys.toList(), _pageController.user.gender, _setGender)),
                        SizedBox(height: 10),
                        //Birthday
                        LabelWrapper('Birthday', DatePicker(context,_bDayController,_setBirthday,
                            BDAY_FIRST_DATE,BDAY_LAST_DATE)),

                      ],
                    )
                )))
        )
    );
  }


  //set birthday on view
  void _setBirthday(DateTime birthday){
    setState((){
      _bDayController.text = birthday.toString().substring(0,10);
      _pageController.setBirthday(birthday);
    });
  }

  //set gender on view
  void _setGender(String gender){
    setState(() {
      _pageController.user.gender = gender;
    });

  }

  Future<Null> _submitInfo()async{
    _formKey.currentState?.save();
    _pageController.user.email=_emailController.text;
    _pageController.user.password=_pwController.text;
    _pageController.user.uId=await initUser(_pageController.user);
    //print(_pageController.user.uId);
    if(_pageController.user.uId==-1){
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>CannotDisplayVisual(context, "Already Existing Account, Please sign up with another email","Login",LoginPage())
        ,
        ),
            (route) => false,//if you want to disable back feature set to false
      );

    }
    else{
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>  MainScreenView(user: _pageController.user),
        ),
            (route) => false,//if you want to disable back feature set to false
      );
    }
    //go to home page


  }

}



