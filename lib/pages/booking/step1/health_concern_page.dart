import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:qoremed_app/myvars.dart';
import '../../../components/health_concern_item.dart';
import '../../../components/text_form_field.dart';
import '../../../model/health_category.dart';
import '../../../routes/routes.dart';
import 'package:geocoder/geocoder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qoremed_app/pages/booking/step1/mymap.dart';
import 'package:qoremed_app/utils/constants.dart';
import 'package:qoremed_app/pages/booking/step1/mygooglemap.dart';

class HealthConcernPage extends StatefulWidget {

  @override
  _TimeSlotPageState createState() => _TimeSlotPageState();
}



class _TimeSlotPageState extends State<HealthConcernPage> {
  bool searchme = false;
  var _seController = TextEditingController();





  _openMap(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyGoogleMap(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    searchme = false;
  }

  myicon(){
    if(searchme == false){
      return Icon(
        Icons.search,
      );
    }else
      {
        return Icon(
          Icons.keyboard_arrow_up,
        );
      }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        title: Text(
          'book_an_appointment'.tr(),
        ),

      ),
      body: Column(
        children: <Widget>[
          Visibility(
            visible: true,
            child: Container(

              color: Colors.white70,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 12, 10, 10),
                      child: TextField(
                        controller: _seController,

                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(color: kColorBlue, width: 0.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(color: Colors.black, width: 0.5),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                          hintText: 'doctor, specialization, province',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),

                          suffixIcon: Container(
                            width: 20,
                            child: FlatButton(
                              onPressed: (){
                                setState(() {
                                  AppVar.doctypecho = _seController.text;
                                  _seController.text = "";
                                  searchme = false;
                                });
                                print(AppVar.doctypecho);
                                Navigator.of(context).pushNamed(Routes.bookingStep2);
                              },
                              child: new Icon(Icons.search,  color: kColorBlue, size: 20,),),
                          ),

                        ),
                        cursorWidth: 1,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  /*Container(

                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(

                        controller: _seController,
                        autocorrect: true,
                        decoration: InputDecoration(
                           *//* border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.indigo)
                            ),*//*
                            hintText: 'Doctor name or specialization ',
                            suffixIcon: Container(
                              width: 20,
                              child: FlatButton(
                                onPressed: (){
                                  setState(() {
                                      AppVar.doctypecho = _seController.text;
                                      _seController.text = "";
                                      searchme = false;
                                  });
                                  print(AppVar.doctypecho);
                                  Navigator.of(context).pushNamed(Routes.bookingStep2);
                                },
                                child: new Icon(Icons.search,  color: Colors.blueAccent, size: 30,),),
                            ),

                        ),
                      )
                  ),*/
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: GestureDetector(
                      onTap: (){
                        _openMap();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: kColorBlue,
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child:  Container(
                          child: Row(
                            children: [
                              Icon(Icons.location_on,  color: Colors.white, size: 20,),
                              Text("Search Map", style: TextStyle(color: Colors.white),),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,)

                ],
              )
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'choose_health_concern'.tr(),
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  StaggeredGridView.countBuilder(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    crossAxisCount: 4,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: healthCategories.length,
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemBuilder: (context, index) {
                      return HealthConcernItem(
                        healthCategory: healthCategories[index],
                        onTap: () {
                          //AppVar.doctypecho = "Allergist";
                         Navigator.of(context).pushNamed(Routes.bookingStep2);
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}
