import 'package:Leisurely/PageControllers/MainScreen/NewTripPageController.dart';
import 'package:Leisurely/Toolbox/Constants.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_cache/flutter_cache.dart' as cache;
import '../../Models/Event.dart';
import '../../Models/TripPlan.dart';
import '../../Models/User.dart';
import '../../Toolbox/CustomWidgetLib.dart';
import '../../Toolbox/HttpClient.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:time_range_picker/time_range_picker.dart';

import '../MainScreenView.dart';
import 'ViewTripDetailPage.dart';

class EditTripDetailPage extends StatefulWidget {
  EditTripDetailPage({Key? key, required this.user, required this.tripPlan,required this.isConfirmed}) : super(key: key);
  final User user;
  TripPlan tripPlan;
  bool isConfirmed=false;
  @override
  _EditTripDetailPageState createState() => _EditTripDetailPageState();
}

class _EditTripDetailPageState extends State<EditTripDetailPage> {

  final TextEditingController _tripNameController=TextEditingController();
  @override
  void initState() {
    super.initState();
    _tripNameController.text = widget.tripPlan.tripName;
    if (widget.tripPlan.chosenEvents.length == 0) {
      widget.tripPlan.chosenEvents.clear();
      for (Event ev in widget.tripPlan.mainEvents) {
        widget.tripPlan.chosenEvents.add(ev);
      }
    }
  }

  int currentPos = 0;
  List<Appointment> appointments = <Appointment>[];

  @override
  Widget build(BuildContext context) {
    DateTime eventDate=DateTime(
        widget.tripPlan.startTime.year,
        widget.tripPlan.startTime.month,
        widget.tripPlan.startTime.day
    );

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.navigate_before_rounded, size: 30, color: Color(LOGOOrangeInt)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("Adjust your trip", style: TextStyle(color: Color(LOGOOrangeInt))),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed:() {
                _onSave();
              },
              icon: const Icon(Icons.check_rounded, color: Color(LOGOOrangeInt)),
              disabledColor: Colors.black12,
            )
          ],
        ),
        body:  Column(
          children: <Widget>[
            //MyBackButton(),
        Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                    _tripNameController.text,
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'OpenSans', fontSize: 18),
                  ),),
                  IconButton( //TODO: add radius + change color
                      onPressed: ()async{
                        final name=await _setTripName(context);
                        if(name==null||name.isEmpty) return;
                        setState(() {
                          _tripNameController.text=name;
                        });
                      },
                      icon: const Icon(Icons.edit_rounded)),
                ]
            ),
            const SizedBox(
              child: Text(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                  fontFamily: 'ComicNeue'
                ),
                "Drag and drop to rearrange your plan",
              ),
            ),
            SizedBox(height: 10),
          ],
        )),

          Expanded(
            child: SfCalendar(
              view: CalendarView.day,
              specialRegions: _getTimeRegions(),
              initialDisplayDate: widget.tripPlan.startTime,
              dataSource: _getCalendarDataSource(),
              allowDragAndDrop: true,
              onDragEnd: _onChangeEventTime,
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
                  fontSize: 16.0,
                  color: Colors.black87),
              dragAndDropSettings: DragAndDropSettings(
                indicatorTimeFormat: 'hh:mm',
                showTimeIndicator: true,
                timeIndicatorStyle: TextStyle(
                  backgroundColor: LOGOOrange,
                  color: Colors.black,
                  fontSize: 20,
                )),
              //maxDate: startTime.add(const Duration(days:0,seconds: 1)),
              maxDate: eventDate.add(const Duration(days:1)).subtract(const Duration(days:0,seconds:1)),
            ),
          )]));
  }

  List<TimeRegion> _getTimeRegions() {
    dynamic fixedTimeEvent=widget.tripPlan.chosenEvents.firstWhere((ev) => ev.type==FIXED_TIME_EVENT,orElse: ()=>NULL_EVENT);
    final List<TimeRegion> regions = <TimeRegion>[];
    if (fixedTimeEvent!=NULL_EVENT) {
      regions.add(TimeRegion(
          startTime: fixedTimeEvent.startTime,
          endTime: fixedTimeEvent.endTime,
          enablePointerInteraction: false,
          color: Colors.grey.withOpacity(0.2),
          text: fixedTimeEvent.eventTitle+ ' (Fixed Time)',
          textStyle: TextStyle(
              color: Colors.black87,
              fontFamily: 'OpenSans',
              fontSize: 16
          )));
    }

    return regions;
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Appointment appointmentDetails = details.appointments![0];
      List<Event> altEvents=[];
      if (widget.tripPlan.mainEvents.isNotEmpty){
        print("there are main events");
        for(Event me in widget.tripPlan.mainEvents){
          altEvents.add(me);
        }
      }
      if (widget.tripPlan.alternateEvents.isNotEmpty) {
        print("there are alternative events");
        for (Event ae in widget.tripPlan.alternateEvents) {
          altEvents.add(ae);
        }
      }
      Event ev=widget.tripPlan.chosenEvents.firstWhere((ev) =>ev.eventTitle==appointmentDetails.subject); //TODO: check later once data source chagned
      //int evIndex=widget.tripPlan.chosenEvents.indexOf(ev);

      //determine how many chosen events are main, how many are alternative, etc.
      for(Event ce in widget.tripPlan.chosenEvents){
        altEvents.removeWhere((e) =>e.eventTitle==ce.eventTitle);
      }
      //determine whether the selected event is a main or alt event

      if(!altEvents.contains(ev)){
        altEvents.insert(0,ev); //TODO: it would be added again and again per tap
      }

      //late _AppointmentDataSource _events = _AppointmentDataSource(appointments);
      //Appointment? _selectedAppointment = null;
      TimeOfDay _selectedStartTime = TimeOfDay.fromDateTime(appointmentDetails.startTime);
      TimeOfDay _selectedEndTime = TimeOfDay.fromDateTime(appointmentDetails.endTime);

      showDialog(
          context: context,
          builder: (BuildContext context) {
            CarouselController _controller=CarouselController();
            return AlertDialog(
              title: null,
              // title: Container(
              //   color: Colors.red,
              //     child: Text("Choose Alternatives")),
              //title: Container(child: Text(appointmentDetails.subject)),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState){
                  return Container(
                      //color: Colors.green,
                      height: 320,
                      width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                              children: <Widget>[
                                Text(
                                  "Choose Alternatives",
                                  style:TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'OpenSans'
                                  ),),
                              ]
                          ),
                          SizedBox(height: 10),
                          CarouselSlider.builder(
                            carouselController: _controller,
                            itemCount: altEvents.length,
                            itemBuilder: (context, itemIndex, pageViewIndex) =>
                                Container(
                                  //color: Colors.lightBlue,
                                  width: 250,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Row(
                                            children: <Widget>[
                                              Text("Event Title",
                                                style:TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    fontFamily: 'OpenSans'
                                                ),),
                                            ]
                                        ),
                                        Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  altEvents[itemIndex].eventTitle,
                                                  style:TextStyle(
                                                      fontSize: 18, fontFamily: 'OpenSans'
                                                  ),
                                                ),
                                              )
                                            ]
                                        ),
                                        SizedBox(height:10),
                                        Row(
                                            children: <Widget>[
                                              Text("Address",
                                                style:TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    fontFamily: 'OpenSans'
                                                ),),
                                            ]
                                        ),
                                        Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  altEvents[itemIndex].address,
                                                  style:TextStyle(
                                                      fontSize: 18, fontFamily: 'OpenSans'
                                                  ),
                                                ),
                                              )
                                            ]
                                        ),
                                        SizedBox(height:10),
                                        Row(
                                            children: <Widget>[
                                              Text("Event Type",
                                                style:TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    fontFamily: 'OpenSans'
                                                ),),
                                            ]
                                        ),
                                        Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  altEvents[itemIndex].description,
                                                  style:TextStyle(
                                                      fontSize: 18, fontFamily: 'OpenSans'
                                                  ),
                                                ),
                                              )
                                            ]
                                        ),
                                      ],
                                    ),
                                  )
                                ),
                            options: CarouselOptions(
                                height: 204,
                                onPageChanged: (index, reason){
                                  setState(() {
                                    //_selectedAppointment = null;
                                    //_selectedAppointment = appointmentDetails;
                                    currentPos = index;
                                    print("${currentPos}");
                                  });
                                },
                                autoPlay: false,
                                viewportFraction: 1,
                                aspectRatio: 2,
                                initialPage: 0,
                                enableInfiniteScroll: false
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.center,
                            child: DotsIndicator(
                                decorator: DotsDecorator(
                                  activeColor: LOGOOrange,
                                  color: Colors.black26,
                                  size: const Size.square(9.0),
                                  activeSize: const Size(18.0, 9.0),
                                  activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                ),
                                dotsCount: altEvents.length,
                                position: currentPos.toDouble())
                          ),
                          SizedBox(height: 5),
                          //time picker
                          LabelWrapper("Select Start and End Time", InkWell(
                              onTap: () async {
                                TimeRange? result = await showTimeRangePicker(
                                    maxDuration: const Duration(hours: 24),
                                    context: context,
                                    start: _selectedStartTime,
                                    end: _selectedEndTime,
                                    disabledTime: TimeRange(
                                        startTime: const TimeOfDay(hour: 23, minute: 59),
                                        endTime: const TimeOfDay(hour: 00, minute: 10)),
                                    disabledColor: Colors.red.withOpacity(0.5),
                                    interval: const Duration(minutes: 1),
                                    strokeWidth: 4,
                                    ticks: 24,
                                    ticksOffset: -7,
                                    ticksLength: 15,
                                    ticksColor: Colors.black45,
                                    labels: ["12 am", "3 am", "6 am", "9 am", "12 pm", "3 pm", "6 pm", "9 pm"].asMap().entries.map((e) {
                                      return ClockLabel.fromIndex(
                                          idx: e.key, length: 8, text: e.value);
                                    }).toList(),
                                    labelOffset: 35,
                                    //rotateLabels: false,
                                    padding: 60,
                                    builder: (context, child){
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              textStyle: TextStyle(fontSize: 16, fontFamily: 'OpenSans'),
                                              //foregroundColor: Colors.black54, // button text color
                                            ),
                                          ),
                                          dialogTheme: const DialogTheme(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(15)))),
                                        ),
                                        child: child!,
                                      );
                                    }
                                );
                                //String timeRange=result.toString();

                                setState(() {
                                  if(result!=null){
                                    _selectedStartTime = result.startTime;
                                    _selectedEndTime = result.endTime;
                                  }
                                });
                              },
                              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              splashColor: const Color.fromRGBO(255, 192, 203, 100),
                              child: Text("${_selectedStartTime?.hour.toString().padLeft(2,'0')}"":""${_selectedStartTime?.minute.toString().padLeft(2,'0')}"
                                  " to ""${_selectedEndTime?.hour.toString().padLeft(2,'0')}"":""${_selectedEndTime?.minute.toString().padLeft(2,'0')}",
                                  style: const TextStyle(fontSize: 20, fontFamily: 'OpenSans', fontWeight: FontWeight.bold,color: Color(LOGOOrangeInt)),
                                  textAlign: TextAlign.center)
                          )),
                        ],)
                  );
                },
              ),

              actions: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child:
                  CustomButtonOrange("UPDATE",(){
                    setState(() {
                      widget.tripPlan.chosenEvents.remove(ev);
                      //widget.tripPlan.chosenEvents.add( altEvents[itemIndex]);
                      widget.tripPlan.chosenEvents.add(altEvents[currentPos]);
                      //widget.tripPlan.chosenEvents.last.startTime=ev.startTime;
                      //widget.tripPlan.chosenEvents.last.endTime=ev.endTime;//TODO: need check
                      var finalStartTime = widget.tripPlan.chosenEvents.last.startTime=ev.startTime;
                      finalStartTime = finalStartTime.subtract(Duration(hours: finalStartTime.hour, minutes: finalStartTime.minute));
                      finalStartTime = finalStartTime.add(Duration(hours: _selectedStartTime!.hour, minutes: _selectedStartTime!.minute));

                      var finalEndTime = widget.tripPlan.chosenEvents.last.endTime=ev.endTime;
                      finalEndTime = finalEndTime.subtract(Duration(hours: finalEndTime.hour, minutes: finalEndTime.minute));
                      finalEndTime = finalEndTime.add(Duration(hours: _selectedEndTime!.hour, minutes: _selectedEndTime!.minute));

                      widget.tripPlan.chosenEvents.last.startTime = finalStartTime;
                      widget.tripPlan.chosenEvents.last.endTime = finalEndTime;//TODO: need check
                      //print("event 3 time: ${widget.tripPlan.chosenEvents[2].startTime}");
                      // for(int i=0;i<3;i++){
                      //   print("event 1: ${widget.tripPlan.chosenEvents[i].eventTitle}");
                      // }
                    });
                    // Navigator.pop(context);

                    Navigator.of(context).pop();
                  }),
                ),
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            );
          });
    }
  }

  void _onSave()async{
    bool isOverlap=false;
    //todo: sort the chosen events to chronological order
    widget.tripPlan.chosenEvents.sort((a,b)=>a.startTime.compareTo(b.startTime));
    print("++++++++++++++++++++++++++++");
    for(int k=0;k<widget.tripPlan.chosenEvents.length;k++){
      Event ev=widget.tripPlan.chosenEvents[k];
      print("Chosen event ${k+1}: ${ev.eventTitle}");
      for(int i=0;i<widget.tripPlan.chosenEvents.length;i++){
        if(k!=i){

          if(ev.startTime.isBefore(widget.tripPlan.chosenEvents[i].startTime)
              &&ev.endTime.isAfter(widget.tripPlan.chosenEvents[i].startTime)
              &&ev.endTime.isBefore(widget.tripPlan.chosenEvents[i].endTime)
          ){
            isOverlap=true;
            print("overlap!");
            break;
          }
          else if (ev.startTime.isAfter(widget.tripPlan.chosenEvents[i].startTime)
              &&ev.endTime.isAfter(widget.tripPlan.chosenEvents[i].startTime)
              &&ev.endTime.isBefore(widget.tripPlan.chosenEvents[i].endTime)
          ){
            isOverlap=true;
            print("overlap!");
            break;
          }
          else if (ev.startTime.isAfter(widget.tripPlan.chosenEvents[i].startTime)
              &&ev.startTime.isBefore(widget.tripPlan.chosenEvents[i].startTime)
              &&ev.endTime.isAfter(widget.tripPlan.chosenEvents[i].endTime)
          ){
            isOverlap=true;
            print("overlap!");
            break;
          }

        }

      }
    }
    if(!isOverlap){
      print("no overlapping");

      // widget.tripPlan.chosenTransportDuration=[];
      // for (int i=0;i<widget.tripPlan.chosenEvents.length-1;i++){
      //   Event ev=widget.tripPlan.chosenEvents[i];
      //   int colIndex=widget.tripPlan.alternateEvents.indexWhere((ae)=>ae.eventTitle==ev.eventTitle);
      //   print("get colIndex: ${colIndex}");
      //   print("There are ${widget.tripPlan.mainEvents.length} main events");
      //   if(colIndex==-1){ //is an main Event
      //     colIndex=widget.tripPlan.mainEvents.indexWhere((ae)=>ae.eventTitle==ev.eventTitle);
      //   }
      //   else{
      //     colIndex+=widget.tripPlan.mainEvents.length;
      //   }
      //   Event nextEv=widget.tripPlan.chosenEvents[i+1];
      //   int rowIndex=widget.tripPlan.alternateEvents.indexWhere((ae)=>ae.eventTitle==nextEv.eventTitle);
      //   if(colIndex==-1){ //is an main Event
      //     rowIndex=widget.tripPlan.mainEvents.indexWhere((ae)=>ae.eventTitle==nextEv.eventTitle);
      //   }
      //   else{
      //     rowIndex+=widget.tripPlan.mainEvents.length;
      //   }
      //   widget.tripPlan.chosenTransportDuration.add(widget.tripPlan.allTransportDuration[rowIndex][colIndex]);
      // }

      //
      // print("Here is the transport matrix:");
      // print(widget.tripPlan.chosenTransportDuration);
      widget.user.tripPlans.removeWhere((plan) => plan.location==widget.tripPlan.location&&plan.chosenEvents==widget.tripPlan.chosenEvents);

      widget.tripPlan.tripName=_tripNameController.text;
      widget.user.tripPlans.add(widget.tripPlan);
      cache.destroy(widget.tripPlan.planId.toString());
      deletePlanHttp(widget.tripPlan);
      //widget.tripPlan=await confirmPlanHttp(widget.tripPlan);
      Future.value(confirmPlanHttp(widget.tripPlan)).then(
              (value) {
                if(value!=NULL_PLAN){
                  widget.tripPlan=value;
                  cache.write(widget.tripPlan.planId.toString(),widget.tripPlan.isFav.toString());
                }
              } );
      Navigator.of(context).pushReplacement(MaterialPageRoute<dynamic>
        (builder: (BuildContext context) => ViewTripDetailPage(user:widget.user,tripPlan: widget.tripPlan)));
      PromptMessage(context,"Trip Saved Successfully",Colors.lightGreen);
    }
    else{
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialogPopUp(context, HDR_UHOH, OVERLAP_EVENTS, false,(){});
          });
    }

  }
  _AppointmentDataSource _getCalendarDataSource() {
    //List<Appointment> appointments = <Appointment>[];
    appointments =<Appointment>[];
    var length = widget.tripPlan.chosenEvents.length;
    for(var i = 0; i < length; i++) {
      if(widget.tripPlan.chosenEvents[i].type==FLEXIBLE_TIME_EVENT) {
        appointments.add(Appointment(
          startTime: widget.tripPlan.chosenEvents[i].startTime,
          endTime: widget.tripPlan.chosenEvents[i].endTime,
          subject: widget.tripPlan.chosenEvents[i].eventTitle,
          //notes:  widget.tripPlan.chosenEvents[i].description.substring(0, widget.tripPlan.chosenEvents[i].description.length-1),
          notes: widget.tripPlan.chosenEvents[i].description,
          color: LOGOOrange,
        ));

      }
    }
    return _AppointmentDataSource(appointments);
  }

  Future<String?> _setTripName(BuildContext context) =>showDialog<String>(
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text('Name Your Trip', style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold)),
          content: TextField(
            style: TextStyle(fontFamily: 'OpenSans', fontSize: 16),
            autofocus: true,
            controller: _tripNameController,
          ),
          actions: [
            TextButton(
                onPressed:(){
                  Navigator.of(context).pop(_tripNameController.text);
                },
                child: const Text('SUBMIT', style: TextStyle(fontFamily: 'OpenSans', fontSize: 18)))
          ],
        );
      }
  );

  void _onChangeEventTime(AppointmentDragEndDetails appointmentDragEndDetails) {
    dynamic appointment = appointmentDragEndDetails.appointment!;
    CalendarResource? sourceResource = appointmentDragEndDetails.sourceResource;
    CalendarResource? targetResource = appointmentDragEndDetails.targetResource;
    DateTime? droppingTime = appointmentDragEndDetails.droppingTime;
    //fetch the details of the event currently being changed
    Event ev=widget.tripPlan.chosenEvents.firstWhere((ev) =>ev.eventTitle==appointment.subject);
    int evIndex=widget.tripPlan.chosenEvents.indexOf(ev);
    int durationHour=ev.endTime.hour-ev.startTime.hour;
    int durationMinute=ev.endTime.minute-ev.startTime.minute;
    setState(() {
      ev.startTime = droppingTime!;
      ev.endTime=droppingTime.add(Duration(hours: durationHour,minutes:durationMinute));
    });

  }


}


class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source){
    appointments = source;
  }
}

