
import 'package:flutter/material.dart';
import 'package:qoremed_app/utils/constants.dart';



class SecondBoard extends StatefulWidget {
  @override
  _secondBoard createState() => _secondBoard();
}

class _secondBoard extends State<SecondBoard> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Stack(
            children: [
              Container(

                child: Image.asset('assets/images/secondonboard.png',
                  height: 450,
                  width: 500,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 200, 0, 0),
                child: Center(
                  child: Text("Who we are?", style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold, color: kColorDarkBlue),),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(60, 400, 60, 0),
                child: Center(
                  child: Text("In a country where small-to-medium entrepreneurs grow in number, and individuals have fast-paced lives, the need for on-demand delivery services continues to rise. This is where Qoremed, the best Health Care System comes in.", style: TextStyle(fontSize: 14, color: kColorDarkBlue),textAlign: TextAlign.justify,),
                ),
              )
            ],
          )
      ),
    );
  }
}
