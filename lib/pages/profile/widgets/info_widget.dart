import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qoremed_app/myvars.dart';
import 'profile_info_tile.dart';

class InfoWidget extends StatelessWidget {
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
          trailing: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey,
            //backgroundImage: NetworkImage(avatarUrl),
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
          trailing: AppVar.ubdate,
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
        Container(
          padding: EdgeInsets.fromLTRB(15,10,15,0),
          child: Row(
            children: [
              Text('Address', style: TextStyle(color: Colors.grey,),),
              Container(width: 40,),
              Expanded(child: Text(AppVar.uaddress, style: TextStyle(color: Colors.black,),))
            ],
          ),
        ),
      ],
    );
  }
}
