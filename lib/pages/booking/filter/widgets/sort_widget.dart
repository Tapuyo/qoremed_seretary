import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

enum SortBy { nothing, fee }

class SortWidget extends StatefulWidget {
  final Color color;

  const SortWidget({Key key, @required this.color}) : super(key: key);
  @override
  _SortWidgetState createState() => _SortWidgetState();
}

class _SortWidgetState extends State<SortWidget> {
  double _currentSliderValue = 20;
  bool checkedValue = true;


  @override
  void initState() {
    super.initState();
    _currentSliderValue = 100;
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
              'Range',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        CheckboxListTile(
          title: Text("Enable Distance (km)"),
          value: checkedValue,
          onChanged: (newValue) {
            setState(() {
              checkedValue = newValue;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
        ),
        Slider(
          value: _currentSliderValue,
          min: 0,
          max: 100,
          divisions: 5,
          label: _currentSliderValue.round().toString() + "km",
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
            });
          },
        )
      ],
    );
  }
}
