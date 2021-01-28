
import 'package:flutter/material.dart';
import 'package:qoremed_app/utils/constants.dart';



class ThirdBoard extends StatefulWidget {
  @override
  _thirdBoard createState() => _thirdBoard();
}

class _thirdBoard extends State<ThirdBoard> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Stack(
            children: [
              Container(

                child: Image.asset('assets/images/thirdonboard.png',
                  height: 450,
                  width: 500,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 200, 0, 0),
                child: Center(
                  child: Text("How to?", style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold, color: kColorDarkBlue),),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(60, 400, 60, 0),
                child: Center(
                  child: Text("Find a Doctor => Set Appointment => Consultation => Payments => Submit Feedback", style: TextStyle(fontSize: 14, color: kColorDarkBlue),textAlign: TextAlign.justify,),
                ),
              )
            ],
          )
      ),
    );
  }
}
