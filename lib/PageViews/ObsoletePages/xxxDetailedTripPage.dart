// import 'package:flutter/material.dart';
// import '../../Toolbox/CustomWidgetLib.dart';
//
// class xxxDetailedTripPage extends StatelessWidget {
//   final TextEditingController _tripNameController=TextEditingController(text:"My Fun Trip");
//
//   Widget _dashedText() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 15),
//       child: Text(
//         '------------------------------------------',
//         maxLines: 1,
//         style:
//         TextStyle(fontSize: 20.0, color: Colors.black12, letterSpacing: 5),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.pinkAccent,
//         leading:const BackButton(),
//       ),
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(
//             20,
//             20,
//             20,
//             0,
//           ),
//           child: Column(
//             children: <Widget>[
//               //MyBackButton(),
//               SizedBox(height: 10.0),
//               Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Text(
//                       _tripNameController.text,
//                       style: TextStyle(
//                           fontSize: 30.0, fontWeight: FontWeight.w700),
//                     ),
//                     ElevatedButton(
//                         onPressed: ()async{
//                           final name=await _changeTripName(context);
//                           if(name==null||name.isEmpty) return;
//                           //setState(()=>this.name=name);
//                           print(name);
//                         },
//                         child: const Text('Change Trip Name')),
//                   ]),
//               SizedBox(height: 20),
//               Align(
//                 alignment: Alignment.center,
//                 child: Text(
//                   'This is the date',
//                   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
//                 ),
//               ),
//               SizedBox(height: 10),
//               SizedBox(
//                 child: Text(
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w400,
//                   ),
//                   "This text is very very very very very "
//                       "very very very very very very long, display info?",
//                 ),
//               ),
//               SizedBox(height: 20),
//
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 20.0),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Expanded(
//                           flex: 1,
//                           child: ListView.builder(
//                             itemCount: time.length,
//                             shrinkWrap: true,
//                             physics: NeverScrollableScrollPhysics(),
//                             itemBuilder: (BuildContext context, int index) =>
//                                 Padding(
//                                   padding:
//                                   const EdgeInsets.symmetric(vertical: 15.0),
//                                   child: Align(
//                                     alignment: Alignment.centerLeft,
//                                     child: Text(
//                                       '${time[index]} ${time[index] > 8 ? 'AM' : 'PM'}',
//                                       style: TextStyle(
//                                         fontSize: 16.0,
//                                         color: Colors.black54,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Expanded(
//                           flex: 5,
//                           child: ListView.builder(
//                             itemCount: events.length,
//                             shrinkWrap: true,
//                             physics: NeverScrollableScrollPhysics(),
//                             itemBuilder: (BuildContext context, int index){
//                               return TaskContainer(
//                                 title: '${events[index]}',
//                                 subtitle:
//                                 '${description[index]}',
//                                 boxColor: Colors.pink.withAlpha(20),);
//                             },
//                               ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   //
//   Future<String?> _changeTripName(BuildContext context) =>showDialog<String>(
//       context: context,
//       builder: (context)=>NameTripDialog(context, _tripNameController)
//   );
//
//
// }
// //for detailed trip display helper widgets
// class CalendarDates extends StatelessWidget {
//   final String day;
//   final String date;
//   final Color dayColor;
//   final Color dateColor;
//
//   CalendarDates(
//       {this.day = '1',
//         this.date = '1',
//         this.dayColor = Colors.black,
//         this.dateColor = Colors.black});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 20.0),
//       child: Column(
//         children: <Widget>[
//           Text(
//             day,
//             style: TextStyle(
//                 fontSize: 16, color: dayColor, fontWeight: FontWeight.w400),
//           ),
//           SizedBox(height: 10.0),
//           Text(
//             date,
//             style: TextStyle(
//                 fontSize: 16, color: dateColor, fontWeight: FontWeight.w700),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class LightColors {
//   static const Color kLightYellow = Color(0xFFFFF9EC);
//   static const Color kLightYellow2 = Color(0xFFFFE4C7);
//   static const Color kDarkYellow = Color(0xFFF9BE7C);
//   static const Color kPalePink = Color(0xFFFED4D6);
//
//   static const Color kRed = Color(0xFFE46472);
//   static const Color kLavender = Color(0xFFD5E4FE);
//   static const Color kBlue = Color(0xFF6488E4);
//   static const Color kLightGreen = Color(0xFFD9E6DC);
//   static const Color kGreen = Color(0xFF309397);
//
//   static const Color kDarkBlue = Color(0xFF0D253F);
// }
//
// List<String> days = [
//   'Sun',
//   'Mon',
//   'Tue',
//   'Wed',
//   'Thu',
//   'Fri',
//   'Sat',
//   'Sun',
//   'Mon',
//   'Tue',
//   'Wed',
//   'Thu',
//   'Fri',
//   'Sat'
// ];
// List<String> dates = [
//   '5',
//   '6',
//   '7',
//   '8',
//   '9',
//   '10',
//   '11',
//   '12',
//   '13',
//   '14',
//   '15',
//   '16',
//   '17',
//   '18'
// ];
//
//
// List<int> time = [9, 10, 11, 12, 1, 2, 3, 4, 5, 6, 7, 8];
//
// class TaskContainer extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final Color boxColor;
//
//   TaskContainer({
//     this.title = '',
//     this.subtitle = '',
//     this.boxColor = Colors.white,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 15.0),
//       padding: EdgeInsets.all(20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 16.0,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 10.0),
//             child: Text(
//               subtitle,
//               style: TextStyle(
//                 fontSize: 14.0,
//                 color: Colors.black54,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           )
//         ],
//       ),
//       decoration: BoxDecoration(
//           color: boxColor, borderRadius: BorderRadius.circular(12.0)),
//     );
//   }
// }
//
// List<String> events = ['Eat', 'Eat', 'Eat', 'Eat'];
//
// List<String> description = [
//   'this is a description',
//   'this is a description',
//   'this is a description',
//   'none'
// ];
