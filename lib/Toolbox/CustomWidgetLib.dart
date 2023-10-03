
import 'package:Leisurely/PageViews/MainScreen/EditTripDetailPage.dart';
import 'package:Leisurely/PageViews/MainScreen/ViewTripDetailPage.dart';
import 'package:Leisurely/PageViews/MainScreenView.dart';
import 'package:Leisurely/PageViews/UserAuthentication/LoginPage.dart';
import 'package:Leisurely/PageViews/UserAuthentication/SignUpPage.dart';
import 'package:Leisurely/Toolbox/TestCodes.dart';
import 'package:Leisurely/Toolbox/TestObjects.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:Leisurely/Toolbox/ConversionTools.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../Models/TripPlan.dart';
import '../Models/Tag.dart';
import '../Models/Event.dart';
import '../Models/User.dart';
import '../PageViews/ObsoletePages/xxxDetailedTripPage.dart';
import 'Constants.dart';
import 'package:flutter/material.dart';
import 'package:time_interval_picker/time_interval_picker.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'HttpClient.dart';



Widget LabelWrapper(String label, Widget widget) {
  return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
              label,
              style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              )),
          widget,
        ],
      ));
}

Widget LightLabelWrapper(String label, Widget widget) {
  return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
              label,
              style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: 'OpenSans',
                  //fontWeight: FontWeight.bold,
                  fontSize: 18
              )),
          widget,
        ],
      ));
}

//Email Entry Field
Widget EmailField(TextEditingController emailController) {
  return TextFormField(
    decoration: const InputDecoration(
      border: UnderlineInputBorder(),
    ),
    controller: emailController,
    // The validator receives the text that the user has entered.
    validator: (value) {
      //TODO: account email validator
      if (value == null || value.isEmpty) {
        return 'Please enter your email';
      }
      return null;
    },
  );
}

//Password Entry Field
Widget PasswordField(
    TextEditingController passwordController, Function onSubmit, bool isConfirm,
    {String? password}) {
  return Container(
      padding: const EdgeInsets.only(top: 5),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        controller: passwordController,
        onSaved: (value) => {
          if (!isConfirm) {onSubmit(value)}
        },
        // The validator receives the text that the user has entered.
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          } else if (isConfirm && value != password) {
            return "Password mismatches the previous input";
          }
          return null;
        },
  ));
}

//TextForm Field Template
Widget TextBox(TextEditingController textController, Function onSaved) {
  return Container(
    padding: const EdgeInsets.only(top: 5),
    child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        controller: textController,
        onSaved: (value) => onSaved(value),
  )
  );
}

//Button Template
Widget CustomButton(String displayText, Function onPress) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 10),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: LOGOPink,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // <-- Radius
        ),
      ),
      onPressed: () => onPress(),
      child: Text(
        displayText,
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'OpenSans', fontSize: 18),
      ),
    ),
  );
}

Widget CustomButtonOrange(String displayText, Function onPress) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 10),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: LOGOOrange,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // <-- Radius
        ),
      ),
      onPressed: () => onPress(),
      child: Text(
        displayText,
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'OpenSans', fontSize: 18),
      ),
    ),
  );
}

Widget CustomRadioListTile(String label, bool selfValue, bool groupValue, Function onChanged){
  return Container(
      height: 45,
      child: RadioListTile(
          activeColor: CustomPink,
          title: Text(label,
              style: TextStyle(
                  fontFamily: 'OpenSnas',
                  fontSize: 18)),
          value: selfValue,
          groupValue: groupValue,
          onChanged: (value)=>onChanged(value))
  );
}

//Drop Down Menu
Widget CustomDropDownMenu(BuildContext context, List<dynamic> items,
    dynamic displayVal, Function onChanged) {
  return Container(
    child: DropdownButton(
      isDense: true,
      isExpanded: true,
      value: displayVal,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 20,
      style: const TextStyle(fontSize:16, fontFamily: 'OpenSans', color: Color(LOGOPinkInt)),
      underline: Container(
        height: 2,
        color: LOGOPink,
        //width: 2,
      ),

      onChanged: (dynamic val) => onChanged(val),
      items: items.map((dynamic item) {
        return DropdownMenuItem<String>(
            value: item,
            child: Container(
              child:
                Text(
                  item.toString(),
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                )
            ));
      }).toList(),
    ),
  );
}


Widget CSC_Picker(BuildContext context,Key dropdownState,Function setCountry, Function setState,
    Function setCity) {
    return Center(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: SelectState(
              //Adding CSC Picker Widget in app
              //triggers once country selected in dropdown
              key: dropdownState,
              onCountryChanged: (value) => setCountry(value),
              onStateChanged: (value) => setState(value),
              onCityChanged: (value) => setCity(value),
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 16,
              ),
            ),
          ));
}

//Date Picker Template
Widget DatePicker(BuildContext context, TextEditingController dateController,
    Function setState, DateTime firstDate, DateTime lastDate) {
  return InkWell(
    onTap: () async {
      final DateTime? selectedDate = await showDatePicker(
        helpText: 'SELECT YOUR DATE',
        fieldLabelText: 'CHOSEN DATE',
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: firstDate,
        lastDate: lastDate,
        builder: (context, child){
          return Theme(
            data: Theme.of(context).copyWith(
              // colorScheme: ColorScheme.light(
              //   // surface: Colors.red,
              //   // primary: Colors.amber,
              //   // Title, selected date and month/year picker color (dark and light mode)
              //   // onSurface: Colors.black,
              //   // onPrimary: Colors.black,
              // ),
              textTheme: TextTheme(
                  headlineMedium: TextStyle(fontSize: 24, fontFamily: 'OpenSans'),// Selected Date landscape
                  titleLarge: TextStyle(fontSize: 14, fontFamily: 'OpenSans'), // Selected Date portrait
                  //labelSmall: TextStyle(fontSize: 14, fontFamily: 'OpenSans'), // Title - SELECT DATE
                  bodyLarge: TextStyle(fontSize: 18, fontFamily: 'OpenSans'), // year gridbview picker
                  titleMedium: TextStyle(fontSize: 18, fontFamily: 'OpenSans', color: Colors.black87), // input
                  titleSmall: TextStyle(fontSize: 14, fontFamily: 'OpenSans'), // month/year picker
                  bodySmall: TextStyle(fontSize: 16, fontFamily: 'OpenSans'), // days
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  textStyle: TextStyle(fontSize: 16, fontFamily: 'OpenSans'),
                  //foregroundColor: Colors.black54, // button text color
                ),
              ),
              dialogTheme: const DialogTheme(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
            ),
            child: child!,
          );
        }
      );

      if (selectedDate != null) {
        setState(selectedDate);
      }
    },
    customBorder:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    splashColor: const Color.fromRGBO(255, 192, 203, 100),
    child: SizedBox(
      height: 35,
      width: double.maxFinite,
      child: Text(dateController.text,
        style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold, fontFamily: 'OpenSans', color: Color(LOGOPinkInt)),)
    ),
  );
}


//Checkboxes
Widget CheckBox(
    BuildContext context, String label, bool isChecked, Function onChanged) {
  return CheckboxListTile(
      title: Text(label, style: TextStyle(fontFamily: 'OpenSans')),
      value: isChecked,
      onChanged: (isChecked) => onChanged(isChecked));
}

List<Widget> TagTabs (List<Tag> preferences,
    Function onSelect) {
  List<Widget> chips = [];
  for (int i = 0; i < preferences.length; i++) {
    Widget item = FilterChip(
      label: Text(
          preferences[i].description,
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: preferences[i].isSelected? FontWeight.bold:FontWeight.normal,
              color: preferences[i].isSelected? Colors.white:Colors.black87)
      ),
      selectedColor: LOGOPink,
      checkmarkColor: Colors.white,
      selected: preferences[i].isSelected,
      onSelected: (bool value) {
        preferences[i].isSelected=value;//mark current selection
        onSelect(i);
      },
      disabledColor: Colors.black26,
    );
    chips.add(item);
  }

  return chips;
}

//Expansion Panel
ExpansionPanel Expander(BuildContext context, bool isExpanded,
    String headerLabel, Widget bodyWidget) {
  return ExpansionPanel(
    headerBuilder: (BuildContext context, bool isExpanded) {
      return ListTile(
        title: Text(headerLabel,
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                fontSize: 18)),
      );
    },
    body: bodyWidget,
    isExpanded: isExpanded,
    canTapOnHeader: true,

  );
}

Widget SingleTripCard(BuildContext context,User user, TripPlan trip,bool isInMainSection, Function onDelete){
  return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child:Slidable(
            enabled: isInMainSection,
            startActionPane: ActionPane(
              // A motion is a widget used to control how the pane animates.
              motion: const DrawerMotion(),
              extentRatio: 0.3,
              // A pane can dismiss the Slidable.
              //dismissible: DismissiblePane(onDismissed: () {}),

              // All actions are defined in the children parameter.
              children: [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  onPressed: (context)=>onDelete(context,trip),
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  icon: Icons.delete_rounded, //TODO: add edit icon?
                  //label: 'Delete',
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.3,
              // A pane can dismiss the Slidable.
              //dismissible: DismissiblePane(onDismissed: () {}),

              // All actions are defined in the children parameter.
              children: [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  onPressed: (context)=>Navigator.of(context).
                  push(MaterialPageRoute(builder: (context) =>
                      EditTripDetailPage(user:user,tripPlan:trip,isConfirmed:true))),
                  backgroundColor: LOGOPink,
                  foregroundColor: Colors.white,
                  icon: Icons.edit, //TODO: add edit icon?
                  //label: 'Delete',
                ),
              ],
            ),

            child: Stack(
              children:[
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        //color: CustomPink[600],
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10))
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          trip.tripName,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            //fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 3),
                        Text(
                          dateTimeToString(trip.startTime),
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ),

                Ink.image(
                  image: NetworkImage(trip.imageURL),
                  height: 140,
                  fit: BoxFit.cover,
                  child: InkWell(
                      hoverColor: LOGOOrange,
                      splashColor: LOGOOrange,
                      //TODO: link on tap to display new trip detail
                      onTap: () =>Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewTripDetailPage(user: user, tripPlan: trip)))
                  ),
                ),
              ],
            ),

          )

      )
  );
}

Widget TripCardStack(BuildContext context,User user, List<TripPlan> plans, String typeOfPlans,Function onDelete){
  return FutureBuilder(
      future:Future((){return plans.isEmpty;}),
      builder:(context,snapshot){
          //display the list of plans if there are plans
          if (snapshot.data==false){
            return Container(
                padding: const EdgeInsets.all(10),
                child:  ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: plans.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index)=>
                      SingleTripCard(context,user,plans[index],typeOfPlans==SEARCH_RESULT_PLAN?false:true,onDelete),
                ),
            );
          }
          //otherwise display prompt text
          return Center(child: Text("No Trip for $typeOfPlans", style: TextStyle(fontFamily: 'OpenSans', color: Colors.black54),));
        });
}

Widget TripCardCarousel(BuildContext context,User user,List<TripPlan> plans, String typeOfPlans){
  return FutureBuilder(
      future:Future((){return plans.isEmpty;}),
      builder:(context,snapshot){
        //display the list of plans if there are plans
        if (snapshot.data==false){
          CarouselController _controller=CarouselController();
          return Container(
              padding: const EdgeInsets.only(top: 5),

              child: CarouselSlider.builder(
                carouselController: _controller,
                itemCount: plans.length,
                itemBuilder: (context, itemIndex, pageViewIndex) =>
                    SingleTripCard(context, user,plans[itemIndex],false,(){}),
                options: CarouselOptions(
                  height: 140,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                ),
              ),
          );
        }
        //otherwise display prompt text
        return Container(
            height: 140,
            alignment: Alignment.center,
            child: Text("No $typeOfPlans", style: const TextStyle(fontFamily: 'OpenSans', color: Colors.black54) )
        );
      });

}

void PromptMessage(BuildContext context, String message,Color bgc) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        backgroundColor: bgc,
        content: Text(message),
    ),
  );
}

AlertDialog AlertDialogPopUp(BuildContext context,String title, String message,bool cancelEnabled,
    Function onOKPressed,[dynamic params]){
  return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
    title:Text(title, style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold),),
    content: Text(message, style: TextStyle(fontFamily: 'OpenSans', fontSize: 16)),
    actions:[
      TextButton(
          onPressed: ()=>cancelEnabled?onOKPressed(params!):Navigator.pop(context),
          child: const Text("OK", style: TextStyle(fontFamily: 'OpenSans', fontSize: 18))),
      TextButton(
          onPressed: cancelEnabled? ()=>Navigator.pop(context):null,
          child: const Text("CANCEL", style: TextStyle(fontFamily: 'OpenSans', fontSize: 18)),
      ),
    ]
  );
}

AlertDialog NameTripDialog(BuildContext context, TextEditingController controller){
  return AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))),
    title: const Text('Name Your Trip', style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold),),
    content: TextField(
      style: TextStyle(fontFamily: 'OpenSans', fontSize: 16),
      autofocus: true,
      controller: controller,
      ),
    actions: [
      TextButton(
          onPressed:(){
            Navigator.of(context).pop(controller.text);
          },
          child: const Text('SUBMIT', style: TextStyle(fontFamily: 'OpenSans', fontSize: 18)))
    ],
  );
}

Widget LoadingVisual(BuildContext context,String loadingText){
  return  Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const Padding(padding: EdgeInsets.symmetric(vertical:10)),
        Text(loadingText, style: TextStyle(fontFamily: 'OpenSans', color: Colors.black54)),
      ],
    ),
  );
}

Widget AlternativeEventsSelector(BuildContext context,List<Event> altPlans,Function _onTripSelect){
  CarouselController _controller=CarouselController();
  return Container(
    padding: const EdgeInsets.all(20),
    child: CarouselSlider.builder(
      carouselController: _controller,
      itemCount: altPlans.length,
      itemBuilder: (context, itemIndex, pageViewIndex) =>
          Column(
            children: [
              Text(altPlans[itemIndex].eventTitle),
              Text(altPlans[itemIndex].address),
              Text(altPlans[itemIndex].description),
              CustomButton("Select",_onTripSelect),
            ],
          ),
      options: CarouselOptions(
        autoPlay: false,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        aspectRatio: 2,
        initialPage: 0,
        enableInfiniteScroll: false,
        enlargeStrategy: CenterPageEnlargeStrategy.height,
      ),
    ),
  );
}

Widget CannotDisplayVisual(BuildContext context, String promptText,String pageType,Widget page){
  return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar:AppBar(),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          height: 200,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              Row(children: [
                Text(promptText,
                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 18, fontWeight: FontWeight.bold),),
              ],),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: Text("Press the button to go back to the $pageType Page", style: TextStyle(fontFamily: 'OpenSans')))
                ],),
              CustomButton(
                  "BACK",
                      (){
                    Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) =>  page,
                      ),
                          (route) => false,//if you want to disable back feature set to false
                    );
                  })
            ],
          ),
        ),
      )
  );
}