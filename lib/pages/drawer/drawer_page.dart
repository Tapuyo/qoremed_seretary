import 'package:qoremed_app/myvars.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qoremed_app/pages/appointment/my_appointments_page.dart';
import 'package:qoremed_app/pages/appointment/upcoming_appointments_page.dart';
import 'package:qoremed_app/pages/clinics/cliniclist.dart';
import 'package:qoremed_app/pages/patient/my_patient_list_page.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';

class DrawerPage extends StatelessWidget {
  final Function onTap;

  userimage(){

    if(AppVar.photo == ""){
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey,
        backgroundImage: AssetImage(
          'assets/images/icon_man.png',
        ),

      );
    }else{
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.blue,
        child: Image.network(AppVar.photo),
      );
    }
  }

  const DrawerPage({Key key, @required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Scaffold(
        backgroundColor: kColorPrimary,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 35,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      userimage(),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppVar.fname,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),

                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                _drawerItem(
                  image: 'person',
                  text: 'My Doctors',
                  onTap: () =>
                      Navigator.of(context).pushNamed(Routes.myDoctors),
                ),
                _drawerItem(
                  image: 'person',
                  text: 'My Patient',
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyPatientListPage(),
                        ),
                      );
                    }
                ),
                _drawerItem(
                  image: 'hospital',
                  text: 'My Clinic',
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ClinicList(),
                      ),
                    );
                  }

                ),
                _drawerItem(
                    image: 'calendar',
                    text: 'My Appointment',
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyAppointmentsPage(),
                        ),
                      );
                    }

                ),
               /* _drawerItem(
                  image: 'hospital',
                  text: 'hospitals',
                  onTap: () {},
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell _drawerItem({
    @required String image,
    @required String text,
    @required Function onTap,
  }) {
    return InkWell(
      onTap: () {
        onTap();
        //this.onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 58,
        child: Row(
          children: <Widget>[
            Image.asset(
              'assets/images/$image.png',
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              text.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
