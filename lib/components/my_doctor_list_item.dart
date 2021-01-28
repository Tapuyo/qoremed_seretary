import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../model/doctor.dart';
import '../utils/constants.dart';
import 'custom_button.dart';

class MyDoctorListItem extends StatelessWidget {
  final Doctor doctor;

  const MyDoctorListItem({Key key, @required this.doctor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xffEBF2F5),
      ),
      child: Row(
        children: <Widget>[
          Image.asset(
            doctor.avatar,
            width: 80,
            height: 80,
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  doctor.name,
                  style: TextStyle(
                    color: kColorPrimaryDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  doctor.speciality + '\n',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          CustomButton(
            text: 'details'.tr(),
            textSize: 14,
            onPressed: () {},
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 5,
            ),
          )
        ],
      ),
    );
  }
}
