import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qoremed_app/myvars.dart';
import '../../../components/custom_button.dart';
import '../../../data/pref_manager.dart';
import '../../../utils/constants.dart';
import 'widgets/widgets.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  Color _color;

  @override
  void initState() {
    super.initState();
    _color = _isDark ? Colors.white.withOpacity(0.12) : Colors.grey[200];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorBlue,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        title: Text(
          'filter'.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SortWidget(
                      color: _color,
                    ),
                    AvailabilityWidget(
                      color: _color,
                    ),
                   /* GenderWidget(
                      color: _color,
                    ),
                    ConsultationFeeWidget(
                      color: _color,
                    ),
                    Container(
                      width: double.infinity,
                      height: 10,
                      color: _color,
                    ),*/
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: CustomButton(
                onPressed: () {
                  setState(() {
                    AppVar.uaddress = "Mabuhay ,Carmona, Cavite";
                  });
                },
                text: 'apply'.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
