
import 'dart:async';

import 'package:Leisurely/PageViews/MainScreen/HomePage.dart';
import 'package:Leisurely/PageViews/MainScreenView.dart';
import 'package:flutter/material.dart';
import 'package:Leisurely/Toolbox/ConversionTools.dart';
import 'package:geocode/geocode.dart';

import '../../Models/TripPlan.dart';
import '../../Models/Tag.dart';
import '../../Models/User.dart';
import '../../Toolbox/Constants.dart';
import 'package:Leisurely/PageControllers/MainScreen/NewTripPageController.dart';


import '../../Toolbox/CustomWidgetLib.dart';
import '../ObsoletePages/xxxDetailedTripPage.dart';
import 'package:time_range_picker/time_range_picker.dart';

import 'EditTripDetailPage.dart';
import 'ViewTripDetailPage.dart';
//import 'package:modal_progress_hud/modal_progress_hud.dart';

class NewTripPage extends StatefulWidget {
  const NewTripPage({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  _NewTripPageState createState() => _NewTripPageState();
}

class _NewTripPageState extends State<NewTripPage> {
  final _formKey = GlobalKey<FormState>();
  final NewTripPageController _pageController= NewTripPageController();
  final _dropdownState = GlobalKey<FormFieldState>();
  bool _isLoading=false;

  final TextEditingController _dateController=TextEditingController();
  @override
  void initState() {
    super.initState();
    _pageController.user=widget.user;
    _dateController.text=dateTimeToString(DateTime.now());

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.navigate_before_rounded, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title:const Text("Create New Trip"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _isLoading?null:_generatePlan,
            icon: const Icon(Icons.check_rounded),
            disabledColor: Colors.black12,

          )
        ],
      ),
      body:SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: _isLoading? LoadingVisual(context,GENERATING_TRIP): Form(
          key:_formKey,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            //color: Colors.pink.shade50,
            child:
              ExpansionPanelList(
                expandedHeaderPadding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                elevation: 1,
                expansionCallback: (int index, bool isExpanded) {
                  setState(()=>_pageController.ExpansionCallback(index));},
                children: [
                  //1. Where
                  Expander(context, _pageController.whereExpanded, 'Where: '
                      '${_pageController.expanderDetailText(_pageController.whereExpanded, _pageController.city)}',
                      Column(
                        children: [
                          //CustomButton("Get current location", _pageController.getLocation),
                          CustomRadioListTile("Recommended Places",
                              false,_pageController.isNewPlace, _toggleRecentAndNewPlace),

                          CustomRadioListTile("New Place",
                              true,_pageController.isNewPlace, _toggleRecentAndNewPlace),
                          SizedBox(height: _pageController.isNewPlace? 10: 5),
                          SizedBox(
                            height: _pageController.isNewPlace? 155: 60,
                            child: _placeSelection(),
                          ),
                          SizedBox(height: 15)
                        ],

                      )),


                  //2. When
                  Expander(context, _pageController.whenExpanded, 'When: '
                      '${_pageController.expanderDetailText(_pageController.whenExpanded, dateTimeToString(_pageController.tripDate))}',
                      Container(
                          width: double.maxFinite, //full width
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:[
                            SizedBox(height: 10),
                            LightLabelWrapper("Select Date:",
                                  DatePicker(context, _dateController, _setDate,
                                      TRIP_FIRST_DATE, TRIP_LAST_DATE)),
                            SizedBox(height: 5),
                            //Date picker widget
                            LightLabelWrapper("Select Start and End Time:", InkWell(
                                onTap: () async {
                                  TimeOfDay theEndTime=TimeOfDay(hour: 00, minute: 1);
                                  if(_dateController.text==dateTimeToString(DateTime.now())){
                                    theEndTime=TimeOfDay(hour: DateTime.now().hour+1,minute: (DateTime.now().minute+60)%60);
                                  }
                                  TimeRange? result = await showTimeRangePicker(
                                      maxDuration: const Duration(hours: 24),
                                      context: context,
                                      start: TimeOfDay(hour: _pageController.startHour, minute: _pageController.startMinute),
                                      end: TimeOfDay(hour: _pageController.endHour, minute: _pageController.endMinute),
                                      disabledTime: TimeRange(
                                          startTime: const TimeOfDay(hour: 23, minute: 59),
                                          endTime:  theEndTime),
                                      disabledColor: Colors.red.withOpacity(0.5),
                                      interval: const Duration(minutes: 1),
                                      strokeWidth: 4,
                                      ticks: 24,
                                      ticksOffset: -7,
                                      ticksLength: 15,
                                      ticksColor: Colors.black45,
                                      labels: ["12 am", "3 am", "6 am", "9 am", "12 pm", "3 pm", "6 pm", "9 pm"].asMap().entries.map((e) {
                                        return ClockLabel.fromIndex(
                                            idx: e.key, length: 8, text: e.value);
                                      }).toList(),
                                      labelOffset: 35,
                                      //rotateLabels: false,
                                      padding: 60,
                                      builder: (context, child){
                                        return Theme(
                                          data: Theme.of(context).copyWith(
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
                                  String timeRange=result.toString();
                                  setState(() {
                                    _pageController.startHour=int.parse(timeRange.substring(17,19));
                                    _pageController.startMinute=int.parse(timeRange.substring(20,22));
                                    _pageController.endHour=int.parse(timeRange.substring(37,39));
                                    _pageController.endMinute=int.parse(timeRange.substring(40,42));
                                  });
                                },
                                customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                splashColor: const Color.fromRGBO(255, 192, 203, 100),
                                child: SizedBox(
                                    height: 35,
                                    width: double.maxFinite,
                                    child: Text("${_pageController.startHour.toString().padLeft(2,'0')}:${_pageController.startMinute.toString().padLeft(2,'0')} "
                                        "- ${_pageController.endHour.toString().padLeft(2,'0')}:${_pageController.endMinute.toString().padLeft(2,'0')}",
                                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'OpenSans', color: Color(LOGOPinkInt)),
                                        )
                            ))),
                            SizedBox(height: 15)
                          ]))
                  ),
                  //
                  //3. Budget
                  Expander(context, _pageController.budgetExpanded,
                      'Budget : ${_pageController.budgetString()}',
                      Slider(
                        min: MIN_BUDGET.toDouble(),
                        max: MAX_BUDGET.toDouble(),
                        divisions: MAX_BUDGET,
                        label: _pageController.budgetString(),
                        value:_pageController.budget.toDouble(),
                        onChanged: (value){
                          setState(() {
                            _pageController.budget=value.toInt();
                          });
                        },
                      )),

                  //4. Activities
                  Expander(context, _pageController.activitiesExpanded,
                      'Activities: ${_pageController.expanderDetailText(_pageController.activitiesExpanded, _pageController.selectedMainActivity.description)}',
                      _ActivitiesTile()),
                ],
              ),
          ),
        ),


      ),

      );

  }

  //Methods

  void _generatePlan() async {
    setState(()=>_isLoading=true);
    FocusScope.of(context).unfocus();
    _formKey.currentState?.save();

    //Show alert dialog if user didn't choose a place
    if(_pageController.country==CHOOSE_COUNTRY||
        _pageController.country.isEmpty||
        _pageController.country=="Country"){
      showDialog(
          context: context,
          builder: (BuildContext context)=>
              AlertDialogPopUp(context, HDR_WAIT, MSG_FORGOT_WHERE,
                  false,()=>Navigator.pop(context)));
    }
    else {

      bool hasResult=true;
      Future.value(_pageController.generatePlan()).then((tripPlan){
        if(tripPlan==NULL_PLAN){
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>CannotDisplayVisual(context,
                      "Sorry, no events found",
                      "Home",MainScreenView(user: widget.user))),
                  (route) => false);
        }
        else{
          setState(() {
            _isLoading=false;
          }); //stop loading
          //_isLoading=false;
          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>EditTripDetailPage(user:_pageController.user,tripPlan:tripPlan,isConfirmed:false)));

        }
      });

    }
  }

  void _toggleRecentAndNewPlace(bool value) {
    _dropdownState.currentState?.save();
    setState(() => _pageController.isNewPlace = value);
  }


  void _selectedRecentPlace(String selected){
    setState((){
      List<String> parsedPlace=selected.split(' | ');
      _setCountry(parsedPlace.last);
      if (parsedPlace.length>2){ //contains all country, state, city
        _setStateProvince(parsedPlace[1]);
      }
      _setCity(parsedPlace.first);

    });
  }

  void _setCountry(String country) {
    setState(() {
      _pageController.country = country;
      if (_pageController.isNewPlace) {
        country = country.substring(3).trim(); //omit the flag leading flag code
      }
      _setStateProvince(" ");
      _setCity(" ");
    });
  }

  void _setStateProvince(String state) {
    setState(() {
      _pageController.state = state;
      _setCity(" ");
    });
  }

  void _setCity(String city)=>setState(()=>_pageController.city = city);


  void _setDate(DateTime date){
    setState((){
      _dateController.text = dateTimeToString(date);
      _pageController.tripDate=date;
    });
  }


  void _mainActivityOnChanged(String activity) {
    setState(() =>
      _pageController.selectedMainActivity = MAIN_ACTIVITIES.firstWhere(
              (tag) => tag.description==activity)
    );
  }


  void _transportationOnChanged(bool value){
    setState(() {
      _pageController.isByCar=!_pageController.isByCar;
    });
  }

  void _onOtherActivitiesSelected (int index) =>    setState(() {});

  Widget _placeSelection(){
    if(_pageController.isNewPlace){
      return  CSC_Picker(context,_dropdownState,_setCountry,_setStateProvince,_setCity);
    }
    else{
      List<String> places=_pageController.recommendedPlaces;
      if (places.isEmpty){
        return const Center(
          child: Text("No recent places, please select a new place"),
        );
      }
      //default choose the most recent place if haven't already
      if(!places.contains( '${_pageController.city} | ${_pageController.state} | ${_pageController.country}')){
        _selectedRecentPlace(places.first);
      }
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Center(
          child:  CustomDropDownMenu(context, places,
              '${_pageController.city} | ${_pageController.state} | ${_pageController.country}', _selectedRecentPlace),
        ),
      );
    }
  }

  Widget _ActivitiesTile(){
    List<String> mainActivities=[];
    for(Tag activity in MAIN_ACTIVITIES){
      mainActivities.add(activity.description);
    }
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            LightLabelWrapper('Main Activity:',
                CustomDropDownMenu(context,mainActivities , _pageController.selectedMainActivity.description, _mainActivityOnChanged)),
            // CheckBox(context, 'include meals?',
            //     _pageController.isMealIncluded, _mealsOnChanged),
            SizedBox(
              width: 500,
              child: CheckBox(context, 'Choose Public Transit',
                  _pageController.isByCar, _transportationOnChanged),
            ),
            SizedBox(height: 10),
            LightLabelWrapper('Select Other Activities:', Wrap(
              spacing: 7,
              children: TagTabs(_pageController.selectedOtherActivities,
                  _onOtherActivitiesSelected),
            )),
            SizedBox(height: 15)
          ]));
  }


}

