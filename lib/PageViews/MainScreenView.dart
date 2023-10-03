import 'dart:convert';

import 'package:Leisurely/Models/TripPlan.dart';
import 'package:Leisurely/Toolbox/Constants.dart';
import 'package:Leisurely/Toolbox/CustomWidgetLib.dart';
import 'package:flutter/material.dart';
import 'MainScreen/HomePage.dart';
import 'MainScreen/MyProfilePage.dart';
import 'MainScreen/NewTripPage.dart';
import 'package:flutter_cache/flutter_cache.dart' as cache;
import '../Models/User.dart';

class MainScreenView extends StatefulWidget {
  const MainScreenView({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  _MainScreenViewState createState() =>_MainScreenViewState();
}

class _MainScreenViewState extends State<MainScreenView> {
  late User user;
  //int _selectedIndex = 0;
  //String _pageTitle="";

  @override
  void initState(){
    super.initState();

  }

  @override
  void dispose(){
    cache.clear();
    super.dispose();
  }
  // void _onNavBarItemTapped(int index) {
  //   if (index!=1){
  //     setState(()=>_setPageTitle(index));
  //   }
  //   else{
  //     Navigator.of(context).push(
  //       MaterialPageRoute(builder: (context) => NewTripPage(user:user)),
  //     );
  //   }
  // }

  // void _setPageTitle(int index){
  //   _selectedIndex = index;
  //   switch (index){
  //     case 0:_pageTitle=MY_PLANS;
  //     break;
  //     case 2:_pageTitle=MY_PROFILE;
  //     break;
  //   }
  // }

  // Widget _pageCaller(int index) {
  //   switch (index) {
  //     case 2:
  //       return MyProfilePage(user: user);
  //     default:
  //       return HomePage(user: user);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    user=widget.user;
    return Scaffold(
      appBar:AppBar(
        title: const Text("MY TRIPS"),
        leading: IconButton(
          icon:const Icon(Icons.person_rounded),
          onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>MyProfilePage(user: user)));
          },
        ),
        actions: [
          IconButton(
              onPressed: (){
                showSearch(
                  context:context,
                  delegate: _searchDelegate(user)
                );
              },
              icon: const Icon(Icons.search_rounded)
          )],
        centerTitle: true,
      ),
      body: HomePage(user:user),
      floatingActionButton:FloatingActionButton(
        tooltip: "Press to add new trip",
        hoverColor: LOGOOrange,
        backgroundColor: LOGOPink,
        splashColor: LOGOOrange,
        onPressed: ()=> Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NewTripPage(user:user))
        ),
        child: const Icon(Icons.add_rounded, size:30),
      ) ,
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: MY_PLANS,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.add_box_rounded),
      //       label: NEW_TRIP,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: MY_PROFILE,
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.pinkAccent,
      //   onTap: _onNavBarItemTapped,
    );
  }
}


class _searchDelegate extends SearchDelegate{
  _searchDelegate(this.user);
  User user;
  List<String> recentSearches=[];
  List<TripPlan> matchResults=[];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon:const Icon(Icons.clear_rounded),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () async{
        close(context, null);
        await cache.write('recentSearches', recentSearches);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    matchResults.clear();
    for(TripPlan plan in user.tripPlans){
      String normQuery=query.toLowerCase();
      if(((normQuery.contains(plan.tripName.toLowerCase())
      ||plan.tripName.toLowerCase().contains(normQuery))&&plan.tripName.isNotEmpty)
      ||(normQuery.contains(plan.country.toLowerCase())&&plan.country.isNotEmpty)
      ||(normQuery.contains(plan.state.toLowerCase())&&plan.state.isNotEmpty)
      ||(normQuery.contains(plan.location.toLowerCase())&&plan.location.isNotEmpty)){
        matchResults.add(plan);
      }
    }
    if (query.isNotEmpty){
      if(recentSearches.contains(query)){ //remove previous search if already in search history
        recentSearches.remove(query);
      }
      if(recentSearches.length>10){
        recentSearches.removeLast(); //[optional] keep count of recent searches to 10
      }
      recentSearches.insert(0,query);
    }

    return FutureBuilder(
        future:cache.write(RECENT_SEARCH_KEYSTR, recentSearches),
        builder: (context,snapshot){
          return TripCardStack(context,user,matchResults,SEARCH_RESULT_PLAN,(){});
          // return Column(
          //   children: [
          //     Center(child:Text("${matchResults.length} trip(s) found with keyword $query")),
          //     TripCardStack(context, matchResults,SEARCH_RESULT_PLAN),
          //   ],
          // ) ;
        },
     );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: cache.load(RECENT_SEARCH_KEYSTR),
        builder: (context,snapshot) {
          if (snapshot.hasData) {
            recentSearches = snapshot.data as List<String>;
            print(recentSearches);
            return ListView.builder(
                itemCount: recentSearches.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(recentSearches[index]),
                    onTap: () {
                      query = recentSearches[index];
                    },
                    leading: const Icon(Icons.history_rounded),
                  );
                }
            );
          }
          return const Center(
            child: Text("No Recent Search History", style: TextStyle(fontFamily: 'OpenSans', color: Colors.black54)),
          );
        }
      );
  }

  @override
  String get searchFieldLabel => 'Search by trip name or location';

  @override
  TextStyle? get searchFieldStyle => TextStyle(fontSize: 16, fontFamily: 'OpenSans');
}





