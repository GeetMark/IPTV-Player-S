import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iptvplayer/l10n/localization.dart';
import 'package:iptvplayer/navbar/curved_navigation_bar.dart';
import 'package:iptvplayer/pages/list_iptv.dart';
import 'package:iptvplayer/pages/favorite_page.dart';
import 'package:iptvplayer/pages/home.dart';

Future<void> main() async {

  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
   Firebase.initializeApp();
   Admob.initialize();

}

class MyApp extends StatelessWidget {
  String languageCode = Platform.localeName.split('_')[0];
  @override
  Widget build(BuildContext context) {
    bool isRTL = languageCode == "ar";

    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900], colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blue[600]),

      ),
      home: Directionality(
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        child: Builder(
          builder: (context) {
            Localization.setLanguage(languageCode);
            return BottomNavBar();
          },
        ),
      ),
      builder: EasyLoading.init(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.favorite, size: 30),
          Icon(Icons.grid_view, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.cyan.shade50,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: _buildPage(),
    );
  }

  Widget _buildPage() {
    switch (_page) {
      case 0:
        return HomePage();
      case 1:
        return FavoritePage();
      case 2:
        return ListIptvPage();
      default:
        return HomePage();//Container();
    }
  }
}
