import 'package:flutter/material.dart';
import 'package:Leisurely/Models/TripPlan.dart';
import 'package:Leisurely/PageControllers/MainScreen/HomePageController.dart';
import 'package:Leisurely/PageViews/ObsoletePages/xxxDetailedTripPage.dart';
import 'package:Leisurely/Toolbox/Constants.dart';
import '../../Models/User.dart';
import '../../Toolbox/Constants.dart';
import '../../Toolbox/CustomWidgetLib.dart';
import '../../Toolbox/HttpClient.dart';


class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  List<TripPlan> currentPlans=[];
  List<TripPlan> futurePlans=[];
  List<TripPlan> pastPlans=[];
  List<TripPlan> starredPlans=[];
  int currentTabIndex=1;
  @override
  void InitState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;
    _tabController=TabController(length: 3, vsync: this);
    _tabController.index=currentTabIndex;
    DateTime today=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,0,0,0,0,0);
    currentPlans=widget.user.tripPlans.where((cp) =>
    cp.startTime.year==today.year
        &&cp.startTime.month==today.month
        &&cp.startTime.day==today.day).toList();
    futurePlans=widget.user.tripPlans.where((cp) => cp.startTime.isAfter(today)).where((cp) =>!currentPlans.contains(cp)).toList();
    pastPlans=widget.user.tripPlans.where((cp) => cp.startTime.isBefore(today)).toList();
    starredPlans=widget.user.tripPlans.where((cp) => cp.isFav).toList();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 5),
            height: 190,
            child:LabelWrapper("${starredPlans.length} $FAV_PLAN",
                TripCardCarousel(context,widget.user,starredPlans,FAV_PLAN)),
          ),
          SizedBox(
            width: screenWidth,
            child: TabBar(
                controller: _tabController,
                padding: EdgeInsets.only(left: 5),
                labelColor: LOGOPink,
                labelPadding: EdgeInsets.only(left: 10,right: 10),
                labelStyle: TextStyle(fontSize: 16, fontFamily: 'OpenSans'),
                unselectedLabelColor: Colors.black54,
                indicatorColor: LOGOPink,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: true,
                tabs:[Tab(text: "${pastPlans.length} $PAST_PLAN"),
                  Tab(text: "${currentPlans.length} $TODAY_PLAN"),
                  Tab(text: "${futurePlans.length} $FUTURE_PLAN")]
            ),
          ),
          Expanded(
              child:
              SizedBox(
                width: screenWidth,
                child: TabBarView(
                    controller: _tabController,
                    children: [
                      TripCardStack(context,widget.user,pastPlans,PAST_PLAN,_onDeleteTrip),
                      TripCardStack(context,widget.user,currentPlans,TODAY_PLAN,_onDeleteTrip),
                      TripCardStack(context,widget.user,futurePlans,FUTURE_PLAN,_onDeleteTrip),
                    ]
                ),
              ),
          )

        ]
    );
  }

  void _onDeleteTrip(BuildContext context,TripPlan trip){

    showDialog(
        context: context,
        builder: (BuildContext context)=>
            AlertDialogPopUp(context, MSG_DELETE_TRIP_HDR, MSG_DELETE_TRIP_TXT, true,_deleteTripEntirely,trip),
    );
  }

  void _deleteTripEntirely(TripPlan trip){
    setState(() {
      widget.user.tripPlans.remove(trip);
      //TODO: Notify backend after delete
      deletePlanHttp(trip);
      if(trip.isFav){
        starredPlans.remove(trip);
      }
      if(pastPlans.remove(trip)){
        currentTabIndex=0;
      }
      else if(currentPlans.remove(trip)){
        currentTabIndex=1;
      }
      else if (futurePlans.remove(trip)){
        currentTabIndex=2;
      }
      Navigator.pop(context);
    });
  }

}
