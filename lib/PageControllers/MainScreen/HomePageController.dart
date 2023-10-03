
import '../../Models/TripPlan.dart';
import '../../Models/User.dart';

class HomePageController{
  HomePageController(user){
    today=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
    pastPlans= user.tripPlans.where((cp) => cp.startDateTime.isBefore(today)).toList();
    currentPlans=user.tripPlans.where((cp) =>
    cp.startDateTime.year==today.year
        &&cp.startDateTime.month==today.month
        &&cp.startDateTime.day==today.day).toList();
    futurePlans=user.tripPlans.where((cp) => cp.startDateTime.isAfter(today)).toList();
  }
  late User user;
  late DateTime today;
  List<TripPlan> pastPlans=[];
  List<TripPlan> futurePlans=[];
  List<TripPlan> currentPlans=[];
  List<TripPlan> searchPlans=[];

  void getPlans(){
    pastPlans= user.tripPlans.where((cp) => cp.startTime.isBefore(today)).toList();
    currentPlans=user.tripPlans.where((cp) =>
    cp.startTime.year==today.year
        &&cp.startTime.month==today.month
        &&cp.startTime.day==today.day).toList();
    futurePlans=user.tripPlans.where((cp) => cp.startTime.isAfter(today)).toList();
  }

  List<TripPlan> search(String keywords){
    return user.tripPlans.where((plan) => keywords.contains(plan.tripName)
        ||keywords.contains(plan.country)
        ||keywords.contains(plan.state)
        ||keywords.contains(plan.location)
    ).toList();
  }

  List<TripPlan> filterPlans(DateTime? headDate, DateTime? endDate){
    List<TripPlan> results=searchPlans;
    if(headDate!=null){
      results.retainWhere((plan) => !plan.startTime.isBefore(headDate));
    }
    if(endDate!=null){
      results.retainWhere((plan)=>plan.startTime.isBefore(endDate));
    }
    return results;
  }
}