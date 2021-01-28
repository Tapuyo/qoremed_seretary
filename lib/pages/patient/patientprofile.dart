import 'package:qoremed_app/myvars.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../components/round_icon_button.dart';
import '../../data/pref_manager.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';
import '../examination/examination_page.dart';
import '../prescription/prescription_page.dart';
import '../test/test_page.dart';
import '../visit/visit_page.dart';

class PatientProfile extends StatefulWidget {
  String something;
  PatientProfile(this.something);
  @override
  _ProfilePageState createState() => _ProfilePageState(this.something);
}

class _ProfilePageState extends State<PatientProfile>
    with AutomaticKeepAliveClientMixin<PatientProfile> {
  String somthing;

  _ProfilePageState(this.somthing);

  final _kTabTextStyle = TextStyle(
    color: kColorBlue,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  final _kTabPages = [
    VisitPage(),
    ExaminationPage(),
    TestPage(),
    //PrescriptionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    print('Enter profile');
    super.build(context);
    bool _isdark = Prefs.getBool(Prefs.DARKTHEME, def: false);

    var _kTabs = [
      Tab(
        text: 'Consultation'.tr(),
      ),
      Tab(
        text: 'Vitals'.tr(),
      ),
      Tab(
        text: 'Lab Result'.tr(),
      ),
      /* Tab(
        text: 'Triage Assessment'.tr(),
      ),*/
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Container(
        child:  Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              //color: Colors.white,
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage(
                      'assets/images/icon_man.png',
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppVar.patient_name,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          AppVar.patient_email,
                          style: TextStyle(
                            color: Colors.grey[350],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                /*  RoundIconButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(Routes.editProfile),
                    icon: Icons.edit,
                    size: 40,
                    color: kColorBlue,
                    iconColor: Colors.white,
                  ),*/
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: DefaultTabController(
                length: _kTabs.length,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _isdark
                            ? Colors.white.withOpacity(0.12)
                            : Color(0xfffbfcff),
                        border: Border(
                          top: BorderSide(
                            width: 1,
                            color: _isdark ? Colors.black87 : Colors.grey[200],
                          ),
                          bottom: BorderSide(
                            width: 1,
                            color: _isdark ? Colors.black87 : Colors.grey[200],
                          ),
                        ),
                      ),
                      child: TabBar(
                        indicatorColor: kColorBlue,
                        labelStyle: _kTabTextStyle,
                        unselectedLabelStyle:
                        _kTabTextStyle.copyWith(color: Colors.grey),
                        labelColor: kColorBlue,
                        unselectedLabelColor: Colors.grey,
                        tabs: _kTabs,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: _kTabPages,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
