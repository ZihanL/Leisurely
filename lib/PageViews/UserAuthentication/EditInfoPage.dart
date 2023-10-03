import 'package:flutter/material.dart';

import '../../Toolbox/ConversionTools.dart';
import '../../PageControllers/UserAuthentication/EditInfoPageController.dart';
import '../../Toolbox/Constants.dart';
import '../../Models/User.dart';
import '../../Toolbox/CustomWidgetLib.dart';


 // Create a Form widget.
 class EditInfoPage extends StatefulWidget {
   EditInfoPage( {super.key, required this.user});
   final User user; //user information

   @override
   _EditInfoPageState createState() => _EditInfoPageState();

 }

 class _EditInfoPageState extends State<EditInfoPage> {
   final EditInfoPageController _pageController=EditInfoPageController();

   //Input field controllers
   final TextEditingController _bDayController=TextEditingController();
   final TextEditingController _usernameController=TextEditingController();
   //final TextEditingController _nameController=TextEditingController();

   final _formKey = GlobalKey<FormState>();


   @override
   //InitState method
   void initState(){
     super.initState();
     _pageController.user=widget.user;
     _pageController.displayGender=_pageController.user.gender;
     _bDayController.text=dateTimeToString(_pageController.user.birthday);
     _usernameController.text=_pageController.user.userName;
     //_nameController.text=_pageController.user.name;

   }

   @override
   //Dispose method
   void dispose() {
     _bDayController.dispose();
     _usernameController.dispose();
     //_nameController.dispose();
     _pageController.dispose();
     super.dispose();
   }

   @override
   Widget build (BuildContext context){
     return Scaffold(
         appBar: AppBar(
           leading: IconButton(
             icon: const Icon(Icons.navigate_before_rounded, size: 30),
             onPressed: () => Navigator.of(context).pop(),
           ),
           title: const Text('Edit My Info'),
           centerTitle: true,
           actions: [
             IconButton(
                 onPressed: _saveInfo,
                 icon: const Icon(Icons.check_rounded)
             )],
         ),
         body:Form(
             key:_formKey,
             child:Padding(
                 padding: const EdgeInsets.all(20),
                 child:Container(
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.all(Radius.circular(10)),
                       color: Colors.white,
                     ),
                   padding: const EdgeInsets.all(20),
                   child: SingleChildScrollView(
                     child:Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         //User Name
                         LabelWrapper('Username', TextBox(_usernameController,_pageController.setUsername)),
                         SizedBox(height: 15),
                         //Dropdown Menu for Gender
                         LabelWrapper('Gender', CustomDropDownMenu(context, Gender.keys.toList(), _pageController.user.gender, _setGender)),
                         SizedBox(height: 15),
                         LabelWrapper('Birthday', DatePicker(context,_bDayController,_setBirthday,
                             BDAY_FIRST_DATE,BDAY_LAST_DATE)),


                       ],)
                     )
                 ))
         )
     );
   }


   //set birthday on view
   void _setBirthday(DateTime birthday){
     setState((){
       _bDayController.text = dateTimeToString(birthday);
       _pageController.setBirthday(birthday);
     });
   }

   //set gender on view
   void _setGender(String gender){
     setState(() {
       _pageController.user.gender = gender;
       _pageController.displayGender=gender;
     });

   }

   void _saveInfo(){
     //TODO: publish changes to db
     FocusScope.of(context).unfocus();
     _formKey.currentState?.save();
     _pageController.updateUserInfo();

     _pageController.dispose();

     Navigator.pop(context,_pageController.user);

   }


   //
   //




 }



