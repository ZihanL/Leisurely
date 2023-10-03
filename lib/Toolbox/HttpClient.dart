

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cache/flutter_cache.dart' as cache;
import 'package:dio/dio.dart';
import 'package:Leisurely/Models/TripPlan.dart';
import 'package:Leisurely/Models/Event.dart';
import '../Models/Tag.dart';
import '../Models/User.dart';
import 'Constants.dart';
import 'ConversionTools.dart';


String initUserUrl="http://$IP/v1/initUser";
String getUserUrl='http://$IP/v1/users/uid/';
String updateUserUrl="http://$IP/v1/updateUser";
String deleteUserUrl="http://$IP/v1/deleteAccount/";

String generatePlanUrl="http://$IP/v1/GeneratePlanFree/";
String confirmPlanUrl="http://$IP/v1/confirmPlan/";
String deletePlanUrl="http://$IP/v1/deletePlan/";
String loginUrl="http://$IP/v1/userLogin/";

String getTagsUrl="http://$IP/v1/getTags/";

Future<int> initUser(User user)async {
  try {
    Map<String,dynamic> params={
      "username":user.userName,
      "email":user.email,
      "password":user.password,
      "birthday":user.birthday.toString().substring(0,10),
      "gender":Gender[user.gender]};
    print(params);
    var response = await Dio().post(initUserUrl, data: params);
    final parsedResponse=jsonDecode(response.toString());
    int uId=parsedResponse['UID'];
    return uId;
  }
  catch(e) {
    print(e);
    return -1;
  }
}

Future<User> getUser(int uId) async{
  try{
    var response= await Dio().get(getUserUrl+uId.toString());


    final parsedResponse=jsonDecode(response.toString())['user'];
    //populate user data and load
    User user=User(parsedResponse["UserName"],
        parsedResponse["Email"],parsedResponse["Password"],
        Gender.keys.firstWhere((g) =>Gender[g]==parsedResponse["Gender"] ).toString(),
        DateTime.parse(parsedResponse["Birthday"])); //TODO: Fetch user plans
    user.uId=parsedResponse['UID'];

    user.tripPlans=getUserPlans(user.uId,response.toString());
    // for(TripPlan tp in user.tripPlans){
    //   tp.isFav=await cache.remember(tp.planId.toString(),tp.isFav.toString());
    // }
    return user;
  }
  catch(e){
    print(e);
    return NULL_USER;
  }
}

void updateUser(User user) async{
  try {
    print(user.uId);
    var response = await Dio().post(updateUserUrl, data: {
      "uid":user.uId,
      "username":user.userName,
      "password":user.password,
      "birthday":user.birthday.toString().substring(0,10),
      "gender":Gender[user.gender]});
    print(response);
  }
  catch(e) {
    print(e);
  }
}

void deleteUser(int uId)async{
  try{
    var response=await Dio().delete(deleteUserUrl+uId.toString());
    print(response);
  }
  catch (e){
    print(e);
  }
}


Future<User> loginUser(String email, String password) async{
  try{
    var response=await Dio().get("$loginUrl$email/$password");
    //TODO: Determine if user is existing
    String message=jsonDecode(response.toString())["message"];
    User user=NULL_USER;
    switch(message){
      case LOGIN_SUCCESS:
        final parsedUserInfo=jsonDecode(response.toString())["user"];
        print(parsedUserInfo);
        user=User(parsedUserInfo["UserName"],
            parsedUserInfo["Email"],parsedUserInfo["Password"],
            Gender.keys.firstWhere((g) =>Gender[g]==parsedUserInfo["Gender"] ).toString(),
            DateTime.parse(parsedUserInfo["Birthday"]));
        user.uId=parsedUserInfo["UID"];
        user.tripPlans=getUserPlans(user.uId,response.toString());
        // for(TripPlan tp in user.tripPlans){
        //   tp.isFav=IS_FAV[await cache.remember(tp.planId.toString(),tp.isFav)];
        // }
        break;
      case LOGIN_FAIL:
        user.uId=INCORRECT_CRED;
        break;
      case OTHER_ERRORS:
        user.uId=OTHER_ERR;
        break;
      case NO_PLAN:
        final parsedUserInfo=jsonDecode(response.toString())["user"];
        print(parsedUserInfo);
        user=User(parsedUserInfo["UserName"],
            parsedUserInfo["Email"],parsedUserInfo["Password"],
            Gender.keys.firstWhere((g) =>Gender[g]==parsedUserInfo["Gender"] ).toString(),
            DateTime.parse(parsedUserInfo["Birthday"]));
        user.uId=parsedUserInfo["UID"];
        break;
    }
    return user;
  }
  catch(e){
    print(e);
    return NULL_USER;
  }

}

Future<bool> checkUser(String email) async{
  try{
    var response= await Dio().get(getUserUrl+email);

    print(response);
    final parsedResponse=jsonDecode(response.toString());
    //populate user data and load
    String account=parsedResponse["Email"];
    return account.isEmpty?false:true;
  }
  catch(e){
    print(e);
    return false;
  }
}

List<TripPlan> getUserPlans(int uId,String jsonResponse){
  List<TripPlan> tripPlans=[];
  print("ready to parse plans");
  int planCount=jsonDecode(jsonResponse)['PlanNum'];
  print("Plan Count: $planCount");
  final parsedPlans=jsonDecode(jsonResponse.toString())['plan'];

  print("parsing plans now");
  for(int i=0;i<planCount;i++){
    print("================Plan ${i+1}: =============================");
    var tripJson=parsedPlans[i];
    DateTime tripDate=DateTime.parse(tripJson['Time']);
    print("TripDate: ${tripDate.toString()}");
    String country=tripJson['Country'];
    print("Country: $country");
    String location=tripJson['Location'];
    // List<String> locationWords=location.split(RegExp(r'[a-z]'));
    // location="";
    // for(String word in locationWords){
    //   location+=word;
    //   location+=" ";
    // }
    // location=location.trim();
    print("Location: $location");
    int eventCount=tripJson['EventNum'];
    print("Event Count: $eventCount");
    String tripName=tripJson['PlanName'];
    print("Plan Name: $tripName");
    int planId=tripJson['PlanID'];

    TripPlan tp=TripPlan(uId, country, location, tripDate,tripDate.add(const Duration(days:1)).subtract(const Duration(seconds:2)));
    tp.planId=planId;
    tp.tripName=tripName;
    var eventsJson=tripJson['Events'];
    for(int j=0;j<eventCount;j++){
      print("   Event ${j+1}: ------------------ ");
      var evJson=eventsJson[j];
      String eventTitle=evJson['Title'];
      print("Title: $eventTitle");
      String eventLink=evJson['Link'];
      print("Link: $eventLink");
      DateTime startTime=doubleToDateTime(evJson['StartTime'], tripDate);
      print("StartTime: ${startTime.toString()}");
      DateTime endTime=doubleToDateTime(evJson['EndTime'], tripDate);
      print("EndTime: ${startTime.toString()}");
      int type=evJson['Type'];
      print("Type: $type");
      String description=evJson['Description'];
      print("Description: $description");
      String address=evJson['Address'];
      print("Address: $address");
      String venue=evJson['Venue'];
      print("Venue: $venue");
      dynamic eventTagDes=evJson['EventTagDes'];
      if(eventTagDes.length==1){
        tp.imageURL=fetchImageURLFromTag(eventTagDes[0]['Description']);
      }
      Event ev=Event(eventTitle, eventLink, startTime, endTime, type, description, address, venue);
      tp.chosenEvents.add(ev);
    }
    tripPlans.add(tp);

  }
  print("Finished fetching all plans yay!");
  return tripPlans;
}
//Back-end generates plan for the user
Future<TripPlan> generatePlanHttp(int uId, TripPlan initPlan)async{
  try {
    String tempLocation=initPlan.location;
    String tempCountry=initPlan.country.substring(6).trim();
    Map<String,dynamic> params={
      "startTime": dateTimeToDouble(initPlan.startTime),
      "endTime": dateTimeToDouble(initPlan.endTime),
      "date": DateFormat('MMM dd').format(initPlan.startTime),
      "location": tempLocation.replaceAll(" ", ""),
      "country": tempCountry.replaceAll(" ", ""),
      "transport": initPlan.transport,
      "BudgetLevel":initPlan.budget,
      "tags":initPlan.selectedActivities.map((v) => v.toJson()).toList(),
    };
    print(params);
    var response = await Dio().post("$generatePlanUrl$uId",
        data: params,
        options: Options(
          headers:{HttpHeaders.contentTypeHeader: 'application/json'},
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          validateStatus: (statusCode){
            if(statusCode == null){
              return false;
            }
            if(statusCode == 422){ // your http status code
              return true;
            }else{
              return statusCode >= 200 && statusCode < 300;
            }
          },),
    );

    var parsedResponse=jsonDecode(response.toString())['data']['Schedule'];
    int totalEventCount=parsedResponse['MaxEvents'];//denotes the total event count in this plan


    // for loop to parse main event
    for (int i=0;i<totalEventCount;i++){
      //Step 1. parse event information
      var eventInfo=parsedResponse['Events'][i];
      Event ev=jsonToEvent(eventInfo,initPlan.startTime);
      // if(ev!=NULL_EVENT){
      //   initPlan.mainEvents.add(ev);
      // }

      print("Main Event ${i+1}: ${ev.eventTitle},${ev.startTime} to ${ev.endTime}");

    }


    //Step 2: for loop to parse transportation
    int addressCount=parsedResponse['TMatrix']['origin_addresses'].length;
    print("Total count of events: $addressCount");
    var transportInfo=parsedResponse['TMatrix']['rows'];
    for(int row=0;row<addressCount;row++){
      initPlan.allTransportDuration.add(<int>[]);
      initPlan.allTransportDistance.add(<int>[]);
      for (int col=0;col<addressCount;col++) {
        initPlan.allTransportDuration[row].add(
            transportInfo[row]['elements'][col]['distance']['value']);
        initPlan.allTransportDistance[row].add(
            transportInfo[row]['elements'][col]['duration']['value']);
      }
      print(initPlan.allTransportDuration[row]);
    }


    // for loop to parse alternative event
    var alEvents=jsonDecode(response.toString())['data']['Alternative'];
    if (alEvents!=null){
      print("Alternative not null");
      totalEventCount=alEvents.length;
      for (int i=0;i<totalEventCount;i++){
        Event ev=jsonToEvent(alEvents[i],initPlan.startTime);
        initPlan.alternateEvents.add(ev);
        print("Alt Event ${i+1}: ${ev.eventTitle},${ev.startTime} to ${ev.endTime}");
      }
    }
    else{
      print("Alternative is null");
    }

  }
  catch(e) {
    print(e);
    return NULL_PLAN;
  }

  return initPlan;
}

//user submits plan to back-end
//TODO: How to make sure this confirmed plan belongs to this user only?
Future<TripPlan> confirmPlanHttp(TripPlan confirmedPlan) async{
  try {
    Map<String,dynamic> params={
      "UID":confirmedPlan.userId,
      "planname":confirmedPlan.tripName,
      "country":confirmedPlan.country,
      "location":confirmedPlan.location,
      "Time": DateFormat('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'').format(confirmedPlan.startTime),
      "Events":confirmedPlan.chosenEvents.map((v) => v.toJson()).toList(),
      "Transport":confirmedPlan.chosenTransportDuration,
    };
    print(params);
    print("==============================");
    var response = await Dio().post(confirmPlanUrl, data: params);
    //TODO: add in image URL
    //print(response);
    confirmedPlan.imageURL=fetchImageURLFromTag(jsonDecode(response.toString())['tag']);
    confirmedPlan.planId=jsonDecode(response.toString())['planID'];
    //print(confirmedPlan.imageURL);
    return confirmedPlan;
  }
  catch(e) {
    print(e);
    return NULL_PLAN;
  }
}

void deletePlanHttp(TripPlan tripPlan) async{
  var response = await Dio().post("$deletePlanUrl${tripPlan.planId}",
  options: Options(
    headers:{HttpHeaders.contentTypeHeader: 'application/json'},
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
    validateStatus: (statusCode){
      if(statusCode == null){
        return false;
      }
      if(statusCode == 422){ // your http status code
        return true;
      }else{
        return statusCode >= 200 && statusCode < 300;
      }
    },));


}
