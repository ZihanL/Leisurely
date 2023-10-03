
import 'dart:convert';

import 'package:Leisurely/Models/TripPlan.dart';
import 'package:Leisurely/Models/Tag.dart';
import 'package:Leisurely/Toolbox/Constants.dart';
import 'package:geocoding/geocoding.dart' hide Location;
//import 'package:location/location.dart';
import 'package:geocode/geocode.dart';
import '../../Models/User.dart';
import '../../Toolbox/HttpClient.dart';
import 'package:flutter_cache/flutter_cache.dart' as cache;

class NewTripPageController {
  NewTripPageController(){
    for(Tag tag in OTHER_ACTIVITIES){
      selectedOtherActivities.add(tag);
    }
  }


  //Methods
  //ExpansionCallback handles the collapse and expansion of expansion panels
  //index: the index of the expansion panel in the expansion panel list
  void ExpansionCallback(int index){
    switch (index){
      case 0: //where
        whereExpanded=!whereExpanded;
        break;
      case 1: //where
        whenExpanded=!whenExpanded;
        break;
      case 2: //where
        budgetExpanded=!budgetExpanded;
         break;
      case 3: //where
        activitiesExpanded=!activitiesExpanded;
        break;
    }
  }


  String expanderDetailText(bool isExpanded, String detailText){
    String headerText="";
    if(!isExpanded){
      headerText=detailText;
    }
    return headerText;
  }



  //Function to generate plan
  //country: country name
  //city: city name
  Future<TripPlan> generatePlan()async{
    //updateRecentPlaces(); //save location to recent places
    //filter through the preference list to see which one is selected
    List<Tag> otherActivities=selectedOtherActivities.where((element) => element.isSelected).toList();

    String location=city;
    if(city==CHOOSE_CITY||city.isEmpty) {location=state;}
    if(state==CHOOSE_STATE||state.isEmpty){location=country;}

    DateTime startTime=DateTime(tripDate.year,tripDate.month,tripDate.day,startHour,startMinute);
    DateTime endTime=DateTime(tripDate.year,tripDate.month,tripDate.day,endHour,endMinute);
    if(startTime.isAfter(endTime)){ //in case start time is later than end time
      DateTime temp=endTime;
      endTime=startTime;
      startTime=temp;
    }
    TripPlan initPlan=TripPlan(user.uId,country,location,startTime,endTime,
        );
    initPlan.state=state;
    initPlan.selectedActivities.clear();
    initPlan.selectedActivities=otherActivities;
    initPlan.selectedActivities.add(selectedMainActivity);
    initPlan.transport=Transport[isByCar];
    initPlan.budget=budget;
    initPlan.imageURL=getImageUrl();
    return generatePlanHttp(user.uId,initPlan);

  }

  //
  // Future<Null> updateRecentPlaces() async{
  //   List<String> prevPlaces=recommendedPlaces;
  //   String newPlace='$city | $state | $country';
  //   if(!prevPlaces.contains(newPlace)){
  //     prevPlaces.insert(0,newPlace);
  //   }
  //   if(prevPlaces.length>MAX_RECENT_PLACE_COUNT){ //remove the least recent if quantity exceeds 5
  //     prevPlaces.removeLast();
  //   }
  //   recommendedPlaces=prevPlaces;
  //   cache.write(RECENT_PLACE_KEYSTR,recommendedPlaces);
  // }

  String getImageUrl(){
    if (selectedMainActivity.description==MAIN_ACTIVITIES[1].description){ //FOOD TOUR
      return RESTAURANT_IMAGE;
    }
    if (selectedMainActivity.description==MAIN_ACTIVITIES[2].description){ //FOOD TOUR
      return SHOW_IMAGE;
    }
    if (selectedMainActivity.description==MAIN_ACTIVITIES[3].description){ //FOOD TOUR
      return LEARN_IMAGE;
    }
    if (selectedMainActivity.description==MAIN_ACTIVITIES[4].description){ //FOOD TOUR
      return NATURE_IMAGE;
    }
    if (selectedMainActivity.description==MAIN_ACTIVITIES[5].description){ //FOOD TOUR
      return RELAX_IMAGE;
    }
    if (selectedMainActivity.description==MAIN_ACTIVITIES[6].description){ //FOOD TOUR
      return SHOP_IMAGE;
    }
    return SURPRISE_IMAGE;
  }
  //Function to get user's current location
  // Future<String?> getLocation() async {
  //   Location location = new Location();
  //   LocationData _locationData;
  //
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return null;
  //     }
  //   }
  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return null;
  //     }
  //   }
  //   _locationData = await location.getLocation();
  //   //return null string if no location found
  //   if(_locationData.latitude==null||_locationData.latitude==null){
  //     return "";
  //   }
  //
  //   List<Placemark> address = await placemarkFromCoordinates(_locationData.latitude!,_locationData.longitude!);
  //    // GeoCode geoCode = GeoCode();
  //    // Address address =
  //    //  await geoCode.reverseGeocoding(latitude: _locationData.latitude!,
  //    //      longitude: _locationData.longitude!);
  //   //print("${address.city} ${address.region} ${address.countryName}");
  //   //return "${address.city} ${address.region} ${address.countryName}";
  //   print("${address[0].subAdministrativeArea} ${address[0].administrativeArea} ${address[0].country}");
  //   return "${address[0].subAdministrativeArea} ${address[0].administrativeArea} ${address[0].country}";
  // }


  //Methods
  void dispose(){
    user=NULL_USER;
  }


  //Fields
  late User user;

  bool whereExpanded=true;
  bool whenExpanded=false;
   bool budgetExpanded=false;
  bool activitiesExpanded=false;
  bool isNewPlace=false;

  String country="";
  String state="";
  String city="";
  //LocationData? currentLocation;
  String address = "";
  DateTime tripDate=DateTime.now();
  late int startHour=DateTime.now().hour+1,endHour=23, startMinute=30, endMinute=00;
  int budget=MAX_BUDGET;
  String budgetString(){
    switch (budget){
      case 0:
        return "Free";
      case 1:
        return "\$";
      case 2:
        return "\$\$";
      case 3:
        return "\$\$\$";
      case 4:
        return "\$\$\$\$";
      default:
        return "";
    }
  }


  Tag selectedMainActivity=MAIN_ACTIVITIES[0];
  late List<Tag> selectedOtherActivities=[];
  late bool isByCar=false;
  List<String> recommendedPlaces=RECOMMENDED_PLACES; //todo: empty it afterwards


}