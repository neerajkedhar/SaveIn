import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:downn/ads.dart';
import 'package:downn/imageView.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UserProfile extends StatefulWidget {
  UserProfile(this.analytics);
  FirebaseAnalytics analytics;
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Future<Null> sendAnalytics(String msg) async {
    await widget.analytics.logEvent(name: msg, parameters: <String, dynamic>{});
  }

  var fieldText = TextEditingController();
  Color backGroundwhite = Color(0xf3f5f8ff);
  var noImage =
      "https://st4.depositphotos.com/14953852/24787/v/600/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg";

  Color blue = Color(0xff3742fa);
  var dio = Dio();
  double progress = 0.0;
  var path;

  @override
  void initState() {
    super.initState();
    _getClipboard();
    loadNativeAd();
    nativeAdCallbacks();
  }

  nativeAdCallbacks() {
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
  }

  @override
  void dispose() {
    super.dispose();
    fieldText.dispose();
  }

  loadNativeAd() {
    controller.load(
      options: NativeAdOptions(),
      unitId: nativeAdUnitID,
    );
  }

  static const nativeAdUnitID = "ca-app-pub-3071933490034842/4815517602";

  final controller = NativeAdController();
  AdsClass ads = AdsClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Insta Saver",
            style: TextStyle(color: Colors.grey[900]),
            textDirection: TextDirection.ltr),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 70,
                child: TextField(
                    cursorColor: Colors.grey[700],
                    controller: fieldText,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Instagram User name',
                      suffixIcon: fieldText.text.isEmpty
                          ? null
                          : InkWell(
                              onTap: () => fieldText.clear(),
                              child: Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                            ),
                      border: new OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    onSubmitted: (fieldText) {
                      evaluate(fieldText);
                    }),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: ElevatedButton(
                        onPressed: () {
                          _getClipboard();
                        },
                        child: Text(
                          "Paste Link",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(backGroundwhite),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              side: BorderSide(color: Colors.grey[700]),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: ElevatedButton(
                        onPressed: () {
                          evaluate(fieldText.text);
                        },
                        child: Text("Download"),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(blue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              side: BorderSide(color: blue),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isVisible,
                child: GestureDetector(
                  onTap: () {
                    File file = File("$path");
                    if (file.existsSync()) {
                      if (path.endsWith('.jpg')) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return ImageView(path);
                        }));
                      }
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    height: 130,
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 0,
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 33,
                                  child: Container(
                                    color: Colors.pink,
                                    child: Image.network(
                                      picUrl != null ? picUrl : noImage,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 66,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 50,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 35.0,
                                              top: 15,
                                              bottom: 5,
                                              left: 15),
                                          child: Container(
                                            // color: Colors.pink,
                                            child: Text(
                                                userName != null
                                                    ? userName
                                                    : "User Name",
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.grey[900],
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17)),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 50,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 35.0,
                                              top: 0,
                                              bottom: 15,
                                              left: 15),
                                          child: Container(
                                            // color: Colors.pink,
                                            child: Text(
                                                bio != null ? bio : "No Bio!",
                                                maxLines: 2),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            width: MediaQuery.of(context).size.width,
                            bottom: 0.0,
                            child: LinearProgressIndicator(
                              minHeight: 10,
                              backgroundColor: blue.withOpacity(0.3),
                              value: progress / 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              nativeAdAdmob(),
            ],
          ),
        ),
      ),
    );
  }

  void evaluate(String url) {
    if (url.length > 35) {
      processUrl(url);
    } else {
      downloadPic(url);
    }
  }

  processUrl(String url) {
    var linkEdit = url.replaceAll(" ", "").split("/").sublist(3, 4).join(" ");
    var userName = linkEdit.split("?");

    downloadPic(userName[0]);
  }

  bool isVisible = false;
  var response;
  String picUrl;
  var userName;
  var bio;
  downloadPic(var url) async {
    var instagram = "https://www.instagram.com/$url/?__a=1";
    print(instagram);
    try {
      response = await dio.get(instagram);
      print(response.data);
      setState(() {
        picUrl = response.data['graphql']['user']['profile_pic_url_hd'];
        userName = response.data['graphql']['user']['username'];
        bio = response.data['graphql']['user']['biography'];
      });
      if (userName != null) {
        setState(() {
          isVisible = true;
        });
      }
      //  downloadNow(picUrl);
      saveFile(picUrl, "$url.jpg");
    } on DioError catch (e) {
      if (e.response.statusCode == (404) ||
          e.response.statusCode == (505) ||
          e.response.statusCode == (504)) {
        notInstagramLinkPopUp();
      }
    }
  }

  downloadNow(String val) {}
  bool downloaded;
  Future<bool> saveFile(String url, String fileName) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          print(directory.path);
          String newPath = "";
          List<String> folders = directory.path.split("/");

          ///storage/emulated/0/Android/data/com.example.downn/files
          for (int x = 1; x < folders.length; x++) {
            String folder = folders[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/InstaDownloader";
          directory = Directory(newPath);
          print(directory.path);
        }
      } else {
        return false;
      }
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File saveFile = File(directory.path + "/$fileName");
        await dio.download(url, saveFile.path,
            onReceiveProgress: (downloaded, totalSize) {
          setState(() {
            progress = downloaded / totalSize * 100;
            print(progress);
            if (progress >= 100.0) {
              sendAnalytics("ProfilePicture Downloaded");
              path = "/storage/emulated/0/InstaDownloader/$fileName";
              print(path);
            }
          });
        });
        return true;
      }
    } catch (e) {
      print("Errorrrr......:$e");
    }

    return false;
  }

  _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  checkingInternet(String link) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      print(connectivityResult);
      downloadPic(link);
    } else {
      noInternetPopUp();
      print("check for internet");
      print(connectivityResult);
    }
  }

  void _getClipboard() async {
    ClipboardData data = await Clipboard.getData(Clipboard.kTextPlain);
    setState(() {
      fieldText.text = data.text;
    });
  }

//////////////////////////////////////////////////////////////////////////////////////////
  notInstagramLinkPopUp() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              margin: EdgeInsets.all(20),
              width: 300.0,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    "ImageAssets/404.jpg",
                    width: 200,
                    height: 200,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                          child: Text(
                        "Oops!!",
                        style: TextStyle(
                          color: blue.withOpacity(0.9),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Link is either broken or not an Instagram Link. Try with a valid Instagram link",
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 300,
                        height: 45,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(blue),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                side: BorderSide(color: blue),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "okay",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

//////////////////////////////////////////////////////////////////////////////////////////////////

  noInternetPopUp() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              margin: EdgeInsets.all(20),
              width: 300.0,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    "ImageAssets/nointernet.png",
                    width: 200,
                    height: 200,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                          child: Text(
                        "Whoops !!",
                        style: TextStyle(
                          color: blue.withOpacity(0.9),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Slow or no internet connection. \nPlease check your internet settings and try again",
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 300,
                        height: 45,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(blue),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                side: BorderSide(color: blue),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "okay",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget nativeAdAdmob() {
    return NativeAd(
      controller: controller,
      height: 320,
      unitId: nativeAdUnitID,
      builder: (context, child) {
        return Material(
          elevation: 0,
          child: child,
        );
      },
      buildLayout: mediumAdTemplateLayoutBuilder,
      // loading: Text('loading'),
      // error: Text('error'),
      icon: AdImageView(size: 40),
      headline: AdTextView(
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        maxLines: 1,
      ),
      body: AdTextView(style: TextStyle(color: Colors.black), maxLines: 1),
      media: AdMediaView(
        height: 170,
        width: MATCH_PARENT,
      ),
      attribution: AdTextView(
        width: WRAP_CONTENT,
        text: 'Ad',
        decoration: AdDecoration(
          border: BorderSide(color: Colors.green, width: 1),
          borderRadius: AdBorderRadius.all(10.0),
        ),
        style: TextStyle(color: Colors.green, fontSize: 10),
        padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
      ),
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
}
