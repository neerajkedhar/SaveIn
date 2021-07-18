import 'package:downn/directPlayer.dart';
import 'package:downn/imageView.dart';
import 'package:downn/player.dart';
import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_extend/share_extend.dart';
import 'dart:io';

final Directory _photoDir = Directory('/storage/emulated/0/SaveIn');

class DownloadedPage extends StatefulWidget {
  DownloadedPage({Key key}) : super(key: key);

  @override
  _DownloadedPageState createState() => _DownloadedPageState();
}

class _DownloadedPageState extends State<DownloadedPage> {
  final controller = NativeAdController();
  static const adUnitID = "ca-app-pub-3940256099942544/2247696110";
  final Directory directory = _photoDir;
  String listingg;
  bool permiss;
  @override
  void initState() {
    super.initState();
    check();
    print("directory.path: ${directory.path}");
  }

  check() async {
    print("checkingggggg");
    if (await Permission.storage.isGranted) {
      print("is Grantedddddd");
      setState(() {
        permiss = true;
      });
      print("is Grantedddddd: $permiss");
    } else {
      // print("is Grantedddddd");
      setState(() {
        permiss = false;
      });
      print("isNotGrantedddddd: $permiss");
    }
  }

  load() {
    controller.load(
      options: NativeAdOptions(),
      unitId: adUnitID,
    );
  }

  Color backGroundwhite = Color(0xf3f5f8ff);
  @override
  Widget build(BuildContext context) {
    if (permiss) {
      var imageList = directory
          .listSync()
          .map((item) => item.path)
          .where((item) =>
              item.endsWith(".jpg") ||
              item.endsWith(".mp4") ||
              item.endsWith(".png"))
          .toList(growable: false);
      print("imageList:$imageList");
      print("frommmmm if: $permiss");
      return imageList.length != null || imageList.length != 0
          ? createListView(imageList)
          : Container(
              child: Center(
                  child: Column(children: [
              nativeAd(),
              Text("You have not downloaded any posts"),
            ])));
    } else {
      print("frommmmm if: $permiss");
      return Container(
        child: Center(
          child: Column(
            children: [
              Text("You have not given Local Storage permission Yet!"),
              ElevatedButton(
                child: Text("Give Permission"),
                onPressed: () {
                  Permission.storage.request();
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget createListView(imageList) {
    return ListView.builder(
      padding: EdgeInsets.all(12.0),
      itemCount: imageList.length,
      itemBuilder: (context, index) {
        File file = new File(imageList[index]);
        String name = file.path.split('/').last;
        List<String> words = name.split(" ");
        var title = words[0];
        var desc = name
            .replaceAll(words[0], "")
            .replaceAll(".mp4", "")
            .replaceAll(".jpg", "")
            .replaceAll(".jpeg", "");
        var retriveShortCode = desc.trim().split(" ");
        var shortCode = retriveShortCode[0];
        var description = desc.replaceAll(shortCode, "").trim();

        return SizedBox(
          child: imageList[index].endsWith(".jpg") ||
                  imageList[index].endsWith(".png")
              ? photoFile(
                  imageList[index], title, description, index, shortCode)
              : videoFile(
                  imageList[index], title, description, index, shortCode),
        );
      },
    );
  }

  Widget videoFile(var imageList, String title, String description, int index,
      var shortCode) {
    return Container(
      //  color: Colors.pink,
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 130,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return Direct(imageList);
          }));
        },
        child: Stack(children: [
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 40, child: VideoItem(imageList)),
                Expanded(
                  flex: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 35.0, top: 15, bottom: 5, left: 15),
                          child: Container(
                            // color: Colors.pink,
                            child: Text('$title',
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
                              right: 35.0, top: 0, bottom: 15, left: 15),
                          child: Container(
                            // color: Colors.pink,
                            child: Text('$description', maxLines: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              right: 0.0,
              top: 0.0,
              child: Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: IconButton(
                    icon: new Icon(Icons.more_vert),
                    onPressed: () {
                      openMenu(imageList, shortCode);
                    },
                  ))),
        ]),
      ),
    );
  }

  Widget photoFile(var imageList, String title, String description, int index,
      String shortcode) {
    return Container(
      // color: Colors.blue,
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 130,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ImageView(imageList);
          }));
        },
        child: Stack(children: [
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 0,
            // margin: EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 40,
                  child: Image.file(
                    File(imageList),
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  flex: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 35.0, top: 15, bottom: 5, left: 15),
                          child: Container(
                            // color: Colors.pink,
                            child: Text('$title',
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
                              right: 35.0, top: 0, bottom: 15, left: 15),
                          child: Container(
                            // color: Colors.pink,
                            child: Text('$description', maxLines: 2),
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
              right: 0.0,
              top: 0.0,
              child: Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: IconButton(
                    icon: new Icon(Icons.more_vert),
                    onPressed: () {
                      openMenu(imageList, shortcode);
                    },
                  ))),
        ]),
      ),
    );
  }

  Future openMenu(imageList, var shortcode) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(25),
                    topRight: const Radius.circular(25),
                  )),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text("Delete"),
                    onTap: () {
                      File(imageList).delete();
                      final snackBar = SnackBar(
                        content: Text('File Deleted!'),
                        duration: Duration(milliseconds: 1000),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pop(context);
                      setState(() {
                        // removeAt(index);
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.send),
                    title: Text("Share"),
                    onTap: () {
                      ShareExtend.share(imageList, "image");
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.public),
                    title: Text("Open on Instagram"),
                    onTap: () {
                      var url = "https://instagram.com/p/$shortcode/";
                      launchUrl(url);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void launchUrl(url) async {
    final snackBar = SnackBar(content: Text('Video Deleted!'));

    await canLaunch(url)
        ? await launch(url)
        : ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget nativeAd() {
    return NativeAd(
      height: 100,
      builder: (context, child) {
        return Material(
          elevation: 0,
          child: child,
        );
      },
      buildLayout: secondBuilder,
      loading: Text('loading'),
      error: Text('error'),
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
          // The first linear layout width needs to be extended to the
          // parents height, otherwise the children won't fit good
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
}
