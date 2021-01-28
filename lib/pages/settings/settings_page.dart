import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/pref_manager.dart';
import '../../utils/app_themes.dart';
import '../../utils/themebloc/theme_bloc.dart';
import 'widgets/widgets.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin<SettingsPage> {
  var _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  Color _color;

  @override
  void initState() {
    super.initState();
    _color = _isDark ? Colors.white.withOpacity(0.12) : Colors.grey[200];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            _isDark ? Colors.white.withOpacity(0.12) : Colors.grey[200],
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Material(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SettingsWidget(
                  color: _color,
                ),
                GeneralWidget(
                  isDark: _isDark,
                  onDarkPressed: (darkTheme) {
                    setState(() {
                      _isDark = darkTheme;
                      Prefs.setBool(Prefs.DARKTHEME, darkTheme);
                      context.bloc<ThemeBloc>().add(ThemeChanged(
                          theme: darkTheme
                              ? AppTheme.DarkTheme
                              : AppTheme.LightTheme));
                      _color = _isDark
                          ? Colors.white.withOpacity(0.12)
                          : Colors.grey[200];
                    });
                  },
                ),
                AccountWidget(
                  color: _color,
                ),
                SizedBox(
                  height: 60,
                  child: Container(
                    color: _color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
