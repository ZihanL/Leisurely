
import '../../Models/User.dart';
import '../../Toolbox/HttpClient.dart';

class EditInfoPageController{
  EditInfoPageController();

  //Model user entity
  late final User user;

  late String displayGender;
  //Methods
  //selectable days for birthday
  bool Function(DateTime?) selectableDayPredicate()=>(DateTime? day)=>day!=null&&day.isBefore(DateTime.now());

  void dispose(){}

  void setUsername(String userName){
    user.userName=userName;
  }

  void setBirthday(DateTime birthday){
    user.birthday=birthday;
  }

  void updateUserInfo(){

    //Update the user's preference list
    user.preferences.clear();
    updateUser(user);
  }
}

