
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Leisurely/PageViews/MainScreen/HomePage.dart';
import 'package:Leisurely/Toolbox/CustomWidgetLib.dart';
import 'package:Leisurely/PageViews/UserAuthentication/LoginPage.dart';
import 'package:flutter_cache/flutter_cache.dart' as cache;
import 'Toolbox/TestObjects.dart';
import 'Models/User.dart';
import 'Toolbox/Constants.dart';
import 'Toolbox/HttpClient.dart';
import 'PageViews/MainScreenView.dart';
import 'PageViews/ObsoletePages/xxxLoginPage.dart';
import 'PageViews/ObsoletePages/xxxDetailedTripPage.dart';
import 'Toolbox/TestCodes.dart';




void main() async{
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(Leisurely());
}

class Leisurely extends StatefulWidget  {
  const Leisurely({Key? key}) : super(key: key);
  @override
  _LeisurelyState createState() =>_LeisurelyState();
}

class _LeisurelyState extends State<Leisurely> {
  late User? user=NULL_USER;
  @override
  void initState(){
    super.initState();
    cache.clear();
  }

  @override
  void dispose(){
    super.dispose();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leisurely',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),
        primarySwatch: CustomPink,
        fontFamily: 'OpenSans',
        appBarTheme:AppBarTheme(
          backgroundColor: Colors.grey[50], //default bg color
          //backgroundColor: CustomPink,
          iconTheme: IconThemeData(
            size: 28,
            color: LOGOPink,
            //color: Colors.white,
          ),
          titleTextStyle: TextStyle(
            // shadows: [
            //   Shadow(
            //     blurRadius:0.5,  // shadow blur
            //     color: LOGOOrange, // shadow color
            //     offset: Offset(0.5,1.0), // how much shadow will be shown
            //   ),
            // ],
            color: LOGOPink,
            //color: Colors.white.withOpacity(0.95),
            fontFamily: 'ComicNeue',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0.5,
          //shadowColor: LOGOPink,
        ),
      ),
      home: SafeArea(

        child: SingleChildScrollView(
            child:AnimatedSplashScreen.withScreenFunction(
              splash:Center(
                child: Image.asset("assets/Leisurely_LOGO_transparent.png"),
              ),
              screenFunction: ()async{
                User user=TestInitUser();
               //User user=await getUser(1);

                if (user==NULL_USER){
                  return LoginPage(); //Login if no user found
                }
                return MainScreenView(user: user); //direct to home page otherwise
              },
              // nextScreen: Column(
              //   children: [
              //     Image.asset("lib/images/Leisurely_LOGO_transparent.png"),
              //     const Text('Leisurely'),
              //     const CircularProgressIndicator(),
              //     const Text("loading"),
              //   ],
              // ),
              backgroundColor: CustomPink,
              splashTransition: SplashTransition.fadeTransition,
              splashIconSize: 600,

            )),
        // child:FutureBuilder<User?>(
        //   future:Future.value(ALPHA_USER),
        //   //future:getUser(4572),
        //   builder:(context,snapshot){
        //     if (snapshot.hasData){
        //       user=snapshot.data;
        //       return SplashScreen();
        //       return MainScreenView(user:user!);
        //     }
        //     return SplashScreen();//TODO: change to loading visuals
        //   })
        )
      );
  }
}

