import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../components/custom_button.dart';
import '../../components/text_form_field.dart';
import '../../utils/constants.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


enum Gender { male, female }

class SignupPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return  WebviewScaffold(
      url: "https://qoremed.qoreit.com/register",
      appBar: new AppBar(
        title: const Text('Registraion'),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );

  }




/*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 80,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 38),
                      child: Text(
                        'sign_up'.tr(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    WidgetSignup(),
                    Expanded(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 38),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${'already_a_member'.tr()} ?',
                              style: TextStyle(
                                color: Color(0xffbcbcbc),
                                fontSize: 12,
                                fontFamily: 'NunitoSans',
                              ),
                            ),
                            Text('   '),
                            InkWell(
                              borderRadius: BorderRadius.circular(2),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  'login'.tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }*/
}

class WidgetSignup extends StatefulWidget {
  @override
  _WidgetSignupState createState() => _WidgetSignupState();
}

class _WidgetSignupState extends State<WidgetSignup> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Gender _gender = Gender.male;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 38),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'first_name_dot'.tr(),
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                controller: _firstNameController,
                hintText: 'John',
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'last_name_dot'.tr(),
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                controller: _lastNameController,
                hintText: 'Doe',
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'gender_dot'.tr(),
                style: kInputTextStyle,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              Radio(
                value: Gender.male,
                groupValue: _gender,
                onChanged: (gender) {
                  setState(() {
                    _gender = gender;
                  });
                },
              ),
              Text(
                'male'.tr(),
                style: kInputTextStyle,
              ),
              SizedBox(
                width: 30,
              ),
              Radio(
                value: Gender.female,
                groupValue: _gender,
                onChanged: (gender) {
                  setState(() {
                    _gender = gender;
                  });
                },
              ),
              Text(
                'female'.tr(),
                style: kInputTextStyle,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 38),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'email_dot'.tr(),
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                controller: _emailController,
                hintText: 'bhr.tawfik@gmail.com',
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'password_dot'.tr(),
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                controller: _passwordController,
                hintText: '* * * * * *',
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'confirm_password_dot'.tr(),
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                controller: _confirmPasswordController,
                hintText: '* * * * * *',
                obscureText: true,
              ),
              SizedBox(
                height: 35,
              ),
              CustomButton(
                onPressed: () {},
                text: 'sign_up'.tr(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
