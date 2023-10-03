import '../../Models/User.dart';
import '../../Toolbox/Constants.dart';

class MyProfilePageController{
  MyProfilePageController(); //CONSTRUCTOR


  late User user;

  bool isSignedIn=true;

  //Methods
  void dispose(){
    user=NULL_USER;
  }
}