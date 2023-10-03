import 'dart:convert';

import 'package:Leisurely/Models/TripPlan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:Leisurely/Toolbox/Constants.dart';
import 'package:Leisurely/Toolbox/HttpClient.dart';
import 'package:Leisurely/PageViews/UserAuthentication/SignUpPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_cache/flutter_cache.dart' as cache;

import '../../Models/User.dart' as theUser;
import '../../Toolbox/CustomWidgetLib.dart';
import '../../Toolbox/GoogleAuth.dart';
import '../MainScreenView.dart';
//import 'dashboard_screen.dart';


class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  theUser.User appUser=NULL_USER;
  bool _isSignUp=false;

  Future<String?> _signupUser(SignupData data) {
    _isSignUp=true;
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    bool isUserExist=false;
    //TODO: check if user already exists
    appUser.email=data.name!;
    appUser.password=data.password!;

    return Future.microtask(() async =>isUserExist=await checkUser(data.name!)).then(
        (_){
          if (isUserExist){
            return "Account already exist, please login";
          }
          appUser.email=data.name!;
          appUser.password=data.password!;
          return null;
        }
    );
  }

  Future<String?>? _loginUser(LoginData loginData){
    _isSignUp=false;
    appUser.email=loginData.name;
    appUser.password=loginData.password;
    // return Future.microtask(() {loginUser(loginData.name, loginData.password);}).then(
    //         (response) {
    //           response=response as Map;
    //           print("Hello there");
    //           appUser=response["user"];
    //           appUser.tripPlans=response["plans"];
    //       if (appUser==NULL_USER){ //user not found
    //         print("Login failed, no user found");
    //         return "Incorrect login credentials and/or password";
    //       }
    //       print("Login Success");
    //         });

    return null;
  }
  Future<String> _recoverPassword(String email) {
    debugPrint('Email: $email');
    return Future.microtask(() => checkUser(email)).then(
            (value){
              if(!value) {
                return "User does not exist";
              }
              //todo:perform smtp
              return "Forgot password email sent";
            });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title:'Leisurely',
      logo: const AssetImage('assets/Leisurely_LOGO_transparent.png'),
      theme: LoginTheme(
        buttonTheme: LoginButtonTheme(
          backgroundColor: CustomPink,
          highlightColor: CustomPink
        ),
        pageColorLight: CustomPink,
        buttonStyle: TextStyle(
          fontFamily: 'OpenSans',
        ),
        titleStyle: TextStyle(
          fontFamily: 'ComicNeue',
          color: Colors.white
        ),
        bodyStyle: TextStyle(
          fontFamily: 'ComicNeue',
        ),
      ),
      onLogin: _loginUser,
      onSignup: _signupUser,
      scrollable: true,


      onSubmitAnimationCompleted: () {
        if(_isSignUp){
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>  SignUpPage(appUser.email,appUser.password,key:key),
            ),
                (route) => false,//if you want to disable back feature set to false
          );
        }
        else{
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => FutureBuilder<theUser.User>(
              future:loginUser(appUser.email,appUser.password),
              builder:(context,snapshot){
                if (snapshot.hasData){
                  appUser=snapshot.data!;
                  //appUser.tripPlans=snapshot.data!["plans"];
                  //case 1: no login info found
                  print(appUser.uId);
                  if(appUser.uId==INCORRECT_CRED||appUser.uId==OTHER_ERR){
                    return CannotDisplayVisual(context, "Incorrect Login Credentials","Login",LoginPage());
                  }
                  else{
                    return MainScreenView(user:appUser);
                  }
                }
                return Scaffold(
                    appBar:AppBar(),
                    body: LoadingVisual(context,"Loading user information...")
                  );
                //return LoadingVisual(context,"Loading user information...");//TODO: change to loading visuals
              }),
            ),
                (route) => false,//if you want to disable back feature set to false
          );
        }

      },
      onRecoverPassword: _recoverPassword,
    );
  }
}