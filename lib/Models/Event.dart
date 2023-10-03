

import 'dart:convert';

import 'package:Leisurely/Toolbox/ConversionTools.dart';

import 'Tag.dart';

//Event class
class Event{
  Event(this.eventTitle,this.eventLink,this.startTime,this.endTime,
      this.type,this.description,
      this.address,this.venue);
  late int eventID;
  int type;
  late String eventTitle="";
  String eventLink;
  String description;
  late String address;
  String city="";
  String country="";
  String venue;
  String imageURL="";
  DateTime startTime;
  DateTime endTime;
  late int planID;
  late List<dynamic> eventTags=[];

  Map<String, dynamic> toJson() {
    if(description.isEmpty){
      for(dynamic et in eventTags){
        String tags = eventTags.toString();
        description+= tags.substring( 1, tags.length - 1);
      }
    }
    return {
      "Type": type,
      "Title": eventTitle,
      "Link": eventLink,
      "Description": description,
      "Address": [address,"$city $country"],
      "Venue": venue,
      "Image": imageURL,
      "StartTime": dateTimeToDouble(startTime),
      "EndTime": dateTimeToDouble(endTime),
      "EventTags":eventTags
    };
  }
}