import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BasicOverlayWidget extends StatefulWidget {
  final VideoPlayerController controller;

  const BasicOverlayWidget({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  _BasicOverlayWidgetState createState() => _BasicOverlayWidgetState();
}

class _BasicOverlayWidgetState extends State<BasicOverlayWidget> {
  bool playing = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Stack(children: <Widget>[
          playNpause(),
          Positioned(bottom: 30, left: 15, right: 15, child: buildIndicator())
        ]),
      ),
    );
  }

  Widget buildIndicator() => Container(
      child: VideoProgressIndicator(widget.controller, allowScrubbing: true));

  Widget buildPlay() => widget.controller.value.isPlaying
      ? Container()
      : Container(
          alignment: Alignment.center,
          color: Colors.black26,
          child: Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 80,
          ),
        );

  Widget playNpause() {
    return Center(
      child: GestureDetector(
        onTap: _playPause,
        child: playing
            ? Icon(
                Icons.pause,
                color: Colors.white,
                size: 80,
              )
            : Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 80,
              ),
      ),
    );
  }

  _playPause() {
    if (widget.controller.value.isPlaying) {
      widget.controller.pause();
      setState(() {
        playing = false;
      });
    } else {
      widget.controller.play();
      setState(() {
        playing = true;
      });
    }
  }
}
