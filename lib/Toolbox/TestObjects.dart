import 'package:Leisurely/Models/Event.dart';

import '../Models/TripPlan.dart';
import '../Models/User.dart';
import 'Constants.dart';

List<String> SAMPLE_CITIES=['Toronto', 'Waterloo', 'Hamilton', 'London', 'Ottawa', 'Kingston','Burlington', 'Oshawa', 'Ajax'];

User ALPHA_USER=User('Alpha',
    'alpha@alpha.com','password',
    Gender.keys.first, DateTime(2022));


List <String> ALPHA_PLACES=[ "Toronto | Ontario | Canada",
"Hamilton | Ontario | Canada",
"Waterloo | Ontario | Canada"];

List<TripPlan> ALPHA_PLANS(){
  List<TripPlan>plans=[];
  for (int i=0;i<SAMPLE_CITIES.length;i++){
    TripPlan cp=TripPlan(ALPHA_USER.uId,"Canada",SAMPLE_CITIES[i], DateTime.now().add(Duration(days: ((-1)^i)*(i-2))),DateTime.now().add(Duration(days: ((-1)^i)*(i-2),hours: 10)));
    cp.tripName='Trip to ${SAMPLE_CITIES[i]}';
    //test chosenEvents
    //  Event(this.eventTitle,this.eventLink,this.startTime,this.endTime,
    //       this.type,this.description,
    //       this.address,this.venue);

    cp.mainEvents.add(Event("Test Main 1 event","link",DateTime.now(),DateTime.now().add(Duration(hours:1)),FLEXIBLE_TIME_EVENT,"This is a test event","252 philip","hello"));
    cp.mainEvents.add(Event("Test Main 2 event","link",DateTime.now().add(Duration(hours:2)),DateTime.now().add(Duration(hours:4)),FLEXIBLE_TIME_EVENT,"222222222222222223This is a test event","2 philip","hello"));
    cp.mainEvents.add(Event("Test Main 3 event","link",DateTime.now().add(Duration(hours:5)),DateTime.now().add(Duration(hours:8)),FIXED_TIME_EVENT,"3333333333333333This is a test event","3 philip","hello"));

    cp.alternateEvents.add(Event("Alternative event1","link",DateTime.now(),DateTime.now().subtract(Duration(hours:6)),FLEXIBLE_TIME_EVENT,"This is a test event","252 philip","hello"));
    cp.alternateEvents.add(Event("Alternative event2","link",DateTime.now().subtract(Duration(hours:5)),DateTime.now().subtract(Duration(hours:4)),FLEXIBLE_TIME_EVENT,"222222222222222223This is a test event","2 philip","hello"));
    cp.alternateEvents.add(Event("Alternative event3","link",DateTime.now().subtract(Duration(hours:3)),DateTime.now().add(Duration(hours:1)),FLEXIBLE_TIME_EVENT,"3333333333333333This is a test event","3 philip","hello"));

    cp.chosenEvents.add(Event("Test Chosen 1 event","link",DateTime.now(),DateTime.now().subtract(Duration(hours:6)),FLEXIBLE_TIME_EVENT,"This is a test event","252 philip","hello"));
    cp.chosenEvents.add(Event("Test Chosen 2 event","link",DateTime.now().subtract(Duration(hours:5)),DateTime.now().subtract(Duration(hours:4)),FLEXIBLE_TIME_EVENT,"This is a test event","252 philip","hello"));
    cp.chosenEvents.add(Event("Test Chosen 3 event","link",DateTime.now().subtract(Duration(hours:3)),DateTime.now().add(Duration(hours:1)),FIXED_TIME_EVENT,"This is a test event","252 philip","hello"));
    cp.imageURL=SHOW_IMAGE;
    plans.add(cp);
  }
  return plans;
}