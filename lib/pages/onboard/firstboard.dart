
import 'package:flutter/material.dart';
import 'package:qoremed_app/utils/constants.dart';



class FirstBoard extends StatefulWidget {
  @override
  _firstBoard createState() => _firstBoard();
}

class _firstBoard extends State<FirstBoard> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Stack(
          children: [
            Container(

              child: Image.asset('assets/images/firstonboard.png',
                height: 450,
                width: 500,
                fit: BoxFit.fitWidth,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 200, 0, 0),
              child: Center(
                child: Text("Healthcare Services", style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold, color: kColorDarkBlue),),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(60, 400, 60, 0),
              child: Center(
                child: Text("QoreMed is a platform for both doctors and patients to easily manage the different processes between doctors and patient.", style: TextStyle(fontSize: 14, color: kColorDarkBlue),textAlign: TextAlign.justify,),
              ),
            )
          ],
        )
      ),
    );
  }
}
