import 'package:downn/main.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
//import 'package:share_extend/share_extend.dart';
import 'package:share_it/share_it.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  AboutUs(this.analytics);
  FirebaseAnalytics analytics;
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  Future<Null> sendAnalytics(String msg) async {
    await widget.analytics.logEvent(name: msg, parameters: <String, dynamic>{});
  }

  static const adUnitID = "ca-app-pub-3071933490034842/4815517602";
  final controller = NativeAdController();
  var _url =
      'https://play.google.com/store/apps/details?id=com.kedhar.instasave';

  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  void _launchPrivacyPolicy() async => await canLaunch(
          "https://kedhar-app-development-studios.github.io/Privacy-Policy/")
      ? await launch(
          "https://kedhar-app-development-studios.github.io/Privacy-Policy/")
      : throw "could not launch url";
  Color blue = Color(0xff3742fa);
  @override
  void initState() {
    super.initState();
    controller.onEvent.listen((e) {
      final event = e.keys.first;
      switch (event) {
        case NativeAdEvent.loading:
          print('loading');
          break;
        case NativeAdEvent.loaded:
          print('loaded');
          break;
        case NativeAdEvent.loadFailed:
          final errorCode = e.values.first;
          print('loadFailed $errorCode');
          break;
        case NativeAdEvent.muted:
          showDialog(
            builder: (_) => AlertDialog(title: Text('Ad muted')),
            context: null,
          );
          break;
        default:
          break;
      }
    });
    load();
  }

  load() {
    controller.load(
      options: NativeAdOptions(),
      unitId: adUnitID,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey[800],
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return MyApp();
            }));
          },
        ),
        title: Text(
          "About Us",
          style: TextStyle(color: Colors.grey[800]),
        ),
      ),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                  child: Image.asset(
                "ImageAssets/ic_launcher.png",
                width: 100,
                height: 100,
              )),
              SizedBox(height: 10),
              Text(
                "SaveIn",
                style: TextStyle(fontFamily: "Billabong", fontSize: 50),
              ),
              Text(
                "V1.0.0",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 30,
              ),
              ListTile(
                title: Text('Storage Location'),
                subtitle: Text("/storage/emulated/0/SaveIn"),
                onTap: () {},
              ),
              ListTile(
                title: Text('Invite a friend'),
                subtitle: Text("Invite your friends to use SaveIn"),
                onTap: () {
                  sendAnalytics("Invite_Your_Friend_is_Clicked");
                  ShareIt.link(url: _url, androidSheetTitle: 'Google');
                },
              ),
              ListTile(
                title: Text('Rate Us'),
                subtitle: Text(
                    "Like using SaveIn to download Instagram Posts? Let us know by giving a 5 star rating"),
                onTap: () {
                  sendAnalytics("Rate_us_is_Clicked");
                  _launchURL();
                },
              ),
              ListTile(
                title: Text('Report'),
                subtitle: Text(
                    "Found any bugs or have any suggestions? Let us know!"),
                onTap: () {
                  sendAnalytics("Report_is_clicked");
                  _launchURL();
                },
              ),
              ListTile(
                title: Text('Privacy Policy'),
                onTap: () {
                  _launchPrivacyPolicy();
                },
              ),
              ListTile(
                title: Text('Disclaimer'),
                onTap: () {
                  showAlertDialog(context);
                },
              ),
              nativeAd()
            ],
          ),
        ),
      )),
    );
  }

  Widget nativeAd() {
    return NativeAd(
      controller: controller,
      height: 100,
      unitId: adUnitID,
      builder: (context, child) {
        return Material(
          elevation: 0,
          child: child,
        );
      },
      buildLayout: secondBuilder,
      icon: AdImageView(size: 80),
      headline: AdTextView(
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
        maxLines: 1,
      ),
      media: AdMediaView(height: 80, width: 120),
      button: AdButtonView(
        elevation: 18,
        decoration: AdDecoration(
          backgroundColor: Colors.blue,
          borderRadius: AdBorderRadius.all(17.0),
        ),
        height: MATCH_PARENT,
        textStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  AdLayoutBuilder get secondBuilder => (ratingBar, media, icon, headline,
          advertiser, body, price, store, attribution, button) {
        return AdLinearLayout(
          padding: EdgeInsets.all(10),
          width: MATCH_PARENT,
          orientation: HORIZONTAL,
          decoration: AdDecoration(
            gradient: AdRadialGradient(
              colors: [Colors.white, Colors.white],
              center: Alignment(0.5, 0.5),
              radius: 1000,
            ),
          ),
          children: [
            icon,
            AdLinearLayout(
              children: [
                headline,
                AdLinearLayout(
                  children: [attribution, advertiser, ratingBar],
                  orientation: HORIZONTAL,
                  width: WRAP_CONTENT,
                  height: 20,
                ),
                button,
              ],
              margin: EdgeInsets.symmetric(horizontal: 4),
            ),
          ],
        );
      };

  showAlertDialog(BuildContext scontext) {
    Widget okButton = TextButton(
      child: Text("Got it"),
      onPressed: () {
        Navigator.of(scontext).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Disclaimer"),
      content: Container(
        color: Colors.grey[100],
        height: 300,
        child: SingleChildScrollView(
          child: Text(
              "- SaveIn is not affiliated with Instagram. its a tool for downloading \u0022Public\u0022 posts from Instagram.\n\n- We respect the copyright of the owners/creators. So please do not download any posts without owner's consent.\n\n- SaveIn is only for your personal study and research, so please do not use our service to download posts for any commercial use.\n\n- We(SaveIn / Kedhar Studios) are not responsible if you are using our services for any illegal activities "),
        ),
      ),
      actions: [
        okButton,
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
