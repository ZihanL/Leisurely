

import 'dart:convert';

import 'package:Leisurely/Toolbox/Constants.dart';
import 'package:flutter/cupertino.dart';

import '../Models/Event.dart';

Event jsonToEvent(dynamic response,DateTime date){
  //obtain each event in the event list
  late String eventTitle,eventLink,address,description,venue;
  late double cost=0;
  List<dynamic> eventTags=[];
  int type=response['Type'];
  DateTime startTime=  doubleToDateTime(response['InitialStartTime'], date);
  DateTime endTime=  doubleToDateTime(response['InitialEndTime'], date);

  if (type==FLEXIBLE_TIME_EVENT){ //1 recurring event
    response=response['EventInfoRecur'];
    eventLink="";
    eventTitle=response['name'];
    address=response['formatted_address'];
    description= response["Tag"]; //TODO: check description
    venue="";
    eventTags.add(response["Tag"]);
    //cost=0;
  }
  else if (type==FIXED_TIME_EVENT){ //2 pop event
    response=response['EventInfoPop'];

    eventLink=response['Link'];
    eventTitle=response['Title'];
    address=response['Address'].toString();

    // startTime=doubleToDateTime(response['StartTime'], date);
    // startTime=doubleToDateTime(response['EndTime'], date);
    venue=response['Venue'];
    description=response['Description'];
    eventTags=response['EventTags'];
  }
  // if(eventTitle.isEmpty){
  //   return NULL_EVENT;
  // }
  print("Event title: $eventTitle");
  Event ev=Event(eventTitle,eventLink,startTime, endTime, type, description, address, venue);
  ev.eventTags=eventTags;
  return ev;
}

double dateTimeToDouble(DateTime time){
  double doubleTime=(time.hour*100+time.minute)/100;
  return doubleTime;
}

DateTime doubleToDateTime(num doubleTime, DateTime date){
  int hour=doubleTime.floor();
  num minute=(doubleTime-hour)*100;
  return DateTime(date.year,date.month,date.day,hour,minute.floor());

}

String dateTimeToString(DateTime date){
  return date.toString().substring(0,10);
}

String fetchImageURLFromTag(String tag){
  switch (tag){
    case "restaurant":
      return RESTAURANT_IMAGE;
    case "shopping mall":
      return SHOP_IMAGE;
    case "museum":
      return ARTS_AND_CULTURE_IMAGE;
    case "live house":
      return SHOW_IMAGE;
    case "cafe":
      return CAFE_IMAGE;
    case "bar":
      return BAR_IMAGE;
    case "gallery":
      return ARTS_AND_CULTURE_IMAGE;
    case "theme park":
      return GAMES_AND_PARKS_IMAGE;
    case "farm":
      return NATURE_IMAGE;
    case "spa":
      return RELAX_IMAGE;
    case "nail salons":
      return RELAX_IMAGE;
    case "boutiques":
      return SHOP_IMAGE;
    case "beach":
      return BEACH_IMAGE;
    default:
      return SURPRISE_IMAGE;

  }
}

