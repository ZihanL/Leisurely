

import 'package:Leisurely/Models/Tag.dart';
import 'package:Leisurely/Toolbox/Constants.dart';

import '../Toolbox/ConversionTools.dart';
import 'Event.dart';
import 'Tag.dart';

class TripPlan{
  TripPlan(this.userId,this.country,this.location,
      this.startTime, this.endTime);

  late int userId; //user UID
  late int planId=0;
  //USER INPUT FIELDS TO CREATE NEW TRIP---------------------------
  late String location=''; //location can be city, state (if no city), or country (if no city and no state)
  late String state='';
  late String country='';
  late DateTime startTime,endTime;
  // late double minBudget,maxBudget;
  late String transport; //1 is car, 2 is public transit
  late List<Tag> selectedActivities=[];
  late int budget=0;
  //USER INPUT FIELDS TO CREATE NEW TRIP ---------------------------------



  //BACK-END GENERATED FIELDS ----------------------------------
  late List<Event> mainEvents=[];
  late List<Event> alternateEvents=[];
  //Transportation duration is an integer in seconds
  late List<List<int>> allTransportDuration=[];
  //Transportation distance is integer in meters
  late List<List<int>> allTransportDistance=[];
  //BACK-END GENERATED FIELDS ----------------------------------

  //USER CONFIRM FIELDS -----------------------------------------
  late String tripName="$location Trip ${dateTimeToString(startTime!)}";
  bool isFav=false;
  late String imageURL=SURPRISE_IMAGE;
  late List<Event> chosenEvents=[];
  late List<int> chosenTransportDuration=[]; //unit in seconds
  //USER CONFIRM FIELDS -----------------------------------------
}
