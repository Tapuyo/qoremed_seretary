import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qoremed_app/myvars.dart';
import '../../../components/custom_button.dart';
import '../../../components/doctor_item1.dart';
import '../../../components/text_form_field.dart';
import '../../../data/pref_manager.dart';
import '../../../model/doctor.dart';

import '../../../utils/constants.dart';
import 'package:qoremed_app/pages/booking/step4.5/step4.5.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientDetailsPage extends StatefulWidget {
  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  String _currentSelectedValue;
  String _mySelection;
  List mylist =   List();
  bool buttonbook = false;
  bool reas = true;

  var _currencies = [
    "Food",
    "Transport",
  ];

  bool _isdark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  bool _patient = true;
  var _nameController = TextEditingController();
  var _phoneController = TextEditingController();
  var _patientPhoneController = TextEditingController();
  var _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSched();
    _nameController.text = AppVar.userfullname;
    print("Name Patient"+ AppVar.userfullname);
    _phoneController.text = AppVar.ucontact;
    _emailController.text = AppVar.useremail;
    reas = true;
  }

  booknow()async{

    AppVar.consreason= _mySelection;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Paym(),
      ),
    );
/*
    showProgressDialog(context);

    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer ' + AppVar.token
    };
    String url = "https://qoremed.qoreit.com/api/appointments/";
    Map<String, String> body = {
      "appointable_id": AppVar.sclinic,
      "client_id": AppVar.userid,
      'period_id': AppVar.periodid,
      'consultation_reason_id': _mySelection,
    }; //
    final response = await http.post(url, headers: headers, body: body);

    var jsondata = json.decode(response.body);
    print(jsondata.toString());

    if(response.statusCode == 200){
//      AppVar.nxtdt = json.decode(response.body)['access_token'].toString();
//      AppVar.nxtdocsp = nxtdocsp;
//      AppVar.nxthospital = nxthospital;
      AppVar.nxtname = AppVar.userfullname;
      AppVar.nxtstatus = 'pending';
      AppVar.nxtid =  json.decode(response.body)['id'].toString();
      AppVar.nxtdt = json.decode(response.body)['date'].toString();
      Navigator.pop(context);
      //Navigator.of(context).pushNamed(Routes.bookingStep5);

    }else{
      Navigator.pop(context);
      shownosig(context, json.decode(response.body)['message'].toString() + ", " + json.decode(response.body)['errors']['appointable_id'].toString());
    }*/
  }

  shownosig(BuildContext context, String mes) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Booking"),
      content: Text(mes),
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
  static showProgressDialog(BuildContext context) {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(padding: EdgeInsets.only(left: 15),),
                  Flexible(
                      flex: 8,
                      child: Text(
                        "Loading",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            );
          });
    } catch (e) {
      print(e.toString());
    }
  }


  getSched() async {
    setState(() {
      reas = true;
    });
    _currencies.clear();
    print("Doctor ID " + AppVar.docid);
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ' + AppVar.token
    };
    String url = "https://qoremed.qoreit.com/api/doctors/" + AppVar.docid +
        "/consultation-reasons/";
    final response = await http.get(url, headers: headers);

    var jsondata = json.decode(response.body);
    print(jsondata.toString());

    var tagObjsJson = jsonDecode(response.body) as List;
    setState(() {
      mylist = tagObjsJson;
    });


    for (var u in jsondata) {
      setState(() {
        _currencies.add(u['name']);
      });
    }
    setState(() {
      reas = false;
    });
  }

  Widget _patientDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /*Text(
          _patient
              ? '${'please_provide_following_information_about'.tr()}' + AppVar.fname +':'
              : 'please_provide_following_patient_details_dot'.tr(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 35,
        ),*/
        Text(
          _patient ? 'Patient Name' : 'Patient Name',
          style: kInputTextStyle,
        ),
        CustomTextFormField(
          controller: _nameController,
          hintText: _patient ? '' : AppVar.userfullname,
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "Contact Number",
          style: kInputTextStyle,
        ),
        CustomTextFormField(
          controller: _phoneController,
          hintText: 'Contact number',
          enabled: true,
        ),
        _patient ? Container() : _patientsMobile(),
        SizedBox(
          height: 15,
        ),
        Text(
          "Email Address",
          style: kInputTextStyle,
        ),
        CustomTextFormField(
          controller: _emailController,
          hintText: _patient
              ? 'enter_your_email_id'.tr()
              : 'enter_patient_email_id'.tr(),
        ),
      ],
    );
  }

  Widget _patientsMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        Text(
          'Patient\'s Mobile*',
          style: kInputTextStyle,
        ),
        CustomTextFormField(
          controller: _patientPhoneController,
          hintText: 'Enter Patient\'s Mobile Number',
        ),
      ],
    );
  }

  docavatar() {
    if (AppVar.docimg == "none") {
      return CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey,
        backgroundImage: AssetImage('assets/images/icon_doctor_1.png'),
      );
    } else {
      return CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey,
        backgroundImage: AssetImage('assets/images/icon_doctor_3.png'),
        child: Image.network(AppVar.docimg),
      );
    }
  }

  myconres(){
    if(reas != true){
      return  Container(
        child: Container(
          child: new DropdownButton(
            isExpanded: true,
            items: mylist.map((item) {
              return new DropdownMenuItem(
                child: new Text(item['name'], style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
                value: item['id'].toString(),
              );
            }).toList(),
            onChanged: (newVal) {
              setState(() {
                _mySelection = newVal;
                print(_mySelection);
                if(_mySelection != ""){
                  buttonbook = true;
                }
              });
            },
            value: _mySelection,
          ),
        ),
      );
    }else{
      return Container(
        //width: 100,
        child: Center(
          child: Row(
            children: <Widget>[
              Container(
                child: Text("Loading"),
              ),
              Container(
                height: 30,
                width: 10,
              ),
              Container(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              )
            ],
          ),
        ),
      );
    }
  }


  Widget practiceDetail() {
    return Container(
      width: double.infinity,
      color: _isdark ? Colors.white.withOpacity(0.12) : Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Clinic/Hospital',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppVar.sclinicname,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 80,
                  child: VerticalDivider(
                    color: _isdark ? Colors.black : Colors.grey[300],
                    width: 0.5,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Type of Consultation',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppVar.periodtype,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget timedate() {
    return Container(
      //width: double.infinity,
      color: _isdark ? Colors.white.withOpacity(0.12) : Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Date and Time',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppVar.perioddt,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 80,
                  child: VerticalDivider(
                    color: _isdark ? Colors.black : Colors.grey[300],
                    width: 0.5,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 1, right: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          color: _isdark
                              ? Colors.white.withOpacity(0.12)
                              : Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '* ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Text(
                                      'Consultation Reason',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),

                                  ],
                                ),

                                Container(

                                  child: myconres(),
                                ),


//                              Text(
//                                'consultation'.tr(),
//                                style: TextStyle(
//                                  fontSize: 16,
//                                  fontWeight: FontWeight.bold,
//                                ),
//                              ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'patient_details'.tr(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[

            Expanded(
              child: Container(
                color: _isdark ? Colors.transparent : Colors.grey[300],
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: _isdark ? Colors.transparent : Colors.white,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: <Widget>[
                              docavatar(),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      AppVar.docname,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      AppVar.doctype,
                                      style: TextStyle(
                                        color: Colors.grey[350],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        )
                      ),
                      practiceDetail(),

                      Divider(
                        color: _isdark ? Colors.black : Colors.grey[300],
                        height: 0.5,
                      ),
                      timedate(),

                      Divider(
                        color: _isdark ? Colors.black : Colors.grey[300],
                        height: 0.5,
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        color: _isdark
                            ? Colors.white.withOpacity(0.12)
                            : Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'this_appointment_for_dot'.tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              /*Material(
                                color: _isdark
                                    ? Colors.white.withOpacity(0.12)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: _isdark
                                            ? Colors.black
                                            : Colors.grey,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RadioListTile(
                                        value: true,
                                        onChanged: (value) {
                                          setState(() {
                                            _nameController.text =
                                                AppVar.userfullname;
                                            _patient = true;
                                          });
                                        },
                                        groupValue: _patient,
                                        title: Text(AppVar.userfullname),
                                      ),
                                      Divider(
                                        color: _isdark
                                            ? Colors.black
                                            : Colors.grey,
                                        height: 1,
                                      ),
                                      *//*RadioListTile(
                                        value: false,
                                        onChanged: (value) {
                                          setState(() {
                                            _nameController.clear();
                                            _patient = false;
                                          });
                                        },
                                        groupValue: _patient,
                                        title: Text('someone_else'.tr()),
                                      ),*//*
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),*/
                              _patientDetails(),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            mybookbutton(),
          ],
        ),
      ),
    );
  }
  mybookbutton(){
    if(buttonbook == true){
      return Container(
        height: 70,
        child: Card
          (
            color: kColorBlue,
            child: GestureDetector(
              onTap: (){
                booknow();

              },
              child: Center(
                  child: Text("Confirm", style: TextStyle(color: Colors.white, fontSize: 20),)
              ),
            )
        ),
      );

    }
    if(buttonbook == false){
      return Container(
        height: 70,
        child: Card
          (
            color: Colors.grey,
            child: GestureDetector(
              onTap: (){

              },
              child: Center(
                  child: Text("Confirm", style: TextStyle(color: Colors.white, fontSize: 20),)
              ),
            )
        ),
      );
    }
  }
}
