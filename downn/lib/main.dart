import 'dart:io';
import 'dart:ui';
import 'package:downn/aboutUs.dart';
import 'package:downn/ads.dart';
import 'package:downn/downloadedPage.dart';
import 'package:downn/downloadingPage.dart';
import 'package:downn/howToDownload.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.initialize();
  // await Firebase.initializeApp();

  //MobileAds.instance.initialize();
  //NativeAds.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  final MaterialColor kPrimaryColor = const MaterialColor(
    0xff3742fa,
    const <int, Color>{
      50: const Color(0xff3742fa),
      100: const Color(0xff3742fa),
      200: const Color(0xff3742fa),
      300: const Color(0xff3742fa),
      400: const Color(0xff3742fa),
      500: const Color(0xff3742fa),
      600: const Color(0xff3742fa),
      700: const Color(0xff3742fa),
      800: const Color(0xff3742fa),
      900: const Color(0xff3742fa),
    },
  );
  //Color blue = Color(0xff3742fa);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: kPrimaryColor,
        ),
        home: FutureBuilder(
            future: _fbApp,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print("you have error: ${snapshot.error.toString()}");
                return MyHomePage(
                  analytics: analytics,
                  observer: observer,
                );
              } else if (snapshot.hasData) {
                return MyHomePage(
                  analytics: analytics,
                  observer: observer,
                );
              } else {
                return MyHomePage(
                  analytics: analytics,
                  observer: observer,
                );
              }
            })
        //MyHomePage(),
        );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
    this.analytics,
    this.observer,
  }) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //BannerAd ad;
  bool isLoading;
  Color blue = Color(0xff3742fa);
  int selected = 0;
  dynamic total;
  var pageController = PageController();

  AdsClass ads = AdsClass();
  var pages;
  var _url =
      'https://play.google.com/store/apps/details?id=com.kedhar.instasave';
  @override
  void initState() {
    super.initState();
    total = widget.observer;
    pages = [
      Downloadin(
        widget.analytics,
      ),
      DownloadedPage()
    ];
  }

  void dispose() {
    super.dispose();
  }

  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  Future<Null> sendAnalytics(String msg) async {
    await widget.analytics.logEvent(name: msg, parameters: <String, dynamic>{});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              // AppAvailability.launchApp("com.instagram.android");
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Image.asset("ImageAssets/instagram.png",
                  width: 25, height: 25),
            ),
          )
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu_rounded,
              color: Colors.black,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Center(
          child: Text(
            "SaveIn",
            style: TextStyle(
                color: Colors.grey[900], fontFamily: 'Billabong', fontSize: 30),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    Image.asset(
                      "ImageAssets/ic_launcher.png",
                      width: 45,
                      height: 45,
                    ),
                    SizedBox(width: 10),
                    Center(
                      child: Text(
                        "SaveIn",
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontFamily: 'Billabong',
                            fontSize: 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(
                Icons.lightbulb_outline,
                color: Colors.grey[900],
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
              title: Text('How to Download'),
              onTap: () {
                sendAnalytics("How to Download Opened");
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return HowToDownload();
                }));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.feedback_outlined,
                color: Colors.grey[900],
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
              title: Text('Feedback'),
              onTap: () {
                sendAnalytics("Feedback is clicked");
                _launchURL();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: Colors.grey[900],
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
              title: Text('About Us'),
              onTap: () {
                sendAnalytics("About Us is Opened");
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return AboutUs(widget.analytics);
                }));
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: PageView(
          controller: pageController,
          children: pages,
          onPageChanged: (index) {
            setState(() {
              selected = index;
            });
          },
        ),
        //checkBanner(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selected,
        selectedItemColor: blue,
        unselectedItemColor: Colors.grey[700],
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (value) {
          setState(() {
            selected = value;
            pageController.animateToPage(selected,
                duration: Duration(milliseconds: 500), curve: Curves.linear);
          });
        },
        items: [
          BottomNavigationBarItem(
            label: ('Home'),
            icon: Icon(Icons.home_rounded),
          ),
          BottomNavigationBarItem(
            label: ('Downloads'),
            icon: Icon(Icons.save_alt_rounded),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> installedApps;
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getApps() async {
    List<Map<String, String>> _installedApps;

    if (Platform.isAndroid) {
      _installedApps = await AppAvailability.getInstalledApps();

      print(await AppAvailability.checkAvailability("com.instagram.android"));

      print(await AppAvailability.isAppEnabled("com.android.chrome"));
    }

    setState(() {
      installedApps = _installedApps;
    });
  }
}
