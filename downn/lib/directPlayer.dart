import 'dart:core';
import 'package:downn/ads.dart';
import 'package:downn/overlayWidget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Direct extends StatefulWidget {
  final String url;

  Direct(this.url);
  @override
  _DirectPlayer createState() => _DirectPlayer();
}

class _DirectPlayer extends State<Direct> {
  var some;

  VideoPlayerController _controller;

  // Uri ff;
  AdsClass ads = AdsClass();
  @override
  void initState() {
    some = Uri.parse(widget.url);
    super.initState();
    ads.initializeInter();

    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        _controller.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    if (_controller != null) {
      print("printing The Controller>>$_controller");
    }
    ads.loadInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();
    ads.showInterstitial();
    ads.interstitialAdCallbacks();
    print("Back To old Screen");
    if (_controller.value.isPlaying) {
      _controller.pause();
      _controller.dispose();
    }
  }

  var cntrl;
  @override
  Widget build(BuildContext context) {
    // cntrl = widget.url;
    return _controller != null && _controller.value.isInitialized
        ? Container(alignment: Alignment.topCenter, child: buildVideo())
        : Center(child: issuePopUp(context));
  }

  Widget issuePopUp(BuildContext context) {
    return Container(
        child: AlertDialog(
      content: Container(
        height: 150,
        child: Center(
          child: Column(
            children: [
              Text(
                "We are having trouble loading the video, You can find your Video in SaveIn folder   \u0022/storage/emulated/0/InstaSave\u0022",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                      ),
                    ),
                    child: Text("okay")),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Widget buildVideo() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        buildVideoPlayer(),
        BasicOverlayWidget(controller: _controller),
      ],
    );
  }

  Widget buildVideoPlayer() => buildFullScreen(child: VideoPlayer(_controller));

  Widget buildFullScreen({
    @required Widget child,
  }) {
    final size = _controller.value.size;
    final width = size.width;
    final height = size.height;
    return FittedBox(
      fit: BoxFit.contain,
      alignment: Alignment.center,
      child: SizedBox(
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}
