// import 'package:flutter/material.dart';
// import 'package:Leisurely/Toolbox/Constants.dart';
// import 'package:Leisurely/Toolbox/HttpClient.dart';
// import 'package:Leisurely/Toolbox/CustomWidgetLib.dart';
//
// import 'package:Leisurely/PageViews/MainScreenView.dart';
// import 'package:Leisurely/PageViews/UserAuthentication/SignUpPage.dart';
//
//
// import '../../Models/User.dart';
// import '../../PageControllers/UserAuthentication/LoginPageController.dart';
//
// class xxxLoginPage extends StatelessWidget {
//   const xxxLoginPage({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(left: 20, right: 20),
//       constraints: const BoxConstraints.expand(),
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image:NetworkImage("https://picsum.photos/id/237/200/300"),
//           fit:BoxFit.cover, //cover entire background
//         )
//       ),
//       child:Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Center(
//           child: Container(
//             padding: const EdgeInsets.all(30),
//             decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.9),
//                 borderRadius: BorderRadius.all(Radius.circular(20))
//             ),
//             child: LoginForm(),
//           )
//         )
//       ),
//     );
//   }
// }
//
//
// // Create a Form widget.
// class LoginForm extends StatefulWidget {
//   const LoginForm({super.key});
//
//   @override
//   _LoginFormState createState() {
//     return _LoginFormState();
//   }
// }
//
// // Create a corresponding State class.
// // This class holds data related to the form.
// class _LoginFormState extends State<LoginForm> {
//   // Create a global key that uniquely identifies the Form widget
//   // and allows validation of the form.
//   //
//   // Note: This is a GlobalKey<FormState>,
//   // not a GlobalKey<LoginFormState>.
//   final _formKey = GlobalKey<FormState>();
//   final _pageController=LoginPageController();
//   final _emailController=TextEditingController();
//   final _passwordController=TextEditingController();
//
//
//   void _onSignIn() {
//     User? user=NULL_USER;
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
//           FutureBuilder<User?>(
//               future:getUser(uId: 4571),
//               //future:loginUser(_emailController.text,_passwordController.text),
//               builder:(context,snapshot){
//                 if (snapshot.hasData){
//                   user=snapshot.data;
//                   //case 1: no login info found
//                   if(user==NULL_USER){
//                     //TODO: stay in current page
//                   }
//                   else{
//                     return MainScreenView(user:user!);
//                   }
//                 }
//                 return const CircularProgressIndicator();//TODO: change to loading visuals
//               })
//       ));
//     }
//     // TODO: sign into account
//     // if (_formKey.currentState!.validate()) {
//     //   _formKey.currentState!.save();
//     //   var user= getUser(email: _emailController.text)as User;
//     //   //case 1: user does not exists
//     //   if (user==NULL_USER){
//     //     PromptMessage(context,"User does not exist");
//     //   }
//     //   else{ //case 2: user exists
//     //     //case 2.1: correct password
//     //     if (_passwordController.text==user.password){
//     //       Navigator.of(context).push(
//     //         MaterialPageRoute(builder: (context) => MainScreenView(user: user)),
//     //       );
//     //     }
//     //     else{
//     //       PromptMessage(context,"Password incorrect, please enter again");
//     //     }
//     //   }
//     // }
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     // Build a Form widget using the _formKey created above.
//     return Form(
//       key: _formKey,
//             child:SingleChildScrollView(
//               child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 //Header Text
//                 Center(
//                   child: Column(
//                       children:[
//                         Text("Hello There!",
//                           style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//                         ),
//                         Text("(Please Sign in)", style: TextStyle(fontSize: 15)),
//                       ]
//                   ),),
//
//                 //Email Text
//                 LabelWrapper('Email',EmailField(_emailController)),
//
//                 //Password Text
//                 LabelWrapper('Password', PasswordField(_passwordController,(String val){},false)),
//
//                 //Remember Credential Text
//                 // Padding(
//                 //   padding: const EdgeInsets.only(top:10),
//                 //   child: Row(
//                 //       mainAxisAlignment: MainAxisAlignment.center,
//                 //       children: [
//                 //         Text("Remember Me ",
//                 //             style: TextStyle(
//                 //                 color: Color(0xff646464),
//                 //                 fontSize: 12,
//                 //                 fontFamily: 'Rubic')),
//                 //         SizedBox(
//                 //             height: 24.0,
//                 //             width: 24.0,
//                 //             child: Theme(
//                 //               data: ThemeData(
//                 //                   unselectedWidgetColor: Color(0xff00C8E8) // Your color
//                 //               ),
//                 //               child: Checkbox(
//                 //                   activeColor: Color(0xff00C8E8),
//                 //                   value: _pageController.rememberMeChecked,
//                 //                   onChanged: null),
//                 //             )),
//                 //         SizedBox(width: 10.0)
//                 //       ]),
//                 // ),
//
//                 //Sign in and Sign up Buttons
//                 Column(
//                     children:[
//                       //Sign in button
//                       CustomButton("Sign In", _onSignIn),
//
//                       //Sign up text
//                       Padding(
//                           padding: EdgeInsets.symmetric(vertical:10),
//                           child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children:[
//                                 const Text("Don't have an account? "),
//                                 InkWell(
//                                   child: const Text("Sign up", style:TextStyle(fontWeight: FontWeight.bold),),
//                                   onTap:(){
//                                     Navigator.of(context).push(
//                                       MaterialPageRoute(builder: (context) => const SignUpPage("","")),
//                                     );
//                                   },
//                                 )
//                               ]
//                           )
//                       ),
//                     ]
//                 ),
//               ],
//             ),
//           ),
//     );
//   }
// }
