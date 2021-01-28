import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qoremed_app/myvars.dart';

enum Availability { anyDay, today, next3Days, commingWeekend }

class AvailabilityWidget extends StatefulWidget {
  final Color color;

  const AvailabilityWidget({Key key, @required this.color}) : super(key: key);
  @override
  _AvailabilityWidgetState createState() => _AvailabilityWidgetState();
}

class _AvailabilityWidgetState extends State<AvailabilityWidget> {
  Availability _availability = Availability.anyDay;
  bool checkedValue = true;


  @override
  void initState() {
    super.initState();
    checkedValue = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          color: widget.color,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text(
              'Location',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        CheckboxListTile(
          title: Text("Enable Location"),
          value: checkedValue,
          onChanged: (newValue) {
            setState(() {
              checkedValue = newValue;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
        ),

        Container(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Text("Address", style: TextStyle(fontSize: 16),),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [

                Expanded(child: Text(AppVar.uaddress, style: TextStyle(fontSize: 16),)),
              ],
            ),
          ),
        ),

      ],
    );
  }
}
