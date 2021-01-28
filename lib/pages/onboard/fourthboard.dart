import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:qoremed_app/data/pref_manager.dart';
import 'package:qoremed_app/routes/routes.dart';
import 'package:qoremed_app/utils/app_themes.dart';
import 'package:qoremed_app/utils/constants.dart';
import 'package:qoremed_app/utils/themebloc/theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_themes.dart';
import '../../utils/themebloc/theme_bloc.dart';

class FourthBoard extends StatefulWidget {

  @override
  _fourthBoard createState() => _fourthBoard();
}

class _fourthBoard extends State<FourthBoard> {
  String _radioValue;
  String _choice;



  @override
  void initState() {
    _radioValue = "one";
    _choice = "light";
    super.initState();
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    print('Pressed $counter times.');
    await prefs.setInt('counter', counter);
    Navigator.of(context).pushReplacementNamed(Routes.login);
  }
  getdark()async{
    // var _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
    setState(() {
      Prefs.setBool(Prefs.DARKTHEME, true);
      var _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
      print(_isDark);
    });
  }
  getlight()async{
    //
    setState(() {
      Prefs.setBool(Prefs.DARKTHEME, false);
      var _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
      print(_isDark);
    });
  }
  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'one':
          setState(() {
            _choice = "light";
            getlight();
          });
          break;
        case 'two':
          setState(() {
            _choice = "dark";
            getdark();
          });
          break;

        default:
          _choice = "light";
      }
      debugPrint(_choice); //Debug the choice in console
    });
  }

  imagedrk(){
    if(_choice == "light") {
      return Container(

        child: Image.asset('assets/images/lightmode.png',

        ),
      );
    }else{
      return Container(

        child: Image.asset('assets/images/darkmode.png',

        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              imagedrk(),
              SizedBox(
                height: 10,
              ),
              Container(

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [


                          Row(
                            children: [
                              Radio(
                                value: 'one',
                                groupValue: _radioValue,
                                onChanged: radioButtonChanges,
                              ),
                              Text(
                                "Light Mode",style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    SizedBox(width: 50,),
                    Column(
                      children: [

                        Row(
                          children: [
                            Radio(
                              value: 'two',
                              groupValue: _radioValue,
                              onChanged: radioButtonChanges,
                            ),
                            Text(
                              "Dark Mode",style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                height: 60,
                child: Card
                  (
                    color: kColorBlue,
                    child: GestureDetector(
                      onTap: (){
                        _incrementCounter();

                      },
                      child: Center(
                          child: Text("finish", style: TextStyle(color: Colors.white, fontSize: 20),)
                      ),
                    )
                ),
              )
            ],
          )
      ),
    );
  }
}
