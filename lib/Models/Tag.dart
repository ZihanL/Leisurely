//Preference class

class Tag{
  Tag(this.description,this.eventType);
  String description="";
  bool isSelected=false;
  int eventType;
  int count=1;

  Map toJson(){
    return{
      "description": description,
      "eventType":eventType,
      "count":count
    };
  }

}