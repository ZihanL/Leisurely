
import 'TripPlan.dart';
import 'Tag.dart';
class User{
  //Constructor
  User(this.userName,
      this.email,this.password,
      this.gender,this.birthday);

  //Fields-------------------------------------
  late int uId; //TODO: Change fetching uId
  late String userName;

  //Image _profilePic;

  //login credentials
  String email="";
  String password="";

  late DateTime birthday;
  late String gender;

  List<TripPlan> tripPlans=[];
  List<Tag> preferences=[];

}

