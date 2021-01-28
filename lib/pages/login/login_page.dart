import 'dart:io';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qoremed_app/pages/forgot/forgot_password_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qoremed_app/components/dark_button.dart';
import 'package:qoremed_app/data/database_user.dart';
import 'package:qoremed_app/data/pref_manager.dart';
import '../../components/custom_button.dart';
import '../../components/text_form_field.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';
import 'dart:convert';
import 'package:qoremed_app/myvars.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qoremed_app/pages/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/pref_manager.dart';
import '../../routes/routes.dart';
import '../../utils/app_themes.dart';
import '../../utils/constants.dart';
import '../../utils/themebloc/theme_bloc.dart';

class LoginPage extends StatelessWidget {


  logoimg(BuildContext context){
    var _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
    if(_isDark == true){
      return  Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Image.asset('assets/images/logblack.png'),
        ),
      );
    }else{
      return  Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Image.asset('assets/images/logwhite.png'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                     logoimg(context),
                      SizedBox(
                        height: 20,
                      ),
                      // Expanded(
                      //   child: SizedBox(
                      //     height: 10,
                      //   ),
                      // ),
                      // Text(
                      //   'sign_in'.tr(),
                      //   style: TextStyle(
                      //     fontSize: 28,
                      //     fontWeight: FontWeight.w700,
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      WidgetSignin(),
                      Center(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ForgotPasswordPage(AppVar.useremail),
                              ),
                            );
                          },
                          child: Text(
                            'forgot_yout_password'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Divider(
                              color: Colors.grey,
                              endIndent: 20,
                            ),
                          ),
                          /*Text(
                            'social_login'.tr(),
                            style: Theme.of(context).textTheme.subtitle2,
                          ),*/
                          Expanded(
                            child: Divider(
                              color: Colors.grey,
                              indent: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Center(
                        child: Text(
                          'dont_have_an_account'.tr(),
                          style: TextStyle(
                            color: Color(0xffbcbcbc),
                            fontSize: 12,
                            fontFamily: 'NunitoSans',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      DarkButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(Routes.signup);
                        },
                        text: 'register_now'.tr(),

                      ),
                      /*CustomButton(
          onPressed: () {
            _query();
          },
          text: 'offline'.tr(),
        ),*/
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: <Widget>[
                      //     SocialIcon(
                      //       colors: [
                      //         Color(0xff102397),
                      //         Color(0xff187adf),
                      //       ],
                      //       iconData: CustomIcons.facebook,
                      //       onPressed: () {},
                      //     ),
                      //     SocialIcon(
                      //       colors: [
                      //         Color(0xffff4f38),
                      //         Color(0xff1ff355d),
                      //       ],
                      //       iconData: CustomIcons.googlePlus,
                      //       onPressed: () {},
                      //     ),
                      //   ],
                      // ),
                      Expanded(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      SafeArea(
                        child: Visibility(
                          visible: false,
                          child: Center(
                            child: Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'dont_have_an_account'.tr(),
                                    style: TextStyle(
                                      color: Color(0xffbcbcbc),
                                      fontSize: 12,
                                      fontFamily: 'NunitoSans',
                                    ),
                                  ),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(2),
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(Routes.signup);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      'register_now'.tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class WidgetSignin extends StatefulWidget {
  @override
  _WidgetSigninState createState() => _WidgetSigninState();
}

class _WidgetSigninState extends State<WidgetSignin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool visible = false ;
  final dbHelper = DatabaseHelper.instance;

  /// Local authentication framework
  final LocalAuthentication auth = LocalAuthentication();
  /// Is there a biometric technology available?
  bool _canCheckBiometrics;
  /// Biometrics list
  List<BiometricType> _availableBiometrics;
  /// Identify the result
  String _authorized = 'Verification failed';
  Future<Null> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }
  /// Get a list of biometric technologies
  Future<Null> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }
  /// Biometrics
  Future<Null> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'scan fingerprint for authentication',
          useErrorDialogs: true,
          stickyAuth: false);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _authorized = authenticated ? 'Verify by ' : 'Verification failed';
    });
    if(authenticated == true){
      print('login');
      autolog();
    }
  }

  @override
  void initState() {
    _loadScreen();
    var _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
    print(_isDark.toString());
    super.initState();
    _authenticate();

  }

  _loadScreen() async {
    await Prefs.load();
    context.bloc<ThemeBloc>().add(ThemeChanged(
        theme: Prefs.getBool(Prefs.DARKTHEME, def: false)
            ? AppTheme.DarkTheme
            : AppTheme.LightTheme));
  }


  showqr(BuildContext context, String mess) {
    Widget cancelButton = FlatButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("QoreMed"),
      content: Text(mess),
      actions: [
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  nointernet() {
    Widget yesButton = FlatButton(
      child: Text("Yes"),
      onPressed:  () {
        _query();
        Navigator.of(context).pop();
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("QoreMed"),
      content: Text('You dont have internet connection. Do you want to login in offline mode?'),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future userLogin() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String myuser = _emailController.text;
        String mypass = _passwordController.text;
        if(mypass != "" && myuser != ""){
          setState(() {
            visible = true ;
          });
          var mydata;
          final response = await http.post("https://qoremed.qoreit.com/api/oauth/token",
              headers: {'Header': 'application/x-www/form-urlencoded', "Accept": "application/json"},
              body: {"username": myuser, "password": mypass, "grant_type":"password","client_id":"91ad2f23-fde1-440a-aabf-418b3532394b","client_secret":"KDtpNtq8vl98cZL4pzKkUjIyFuCuZUJQ2WOiXTPB" });
          if(response.statusCode == 200){
            mydata = json.decode(response.body);
            if(json.decode(response.body)['access_token'] != null){
              if(json.decode(response.body)['user_type'].toString() == "App\\Secretary") {
                AppVar.online = true;
                //getuser(json.decode(response.body)['access_token'].toString());
                AppVar.token =
                    json.decode(response.body)['access_token'].toString();
                AppVar.useremail = myuser;
                AppVar.upass = mypass;
                print(json.decode(response.body)['access_token'].toString());

                Navigator.of(context).popAndPushNamed(Routes.home);
              }else{
                showqr(context, "Invalid users.");
              }
            }else
            {
              //Navigator.of(context).popAndPushNamed(Routes.home);
              print(json.decode(response.body)['message'].toString());
              showqr(context, "PLease check username and password.");
            }
          }else{
            //Navigator.of(context).popAndPushNamed(Routes.home);
            print("Server not response error");
            showqr(context, "Internal server error");
          }
          setState(() {
            visible = false ;
          });
        }else{
          print("Please fill up email and password");
          showqr(context, "Please fill up email and password");
        }

      }
    } on SocketException catch (_) {
      nointernet();
    }


  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
    Navigator.pop(context);
    Navigator.pop(context);
    //_query();
  }

  void _insert(String name,pass,one,aut,email,drive,exp) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName : name,//username
      DatabaseHelper.columnPass  : pass,//user password
      DatabaseHelper.columnOne  : one,//user id
      DatabaseHelper.columnAuth  : aut,//user first name
      DatabaseHelper.columnEmail  : email,//user middle name
      DatabaseHelper.columnDrive  : drive,// user last name
      DatabaseHelper.columnExp  : exp,//user unknown pa
    };
    final id = await dbHelper.insert(row);

    print('inserted row id: $id');

  }
  void autolog() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');

    if(allRows.length == 0){
      print("awallalasldlasdklaskdlaksdlkqwlkalkdlasklkalskdlsakdlaksldkasd");
    }else {
      print(allRows[0]['_id']);
      print(allRows[0]['name']);
      print(allRows[0]['password']);
      print(allRows[0]['onesignal']);
      print(allRows[0]['auth']);
      print(allRows[0]['email']);
      print(allRows[0]['driver']);
      print(allRows[0]['exp']);

      if(allRows[0]['name'] != "" || allRows[0]['password'] != null){
        setState(() {
          AppVar.online = false;
          AppVar.useremail = allRows[0]['name'];
          AppVar.upass = allRows[0]['password'];
          AppVar.userid = allRows[0]['onesignal'];
          AppVar.fname = allRows[0]['auth'];
          AppVar.userfullname = allRows[0]['auth'] + allRows[0]['email'] + allRows[0]['driver'];
          _emailController.text =  allRows[0]['name'];
          _passwordController.text = allRows[0]['password'];
          //userLogin();
        });
        //Navigator.of(context).popAndPushNamed(Routes.home);
      }


    }
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');

    if(allRows.length == 0){
      print("awallalasldlasdklaskdlaksdlkqwlkalkdlasklkalskdlsakdlaksldkasd");
    }else {
      print(allRows[0]['_id']);
      print(allRows[0]['name']);
      print(allRows[0]['password']);
      print(allRows[0]['onesignal']);
      print(allRows[0]['auth']);
      print(allRows[0]['email']);
      print(allRows[0]['driver']);
      print(allRows[0]['exp']);

      if(allRows[0]['onesignal'] != "" || allRows[0]['onesignal'] != null){
        AppVar.online = false;
        AppVar.useremail = allRows[0]['name'];
        AppVar.upass = allRows[0]['password'];
        AppVar.userid = allRows[0]['onesignal'];
        AppVar.fname = allRows[0]['auth'];
        AppVar.userfullname = allRows[0]['auth'] + allRows[0]['email'] + allRows[0]['driver'];
        Navigator.of(context).popAndPushNamed(Routes.home);
      }else{
        showqr(context, "You had no record during online, please login in online to save data.");
      }


    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Text(
          'email_dot'.tr(),
          style: kInputTextStyle,
        ),
        CustomTextFormField(
          controller: _emailController,
          hintText: 'sample@mail.com',
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'password_dot'.tr(),
          style: kInputTextStyle,
        ),
        CustomTextFormField(
          controller: _passwordController,
          hintText: '* * * * * *',
          obscureText: true,
        ),
        SizedBox(
          height: 35,
        ),
        CustomButton(
          onPressed: () {
            //Navigator.of(context).popAndPushNamed(Routes.home);
            userLogin();
          },
          text: 'login'.tr(),
        ),
        /*CustomButton(
          onPressed: () {
            _query();
          },
          text: 'offline'.tr(),
        ),*/
        SizedBox(
          height: 35,
        ),
        Center(
          child: Visibility(
              visible: visible,
              child: Container(
                width: 150,
                height: 2,
                child: LinearProgressIndicator(
                  backgroundColor: kColorBlue,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
          ),
        ),
      ],
    );
  }
}
