import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qoremed_app/components/round_icon_button.dart';
import 'package:qoremed_app/myvars.dart';
import 'package:qoremed_app/routes/routes.dart';
import 'package:qoremed_app/utils/constants.dart';
import 'profile_info_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class MyProfile extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<MyProfile> {

  String bd;


  @override
  void initState() {
    super.initState();
    mynxtdt();
  }
  mynxtdt(){
    if(AppVar.ubdate != null){
      DateTime ststart =  DateFormat("yyyy-MM-dd").parse(AppVar.ubdate);
      int dtmo = ststart.month;
      String mo = "";
      if(dtmo == 1){
        mo = "January";
      }
      if(dtmo == 2){
        mo = "February";
      }
      if(dtmo == 3){
        mo = "March";
      }
      if(dtmo == 4){
        mo = "April";
      }
      if(dtmo == 5){
        mo = "May";
      }
      if(dtmo == 6){
        mo = "June";
      }
      if(dtmo == 7){
        mo = "July";
      }
      if(dtmo == 8){
        mo = "August";
      }
      if(dtmo == 9){
        mo = "September";
      }
      if(dtmo == 10){
        mo = "October";
      }
      if(dtmo == 11){
        mo = "November";
      }
      if(dtmo == 12){
        mo = "December";
      }

    setState(() {
      bd = ststart.day.toString() + " " + mo.toString() + " " + ststart.year.toString();
    });

    }
  }
  meetserve(String url)async{
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: Text(
            'name_dot'.tr(),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          subtitle: Text(
            AppVar.userfullname,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          trailing:  Container(
            width: 56,
            height: 56,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: GestureDetector(
              onTap: (){
                meetserve("https://qoremed.qoreit.com/login");
              },
              child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  //backgroundImage: AssetImage('assets/images/icon_doctor_1.png'),
                  child:  ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Image.network(
                      AppVar.photo,
                      height: 56.0,
                      width: 56.0,
                    ),
                  )
              ),
            ),
          ),
        ),
        Divider(
          height: 0.5,
          color: Colors.grey[200],
          indent: 15,
          endIndent: 15,
        ),
        ProfileInfoTile(
          title: 'contact_number'.tr(),
          trailing: AppVar.ucontact,
          hint: 'Add phone number',
        ),
        ProfileInfoTile(
          title: 'email'.tr(),
          trailing: AppVar.useremail,
          hint: 'add_email'.tr(),
        ),
        ProfileInfoTile(
          title: 'gender'.tr(),
          trailing: AppVar.ugender,
          hint: 'add_gender'.tr(),
        ),
        ProfileInfoTile(
          title: 'date_of_birth'.tr(),
          trailing: bd,
          hint: 'yyyy mm dd',
        ),
        ProfileInfoTile(
          title: 'blood_group'.tr(),
          trailing: AppVar.ublood,
          hint: 'add_blood_group'.tr(),
        ),
        ProfileInfoTile(
          title: 'marital_status'.tr(),
          trailing: AppVar.ustatus,
          hint: 'add_marital_status'.tr(),
        ),
        SizedBox(
          height: 30,
        ),
        Center(
          child: Text("Update your profile using website app",style: TextStyle(color: Colors.black38, fontSize: 12),),
        ) ,
        Center(
          child: GestureDetector(
              onTap: (){
                meetserve("https://qoremed.qoreit.com/login");
              },
              child: Text("www.qoremed.com",style: TextStyle(color: Colors.red, fontSize: 12))),
        )
      ],
    );
  }
}
