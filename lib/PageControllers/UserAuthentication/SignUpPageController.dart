import '../../Models/User.dart';
import '../../Toolbox/Constants.dart';

class SignUpPageController{
  SignUpPageController();

  //Model user entity
  late User user=NULL_USER;



  //Methods
  //selectable days for birthday
  bool Function(DateTime?) selectableDayPredicate()=>(DateTime? day)=>day!=null&&day.isBefore(DateTime.now());

  void dispose(){}

  void generateUser(String username, String email, String password,String gender,DateTime birthday){
    user=User(username,email,password,gender,birthday);
    //user.uId=await initUser(user);
  }

  void setUsername(String userName){
    user.userName=userName;
  }

  void setBirthday(DateTime birthday){
    user.birthday=birthday;
  }

  void setEmail(String email){
    user.email=email;
  }

  void setPassword(String password){
    user.password=password;
  }

}

