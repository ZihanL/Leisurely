
import 'dart:math';
import 'dart:ui';

import 'package:Leisurely/Models/Event.dart';
import 'package:Leisurely/Models/TripPlan.dart';
import 'package:flutter/material.dart';

import '../Models/Tag.dart';
import '../Models/User.dart';


//LABEL STRINGS-------------------------------------------------------------
const String CHOOSE_COUNTRY="Choose Country";
const String CHOOSE_STATE="Choose State/Province";
const String CHOOSE_CITY="Choose City";

const String TODAY_PLAN="Today";
const String FUTURE_PLAN="Future";
const String PAST_PLAN="Past";
const String FAV_PLAN="Favourite";
const String SEARCH_RESULT_PLAN="Keyword-Related Trip(s)";

const String MY_PLANS="My Plans";
const String NEW_TRIP="New Trip";
const String MY_PROFILE="My Profile";

const String RECENT_PLACE_KEYSTR="recentPlaces";
const String RECENT_SEARCH_KEYSTR="recentSearches";
const String SAVE_FAV_TRIPS="favTrips";

const String GENERATING_TRIP="Generating Your Trip";
const String CONFIRMING_TRIP="Confirming Your Trip";

const String SET_FAV="Set Favourite";
const String UNSET_FAV="Unset Favourite";
//LABEL STRINGS END -------------------------------------------------------


//Alert Box Messages -----------------------------------------------------------------------------------------------
const String HDR_WAIT="Wait...";
const String HDR_UHOH="Uh Oh";
const String MSG_FORGOT_WHERE="Please select a destination.";
String MSG_EXCEED_MAX_PREFS="Please only select up to ${MAX_SELECTED_PREFS_COUNT.toString()} other activities.";
const String MSG_LEAVE="Are you sure you want to leave?";
const String MSG_WRONG_EMAIL_FORMAT="The entered email format is not correct. It should be xxx@xxx.xxx";
const String MSG_DELETE_TRIP_HDR="Delete this trip?";
const String MSG_DELETE_TRIP_TXT="Trips cannot be recovered once deleted";
const String SAVED_TO_FAV="Trip saved to Favourites";
const String REMOVE_FROM_FAV="Trip removed from Favourites";
const String OVERLAP_EVENTS="Please fix the event time conflicts before proceeding";
const String ALREADY_EXIT_TRIP_NAME="A trip with this name already exists, please use another name";
//Alert Box Messages END ------------------------------------------------------------------------------------------


//LOGIN STRINGS
const String LOGIN_SUCCESS="Login successfully";
const String LOGIN_FAIL="Login fail";
const String OTHER_ERRORS="Other error occurs";
const String NO_PLAN="Login successfully, cannot get plan";
const int INCORRECT_CRED=-1;
const int OTHER_ERR=-2;


// Backend INFO ---------------------------------------------------------------------------------
const String xIP='ec2-3-99-226-15.ca-central-1.compute.amazonaws.com:3000';
const String IP='Leisurely-lb-80-1889731165.ca-central-1.elb.amazonaws.com:80';
//Backend INFO END ------------------------------------------------------------------------------

//Image URLS ------------------------------------------------------------------------------------
const String BAR_IMAGE="https://picsum.photos/id/395/500/300";
const String RESTAURANT_IMAGE="https://picsum.photos/id/195/500/300";
const String CAFE_IMAGE="https://picsum.photos/id/431/500/300";
const String SHOW_IMAGE="https://picsum.photos/id/452/500/300";
const String LEARN_IMAGE="https://picsum.photos/id/534/500/300";
const String GAMES_AND_PARKS_IMAGE="https://picsum.photos/id/639/500/300";
const String ARTS_AND_CULTURE_IMAGE="https://picsum.photos/id/444/500/300";
const String NATURE_IMAGE="https://picsum.photos/id/316/500/300";
const String BEACH_IMAGE="https://picsum.photos/id/215/500/300";
const String RELAX_IMAGE="https://picsum.photos/id/326/500/300";
const String SHOP_IMAGE="https://picsum.photos/id/405/500/300";
const String SURPRISE_IMAGE="https://picsum.photos/id/342/500/300";
const int MAX_BUDGET=4;
const int MIN_BUDGET=0;

//date settings -------------------------------------------------------------------
DateTime BDAY_FIRST_DATE=DateTime(DateTime.now().year-120);
DateTime BDAY_LAST_DATE=DateTime.now();

DateTime TRIP_FIRST_DATE=DateTime.now();
DateTime TRIP_LAST_DATE=DateTime.now().add(const Duration(days:7));
//date settings END ---------------------------------------------------------------

User NULL_USER=User('','','',Gender.keys.first,DateTime(2022));
Event NULL_EVENT=Event('', '', DateTime(1900), DateTime(1900), -1, '', '', '');
TripPlan NULL_PLAN=TripPlan(-1, "", "", DateTime(1900), DateTime(1900));

//Indicators -----------------------------------------------------------------------------------
//Map for gender indication
Map Gender={"male":1,"female":2,"other":3};
Map Transport={true:"Car",false:"Transit"}; //1: car, 2: public transit
Map IS_FAV={"true":true,"false":false,"":false};
const int FLEXIBLE_TIME_EVENT=1;
const int FIXED_TIME_EVENT=2;

const int MAX_SELECTED_PREFS_COUNT=8;
const int MAX_RECENT_PLACE_COUNT=10; //ScaYSTEM ONLY STORES THE 5 UNIQUE MOST RECENT SEARCHES
//Indicators END ------------------------------------------------------------------------------



List<Tag> MAIN_ACTIVITIES=[
 Tag("Surprise Me",Random().nextInt(2)+1),
 Tag("Go on a food tour",1),
 Tag("See a show",1),
 Tag("Learn something",1),
 Tag("Immerse in nature",1),
 Tag("Relax",1),
 Tag("Shop",1),
];

 List <Tag> OTHER_ACTIVITIES=[
  Tag("Food",2),
  Tag("Festivals",2),
  Tag("Fitness",2),
  Tag("DIY",2),
  Tag("Shopping",2),
  Tag( "Shows",2),
  Tag( "Nature",2),
  Tag( "Self Care",2),
 ];

 List<String> RECOMMENDED_PLACES=[
  "Waterloo | Ontario | ca      Canada",
  "Toronto | Ontario | ca      Canada",
  "Kitchener | Ontario | ca      Canada",
  "Hamilton | Ontario | ca      Canada",
  "Vancouver | British Columbia | ca      Canada",
  "Calgary | Alberta | ca      Canada",
  ];


//set color
//material color
Map<int, Color> color =
{
 50:Color.fromRGBO(247,72,154, .1),
 100:Color.fromRGBO(247,72,154, .2),
 200:Color.fromRGBO(247,72,154, .3),
 300:Color.fromRGBO(247,72,154, .4),
 400:Color.fromRGBO(247,72,154, .5),
 500:Color.fromRGBO(247,72,154, .6),
 600:Color.fromRGBO(247,72,154, .7),
 700:Color.fromRGBO(247,72,154, .8),
 800:Color.fromRGBO(247,72,154, .9),
 900:Color.fromRGBO(247,72,154, 1),
};
MaterialColor CustomPink = MaterialColor(LOGOPinkInt, color);

const int LOGOPinkInt= 0xFFF7489A;
Color LOGOPink = Color(LOGOPinkInt);
Color LOGOPinkShade = Color(0xFF78234A);
Color LOGOPinkDark = Color(0xFF381023);
const int LOGOOrangeInt= 0xFFFFAE74;
Color LOGOOrange = Color(0xFFFFAE74);