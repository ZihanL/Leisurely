import 'package:Leisurely/PageViews/UserAuthentication/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:Leisurely/Toolbox/Constants.dart';
import 'package:Leisurely/Toolbox/HttpClient.dart';
import 'package:Leisurely/PageViews/UserAuthentication/ChangePWPage.dart';
import 'package:Leisurely/PageViews/ObsoletePages/xxxLoginPage.dart';

import '../UserAuthentication/EditInfoPage.dart';
import '../../PageControllers/MainScreen/MyProfilePageController.dart';
import '../../Models/User.dart';
import '../UserAuthentication/ChangePWPage.dart';
import '../UserAuthentication/DeleteAccountPage.dart';
import 'package:Leisurely/Toolbox/CustomWidgetLib.dart';


class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final MyProfilePageController _pageController=MyProfilePageController();

  void _onSignOut(){
    _pageController.user=NULL_USER;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context)=> LoginPage()));
  }


  void get()async{
    _pageController.user=await getUser(widget.user.uId);
  }
  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _pageController.user=widget.user;
    return Scaffold(
        //backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.navigate_before_rounded, size: 30),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title:const Text("MY PROFILE"),
          centerTitle: true,
    ),

    body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //Profile picture
        const Padding(
          padding: EdgeInsets.only(top:60),
          child:CircleAvatar(
            radius: 60,
            backgroundImage:AssetImage('assets/Leisurely_LOGO_1024_72dpi.png'),
          ),
        ),

        //Username
        Padding(
          padding: const EdgeInsets.all(10),
          child:Text(
            //TODO: need to update user info to the newest after coming back from edit info page
            _pageController.user.userName,
            style:const TextStyle(fontSize: 26, fontFamily: 'OpenSans', fontWeight:FontWeight.bold),

          ),
        ),

        //Menu of options
        Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              //border: Border.all(color: LOGOPink),
              //color: Colors.grey[50],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child:ListView(
              shrinkWrap: true,
              children:
                ListTile.divideTiles(
                  color: Colors.pink.shade50,
                  context: context,
                    tiles: [
                      ListTile(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                            EditInfoPage(user:_pageController.user)))
                            .then((value){
                          setState((){});
                        });
                      },
                      title: const Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'OpenSans',
                        ),),
                      trailing:const Icon(Icons.keyboard_arrow_right_rounded),
                    ),

                  ListTile(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                          ChangePWPage(user:_pageController.user)));
                    },
                    title: const Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'OpenSans',
                      ),),
                    trailing:const Icon(Icons.keyboard_arrow_right_rounded),
                  ),

                  ListTile(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                          DeleteAccountPage(user:_pageController.user)));
                    },
                    title: const Text(
                      "Delete Account",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'OpenSans',
                      ),),
                    trailing:const Icon(Icons.keyboard_arrow_right_rounded),
                  ),]
                ).toList(),
            ),
          ),
        ),
        //Sign out button
        Padding(
            //TODO: log out function
          padding: const EdgeInsets.all(20),
          child:CustomButton('LOGOUT', _onSignOut),
        ),
      ],
    )
    );
  }
}
