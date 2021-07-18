import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:downn/ads.dart';
import 'package:downn/directPlayer.dart';
import 'package:downn/imageView.dart';
import 'package:downn/userProfile.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:firebase_analytics/observer.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Downloadin extends StatefulWidget {
  Downloadin(this.analytics, {Key key}) : super(key: key);
  final FirebaseAnalytics analytics;

  @override
  DownloadinState createState() => DownloadinState();
}

class DownloadinState extends State<Downloadin> {
  StreamSubscription _intentDataStreamSubscription;
  static const nativeAdUnitID = "ca-app-pub-3071933490034842/4815517602";
  Future<Null> sendAnalytics(String msg) async {
    await widget.analytics.logEvent(name: msg, parameters: <String, dynamic>{});
  }

  final controller = NativeAdController();
  AdsClass ads = AdsClass();
  @override
  void initState() {
    super.initState();
    ads.initializeInter();
    ads.loadInterstitialAd();
    loadNativeAd();
    nativeAdCallbacks();
    _getClipboard();
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      downloadReels(value);
      setState(() {
        fieldText.text = value;
        print("Shared: $value from 1 function");
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      downloadReels(value);
      setState(() {
        fieldText.text = value;
        print("Shared: $value from 2 function");
        downloadReels(value);
      });
    });
  }

  loadNativeAd() {
    controller.load(
      options: NativeAdOptions(),
      unitId: nativeAdUnitID,
    );
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

  double progress = 0.0;
  var description;
  var pageName;
  var pathName;
  var downloading = false;
  bool loading = false;
  var dio = Dio();
  var fieldText = TextEditingController();
  var titlePreview;
  var imagePreview;
  var descriptionPreview;
  var noImage =
      "https://st4.depositphotos.com/14953852/24787/v/600/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg";

  Color backGroundwhite = Color(0xf6f7f9ff);
  Color blue = Color(0xff3742fa);
  // var _clipboardTextValue;
  bool isVisible = false;
  var displayUrl;
  var path;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backGroundwhite,
      child: SafeArea(
        minimum: const EdgeInsets.all(10.0),
        child: Container(
          child: Container(
            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Container(
                  child: Column(
                    children: [
                      Container(
                        height: 70,
                        child: TextField(
                            cursorColor: Colors.grey[700],
                            controller: fieldText,
                            decoration: InputDecoration(
                              filled: true,
                              // fillColor: Colors.blueGrey[100].withOpacity(0.3),
                              hintText: 'Instagram post link',
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
                              // enabledBorder: UnderlineInputBorder(
                              //   // borderSide: BorderSide(color: Colors.black),
                              //   borderRadius: BorderRadius.circular(7),
                              // ),
                            ),
                            onSubmitted: (fieldText) {}),
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
                                  getClipboardText();
                                  // ads.showInterstitial();
                                },
                                child: Text(
                                  "Paste Link",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          backGroundwhite),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
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
                                  downloadReels(fieldText.text);
                                },
                                child: Text("Download"),
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Visibility(
                  visible: isVisible,
                  child: GestureDetector(
                    onTap: () {
                      File file = File("$path");
                      if (file.existsSync()) {
                        if (path.endsWith('.jpg')) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return ImageView(path);
                          }));
                        } else if (path.endsWith('.mp4')) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return Direct(path);
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
                        margin:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
                                        displayUrl != null
                                            ? displayUrl
                                            : noImage,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 66,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                  pageName != null
                                                      ? pageName
                                                      : "Page Name",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.grey[900],
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                  description != null
                                                      ? description
                                                      : "Post Description Goes Here!",
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
                              // clipBehavior: Clip.antiAliasWithSaveLayer,
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
                // Container(
                //   height: 70,
                //   width: MediaQuery.of(context).size.width,
                //   child: GestureDetector(
                //       onTap: () {
                //         sendAnalytics("Moving to UserProfile Section");
                //         Navigator.push(context, MaterialPageRoute(builder: (_) {
                //           return UserProfile(widget.analytics);
                //         }));
                //       },
                //       child: Card(
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10.0),
                //         ),
                //         margin: EdgeInsets.all(0),
                //         elevation: 0,
                //         color: blue.withOpacity(0.8),
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 Icon(
                //                   Icons.account_circle_sharp,
                //                   color: Colors.white,
                //                   size: 50,
                //                 ),
                //                 Text(
                //                   "Download Instagram User Profile Picture",
                //                   style: TextStyle(
                //                     color: Colors.white,
                //                     fontSize: 15,
                //                   ),
                //                 ),
                //                 Icon(
                //                   Icons.arrow_forward_ios,
                //                   color: Colors.white,
                //                   size: 20,
                //                 ),
                //               ]),
                //         ),
                //       )),
                // ),
                nativeAdAdmob(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  downloadReels(String link) {
    setState(() {
      loading = true;
    });
    checkingInternet(link);
    setState(() {
      loading = false;
    });
  }

  fetchReels(String link) async {
    print(link);
    var linkEdit = link.replaceAll(" ", "").split("/");
    print(linkEdit);
    if (linkEdit.contains("www.instagram.com")) {
      print('${linkEdit[0]}//${linkEdit[2]}/${linkEdit[3]}/${linkEdit[4]}' +
          "/?__a=1");
      var response;
      try {
        response = await dio.get(
            '${linkEdit[0]}//${linkEdit[2]}/${linkEdit[3]}/${linkEdit[4]}' +
                "/?__a=1");
      } on DioError catch (e) {
        print("printing the e response...> ${e.response.statusCode}");

        if (e.response.statusCode == (404) ||
            e.response.statusCode == (505) ||
            e.response.statusCode == (504)) {
          privatePostPopUp();
        }
      }

      print("printing the response...> ${response.statusCode}");
      var graphql = response.data['graphql'];
      print(graphql);
      var shortcodeMedia = graphql['shortcode_media'];
      var isVideo = shortcodeMedia['is_video'];
      print("checking if its a video....>$isVideo");
      var shortCode = shortcodeMedia['shortcode'];
      var checkingEdge =
          shortcodeMedia['edge_media_to_caption']['edges'].length;
      if (checkingEdge > 0) {
        description =
            shortcodeMedia['edge_media_to_caption']['edges'][0]['node']['text'];
      } else {
        description = "";
      }

      if (description != null) {
        setState(() {
          isVisible = true;
        });
      }
      print(description);
      var printingDescription = getFirstWords(description, 10);
      pageName = shortcodeMedia['owner']['username'];
      displayUrl = shortcodeMedia['display_url'];
      if (isVideo) {
        var fileUrl = shortcodeMedia['video_url'];
        print(fileUrl);
        pathName = "$pageName $shortCode $printingDescription";
        downloaded = await saveFile(
            fileUrl, "$pageName $shortCode $printingDescription.mp4");
      } else {
        var fileUrl = shortcodeMedia['display_resources'][2]['src'];
        print(fileUrl);
        downloaded = await saveFile(
            fileUrl, "$pageName $shortCode $printingDescription.jpg");
      }
    } else {
      notInstagramLinkPopUp();
    }
  }

  String getFirstWords(String sentence, int wordCounts) {
    if (sentence.split(' ').length > wordCounts) {
      return sentence.split(" ").sublist(0, wordCounts).join(" ");
    } else {
      return sentence
          .split(" ")
          .sublist(0, sentence.split(' ').length)
          .join(" ");
    }
  }

  checkingInternet(String link) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      print(connectivityResult);
      fetchReels(link);
    } else {
      noInternetPopUp();
      print("check for internet");
      print(connectivityResult);
    }
  }

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
          for (int x = 1; x < folders.length; x++) {
            String folder = folders[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/SaveIn";
          directory = Directory(newPath);
          print("directory.path :" + directory.path);
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
              ads.showInterstitial();
              ads.interstitialAdCallbacks();
              sendAnalytics("File Downloaded");
              path = "/storage/emulated/0/SaveIn/$fileName";
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

  void _getClipboard() async {
    ClipboardData data = await Clipboard.getData(Clipboard.kTextPlain);
    setState(() {
      fieldText.text = data.text;
    });
    //downloadReels(data.text);
  }

  getClipboardText() async {
    ClipboardData data = await Clipboard.getData(Clipboard.kTextPlain);
    setState(() {
      fieldText.text = data.text;
    });
  }

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

  privatePostPopUp() {
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
                    "ImageAssets/private.png",
                    width: 200,
                    height: 200,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                          child: Text(
                        "Private Account!",
                        style: TextStyle(
                          color: blue.withOpacity(0.9),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          "For some security reasons Instagram will not allow us to download posts from private accounts",
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
      //loading: Text('loading'),
      //error: Text('error'),
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
