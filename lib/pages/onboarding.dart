import 'dart:async';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'package:qoremed_app/pages/onboard/firstboard.dart';
import 'package:qoremed_app/pages/onboard/secondboard.dart';
import 'package:qoremed_app/pages/onboard/thirdboard.dart';
import 'package:qoremed_app/pages/onboard/fourthboard.dart';


class OnBoarding extends StatefulWidget {
  @override
  _onBoarding createState() => _onBoarding();
}

class _onBoarding extends State<OnBoarding> {
  int currentIndexPage;
  int pageLength;

  @override
  void initState() {
    currentIndexPage = 0;
    pageLength = 4;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            PageView(
              children: <Widget>[
                FirstBoard(),
                SecondBoard(),
                ThirdBoard(),
                FourthBoard(),
              ],
              onPageChanged: (value) {
                setState(() => currentIndexPage = value);
              },
            ),


            Positioned(
              top: MediaQuery.of(context).size.height * 0.95,
              // left: MediaQuery.of(context).size.width * 0.35,
              child: Padding(
                padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.38),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: new DotsIndicator(
                    dotsCount: pageLength,
                    position: currentIndexPage,
                    decorator: DotsDecorator(
                      color: Colors.black87, // Inactive color
                      activeColor: kColorBlue,
                    ),
                  )
                ),
              ),
            )
          ],
        ));
  }
}


