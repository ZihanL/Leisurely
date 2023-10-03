
import '../Models/TripPlan.dart';
import '../Models/Event.dart';
import '../Models/User.dart';
import 'TestObjects.dart';
import 'HttpClient.dart';

//For testing Confirm Plan Http
// void TestConfirmPlanHttp(){
//   InitPlan confirmedPlan=InitPlan("test Plan","Canada","Ontario","Toronto", DateTime.now());
//   for(int i=0;i<3;i++){
//     Event ev=Event("Sample Event $i", "some event link",
//         DateTime.now().add(Duration(days:0,hours:i)),
//         DateTime.now().add(Duration(days:0,hours:i+1)), 1,
//         "some description",
//         "some address",
//         "some venue");
//     ev.country="some country";
//     ev.city="some city";
//     confirmedPlan.events.add(ev);
//     confirmedPlan.transportationTime.add(2);
//   }
//   confirmPlanHttp(confirmedPlan);
//   print("Test Confirm Plan Complete!!!");
// }

//For testing Generating Plan Http
void TestGeneratePlanHttp(){
  TripPlan initPlan=TripPlan(ALPHA_USER.uId,"Canada", "Toronto", DateTime(2022,07,23,8,30), DateTime(2022,07,23,22));
  generatePlanHttp(1,initPlan);
  print("Test Generate Plan Complete!!!");
}

//Test Login User
void TestLoginUser(){
  loginUser(ALPHA_USER.email,ALPHA_USER.password);
}


//Test Login User
void TestDeleteUser(){
  deleteUser(1);
}

//Test Update User
void TestUpdateUser(){
  updateUser(ALPHA_USER);
}

//Test Init User
User TestInitUser(){
  ALPHA_USER.uId=1;
  ALPHA_USER.tripPlans=ALPHA_PLANS();
  //initUser(ALPHA_USER);
  return ALPHA_USER;
}

//Test Get User
void TestGetUser(){
  getUser(1);
}





