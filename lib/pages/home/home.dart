import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qoremed_app/model/doctor.dart';
import 'package:qoremed_app/pages/notifications/notdetails.dart';
import 'package:qoremed_app/pages/notifications/notifpage.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';
import '../drawer/drawer_page.dart';
import '../messages/messages_page.dart';
import '../messages/myprofile.dart';
import '../profile/profile_page.dart';
import '../settings/settings_page.dart';
import 'home_page.dart';
import 'widgets/widgets.dart';
import 'package:qoremed_app/myvars.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qrscan/qrscan.dart' as scanner;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  List mylist = [];
  int numnot = 0;
  bool notifnum = false;
  bool isDrawerOpen = false;

  int _selectedIndex = 0;

  static PageController _pageController;

  @override
  void initState() {
    super.initState();
    getNotif();
    _pageController = PageController(
      initialPage: _selectedIndex,
    );
  }
  showqr(BuildContext context, String mess) {
    Widget cancelButton = FlatButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          Text("QoreMed"),
          Container(width: 10,),
          Icon(Icons.signal_wifi_off, color: Colors.redAccent)
        ],
      ),
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

  Future getNotif() async{
    numnot = 0;
    print("notif na ");
    notifnum = false;
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/notifications/";
    final response = await http.get(url,headers: headers);


    var jsondata = json.decode(response.body)['data'];

    for (var u in jsondata){
      if(u['read_at'] == null){
        numnot = numnot + 1;
      }

    }

    setState(() {
      AppVar.notifnum = numnot;
      if(numnot > 0){
        notifnum = true;
      }
      else{
        notifnum = false;
      }
    });
  }
  Future _scan() async {
    String barcode = await scanner.scan();
    print("QR Code Scann");
    print(barcode);
    setState(() {
      String scancode = barcode;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotDetails(scancode),
        ),
      );
    });
  }
  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _selectPage(int index) {
    if (_pageController.hasClients) _pageController.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _pages = [
      HomePage(),
      ProfilePage(),
      MyProfile(),
      SettingsPage(),
    ];
    return Stack(
      children: <Widget>[
        DrawerPage(
          onTap: () {
            setState(
              () {
                xOffset = 0;
                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
              },
            );
          },
        ),
        AnimatedContainer(
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor)
            ..rotateY(isDrawerOpen ? -0.5 : 0),
          duration: Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0),
            child: Scaffold(
              appBar: AppBar(
                leading: isDrawerOpen
                    ? IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          setState(
                            () {
                              xOffset = 0;
                              yOffset = 0;
                              scaleFactor = 1;
                              isDrawerOpen = false;
                            },
                          );
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          setState(() {
                            xOffset = size.width - size.width / 3;
                            yOffset = size.height * 0.1;
                            scaleFactor = 0.8;
                            isDrawerOpen = true;
                          });
                        },
                      ),
                title: AppBarTitleWidget(),
                actions: <Widget>[
                 /* _selectedIndex == 2
                      ? IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NotifPage(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.notifications_none, color: notifnum == true ? kColorDarkBlue : Colors.grey,size: 30,
                          ),
                        )
                      : Stack(
                        children: <Widget>[


                          IconButton(
                            onPressed: () {
                              getNotif();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => NotifPage(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.notifications_none, color: notifnum == true ? kColorDarkBlue : Colors.grey,size: 30,
                            ),
                          ),
                          Visibility(
                            visible: notifnum,
                            child: Positioned(
                              top: 20,
                              right: 10,
                              child: Container(
                                width: 20,

                                child: CircleAvatar(
                                  backgroundColor: kColorBlue,
                                      child: Text(AppVar.notifnum.toString(), style: TextStyle(color: Colors.white, fontSize: 8),)

                                ),
                              ),
                            ),
                          ),


                        ],
                      ),*/
                  Stack(
                    children: <Widget>[


                      IconButton(
                        onPressed: () {
                          getNotif();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NotifPage(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.notifications_none, color: notifnum == true ? kColorDarkBlue : Colors.grey,size: 30,
                        ),
                      ),
                      Visibility(
                        visible: notifnum,
                        child: Positioned(
                          top: 20,
                          right: 10,
                          child: Container(
                            width: 20,

                            child: CircleAvatar(
                                backgroundColor: kColorBlue,
                                child: Text(AppVar.notifnum.toString(), style: TextStyle(color: Colors.white, fontSize: 8),)

                            ),
                          ),
                        ),
                      ),


                    ],
                  ),
                ],
              ),
              body: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: _pages,
              ),
            /*  floatingActionButton: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x202e83f8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {
                      _scan();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kColorBlue,
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,*/
              bottomNavigationBar: BottomAppBar(
                elevation: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: NavBarItemWidget(
                        onTap: () {
                          _selectPage(0);
                        },
                        iconData: Icons.home,
                        text: 'home'.tr(),
                        color: _selectedIndex == 0 ? kColorBlue : Colors.grey,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: NavBarItemWidget(
                        onTap: () {
                          if(AppVar.online == true){
                            _selectPage(1);
                          }else
                          {
                            _selectPage(0);
                          }
                        },
                        iconData: Icons.calendar_today_sharp,
                        text: 'Calendar',
                        color: _selectedIndex == 1 ? kColorBlue : Colors.grey,
                      ),
                    ),
                 /*   Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 1,
                      ),
                    ),*/
                    Expanded(
                      flex: 1,
                      child: NavBarItemWidget(
                        onTap: () {
                          if(AppVar.online == true){
                            _selectPage(2);
                          }else
                            {
                              _selectPage(0);
                            }
                        },
                        iconData: Icons.person,
                        text: 'Profile',
                        color: _selectedIndex == 2 ? kColorBlue : Colors.grey,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: NavBarItemWidget(
                        onTap: () {
                          _selectPage(3);
                        },
                        iconData: Icons.settings,
                        text: 'settings'.tr(),
                        color: _selectedIndex == 3 ? kColorBlue : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
