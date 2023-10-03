import 'package:Leisurely/PageViews/MainScreenView.dart';
import 'package:Leisurely/Toolbox/Constants.dart';
import 'package:flutter/material.dart';
import '../../Models/TripPlan.dart';
import '../../Models/User.dart';
import '../../Models/Event.dart';
import '../../Toolbox/CustomWidgetLib.dart';
import '../../Toolbox/HttpClient.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_cache/flutter_cache.dart' as cache;
import 'EditTripDetailPage.dart';
import 'HomePage.dart';

class ViewTripDetailPage extends StatefulWidget {
  const ViewTripDetailPage({Key? key, required this.user, required this.tripPlan}) : super(key: key);
  final User user;
  final TripPlan tripPlan;
  @override
  _ViewTripDetailPageState createState() => _ViewTripDetailPageState();
}

class _ViewTripDetailPageState extends State<ViewTripDetailPage> {
  var appBarHeight = AppBar().preferredSize.height;
  var _popupMenuItemIndex = 0;
  late String _favText;

  @override
  void initState(){
    super.initState();
    //await cache.write(widget.tripPlan.tripName, widget.tripPlan.isFav.toString());
  }
  @override
  Widget build(BuildContext context) {
    _favText=widget.tripPlan.isFav?UNSET_FAV:SET_FAV;
    DateTime eventDate=DateTime(widget.tripPlan.startTime.year,widget.tripPlan.startTime.month,widget.tripPlan.startTime.day);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: (){
                Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => MainScreenView(user:widget.user),
                    ),
                        (route) => false);
              },
              icon: const Icon(Icons.home_rounded)) ,
          title: const Text("ENJOY"),
          centerTitle: true,
          actions: [
            PopupMenuButton<int>(
              onSelected: (value) =>_onMenuItemSelected(value),
              itemBuilder: (context) => [
                // popupmenu item 1 Edit
                PopupMenuItem(
                  value: 1,
                  child: Column(
                    children: [
                      Row(
                      children: [
                      Icon(Icons.edit_rounded, color: Color(LOGOPinkInt), size: 20),
                      SizedBox(
                      width: 10,
                      ),
                      Text("Edit")
                      ],
                      ),
                      Divider(thickness:1)
                  ],)
                ),

                // popupmenu item 2 Favourite
                PopupMenuItem(
                  value: 2,
                  child: Column(
                    children: [
                    Row(
                    children: [
                    Icon(Icons.star_rounded, color: Color(LOGOOrangeInt), size: 20),
                    SizedBox(
                    width: 10,
                    ),
                    Text(_favText),
                    ],
                    ),
                    Divider(thickness:1)
                    ],)
                  ),

                //popupmenu item 3 Delete
                PopupMenuItem(
                  value: 3,
                  child: Column(children: [
                    Row(
                      children: [
                        Icon(Icons.delete_rounded, color: Colors.red, size: 20),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Delete")
                      ],
                    ),
                    Divider(thickness: 1)
                  ],),

                ),
              ],

              //decoration
              //elevation: 2,
              offset: Offset(-20.0, appBarHeight+5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
            ),
            ],
        ),
        body: Container(
        child: Column(
          children: <Widget>[
            //MyBackButton(),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            child:widget.tripPlan.isFav? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const[
                                  Icon(Icons.star_rounded,color: Color(LOGOOrangeInt)),
                                  SizedBox(width: 10),
                                ]
                            ):null
                        ),
                        Flexible(child: Text(
                          widget.tripPlan.tripName,
                          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'OpenSans', fontSize: 18),
                        ),)
                      ]
                  ),
                SizedBox(
                    height: 40,
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.pin_drop_rounded, color: Color(LOGOPinkInt)),
                          Text("   ${widget.tripPlan.location}", style: TextStyle(fontFamily: 'OpenSans'),),
                        ]
                    )
                ),
                SizedBox(height:5),
                // SizedBox( //TODO: fix layout
                //     height: widget.tripPlan.isFav? 40: 5,
                //     child:widget.tripPlan.isFav? Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: const[
                //           Icon(Icons.star_rounded,color: Color(LOGOOrangeInt)),
                //           SizedBox(width: 10),
                //           Text("Marked as Favourite"),
                //           SizedBox(width: 10),
                //         ]
                //     ):null
                // ),
                SizedBox(
                  child: Text(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'ComicNeue',
                      color: Colors.grey,
                    ),
                    "We travel not to escape, "
                        "but for life not to escape us.",
                  ),
                ),
              ],),),

          Expanded(
            child: SfCalendar(
              view: CalendarView.day,
              specialRegions: _getTimeRegions(),
              initialDisplayDate: widget.tripPlan.startTime,
              dataSource: _getCalendarDataSource(),
              allowDragAndDrop: false,//testDragDrop(),
              onTap: calendarTapped,
              minDate: eventDate,
              viewHeaderHeight: 0,
              headerDateFormat: 'LLLL d, y',
              timeSlotViewSettings: const TimeSlotViewSettings(
                  //timeInterval: Duration(minutes: 120),
                  timeIntervalHeight: 60,
                  timeTextStyle: TextStyle(
                    fontFamily: 'OpenSans',
                    color: Colors.grey,
                    fontSize: 12
                  ),
                 // timeFormat: 'h:mm',
                  timeRulerSize: 50),
              headerStyle: CalendarHeaderStyle(
                  textStyle: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black87, fontSize: 18
                  ),
                  textAlign: TextAlign.center,
                  backgroundColor: Colors.white70),
              appointmentTextStyle: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 16.0
              ),
              //maxDate: startTime.add(const Duration(days:0,seconds: 1)),
              maxDate: eventDate.add(const Duration(days:1)).subtract(const Duration(days:0,seconds:1)),
            ),
          )])
        ));
  }

  //menu
  _onMenuItemSelected(int value) async {
    setState(() {
      _popupMenuItemIndex = value;
    });

    if(value == 1) { //Edit
      Navigator.of(context).push(
          MaterialPageRoute<dynamic>
            (builder: (BuildContext context) =>
              EditTripDetailPage(
                  user: widget.user, tripPlan: widget.tripPlan,isConfirmed:true)));
    }
    else if(value==2){ //Star Favourite
      int tripIndex=widget.user.tripPlans.indexWhere((tp) =>tp.tripName==widget.tripPlan.tripName);
      widget.user.tripPlans[tripIndex].isFav=!widget.user.tripPlans[tripIndex].isFav;
      setState(() {
        widget.tripPlan.isFav=widget.user.tripPlans[tripIndex].isFav;
        if(widget.tripPlan.isFav){
          _favText=UNSET_FAV;
        }
        else{
          _favText=SET_FAV;
        }
      });

      await cache.write(widget.tripPlan.planId.toString(),widget.user.tripPlans[tripIndex].isFav.toString());
      print("trip is set to fav? ${widget.user.tripPlans[tripIndex].isFav.toString()}");
    }
    else if (value==3){ //delete
      {
        cache.destroy(widget.tripPlan.planId.toString());
        _onDeleteTrip();
      }
    }

  }

  List<TimeRegion> _getTimeRegions() {
    List<Event> fixedTimeEvents=widget.tripPlan.chosenEvents.where((ev) => ev.type==FIXED_TIME_EVENT).toList();
    final List<TimeRegion> regions = <TimeRegion>[];
    for(Event ev in fixedTimeEvents){
      regions.add(TimeRegion(
          startTime: ev.startTime,
          endTime: ev.endTime,
          enablePointerInteraction: false,
          color: LOGOPinkShade.withOpacity(0.5),
          text: ev.eventTitle + ' (Fixed Time)',
          textStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 16
          )
      ));
    }


    return regions;
  }


  void calendarTapped(CalendarTapDetails details) {
    //TODO: bug fixed event is not there
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Appointment appointmentDetails = details.appointments![0];
      //find index of tapped event in the list
      int index=widget.tripPlan.chosenEvents.indexWhere((ev) => ev.eventTitle==appointmentDetails.subject);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Container(
                  child:
                  Text(
                      appointmentDetails.subject,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                      ),
                  )
              ),
              content: SingleChildScrollView(child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Event Type',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                              fontSize: 16,
                        )),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(appointmentDetails.notes!, //TODO: description now shown as bar,
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    // Row(
                    //   children: <Widget>[
                    //     Text(index==widget.tripPlan.chosenEvents.length?"":
                    //       'Travel Time to Next Event:',
                    //       style: TextStyle(
                    //         fontFamily: 'OpenSans',
                    //         fontSize: 16,
                    //       ),),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 30,
                    //   child:Text(index==widget.tripPlan.chosenEvents.length?"":
                    //   '${(widget.tripPlan.chosenTransportDuration[index]/60).toString().split(".").first} minutes',
                    //     style: TextStyle(
                    //       fontFamily: 'OpenSans',
                    //       fontSize: 16,
                    //     ))
                    // ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Address',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            fontSize: 16,
                          ),),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                              appointmentDetails.location!,
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 16,
                              ),),),
                      ],
                    ),
                  ],
                )),
              actions: <Widget>[
                Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                child:
                CustomButton("CLOSE",(){
                  Navigator.of(context).pop();
                })
                )
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            );
          });
    }
  }

  void _onDeleteTrip(){
    showDialog(
      context: context,
      builder: (BuildContext context)=>
          AlertDialogPopUp(context, MSG_DELETE_TRIP_HDR, MSG_DELETE_TRIP_TXT, true,_deleteTripEntirely,widget.tripPlan),
    );
  }

  void _deleteTripEntirely(TripPlan trip) {
    setState(() {
      widget.user.tripPlans.remove(trip);
      deletePlanHttp(trip);

      //TODO: Notify backend after delete
    });
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) =>  MainScreenView(user: widget.user),
      ),
          (route) => false,//if you want to disable back feature set to false
    );
  }
  _AppointmentDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    List<Event> flexTimeEvents=widget.tripPlan.chosenEvents.where((ev) => ev.type!=FIXED_TIME_EVENT).toList();
    print(flexTimeEvents);
    for(Event ev in flexTimeEvents){
      ////TODO: id to check if it is popup event, if no, add to appointment
      appointments.add(Appointment(
        startTime: ev.startTime,
        endTime: ev.endTime,
        subject: ev.eventTitle,
        //notes:  ev.description.substring(0 , ev.description.length-1),
        notes: ev.description,
        location: ev.address,
        color: LOGOPink,
      ));
    }
    return _AppointmentDataSource(appointments);
  }
}


class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source){
    appointments = source;
  }
}

