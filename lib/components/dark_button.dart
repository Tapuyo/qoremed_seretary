import 'package:flutter/material.dart';

import '../utils/constants.dart';

class DarkButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final double elevation;
  final int borderRadius;
  final EdgeInsets padding;
  final double textSize;

  const DarkButton({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.textSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: elevation ?? 0,
      fillColor: kColorDarkBlue,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 4)),
      child: Padding(
        padding: padding ??
            const EdgeInsets.only(top: 9, bottom: 10, left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: Theme.of(context).textTheme.button.copyWith(
                  color: Colors.white,
                  fontSize:
                  textSize ?? Theme.of(context).textTheme.button.fontSize),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
