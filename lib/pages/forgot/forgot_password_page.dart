import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qoremed_app/myvars.dart';
import '../../components/custom_button.dart';
import '../../components/text_form_field.dart';
import '../../utils/constants.dart';

class ForgotPasswordPage extends StatefulWidget {
  String email;
  ForgotPasswordPage(this.email);
  @override
  _ForgotPasswordPage createState() => _ForgotPasswordPage(this.email);
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  String email;
  _ForgotPasswordPage(this.email);
  TextEditingController _emailController = new TextEditingController();


  @override
  void initState() {
    super.initState();
    _emailController.text = AppVar.useremail;
  }

  @override
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 80,
                        ),
                      ),
                      Text(
                        'forgot_password'.tr(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      WidgetForgot(email),
                      Center(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'login',
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(fontSize: 12),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class WidgetForgot extends StatefulWidget {
  String email;
  WidgetForgot(this.email);
  @override
  _WidgetForgotState createState() => _WidgetForgotState(this.email);
}

class _WidgetForgotState extends State<WidgetForgot> {
  String email;
  _WidgetForgotState(this.email);

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'email_dot'.tr(),
          style: kInputTextStyle,
        ),
        CustomTextFormField(
          controller: _emailController,
          //hintText: email,
        ),
        SizedBox(
          height: 35,
        ),
        CustomButton(
          onPressed: () {
            resetpass();

          },
          text: 'reset_password'.tr(),
        )
      ],
    );
  }
  resetpass(){
    String em = _emailController.text;
    if(em == ""){
      showqr(context, "Please fill up email.");
    }else{
      showqr(context, "We can't find a user with that email address.");
    }
  }
  showqr(BuildContext context, String mess) {
    Widget cancelButton = FlatButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("QoreMed"),
      content: Text(mess),
      actions: [
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
