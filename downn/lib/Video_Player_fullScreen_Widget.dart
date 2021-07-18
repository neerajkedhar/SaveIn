import 'package:downn/overlayWidget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerFullScreenWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final String file;
  const VideoPlayerFullScreenWidget({
    Key key,
    @required this.controller,
    @required this.file,
  }) : super(key: key);

  @override
  _VideoFullMode createState() => _VideoFullMode();
}

class _VideoFullMode extends State<VideoPlayerFullScreenWidget> {
  var cntrl;
  @override
  Widget build(BuildContext context) {
    cntrl = widget.controller;
    return widget.controller != null && widget.controller.value.isInitialized
        ? Container(alignment: Alignment.topCenter, child: buildVideo())
        : Center(child: CircularProgressIndicator());
  }

  var inbuiltController;
  @override
  void initState() {
    if (!widget.controller.value.isInitialized) {
      inbuiltController = VideoPlayerController.network(widget.file)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          inbuiltController.play();
          setState(() {});
        });
    } else if (widget.controller.value.isInitialized) {
      widget.controller.play();
    }
    super.initState();
    print(cntrl);
  }

  @override
  void dispose() {
    super.dispose();

    if (widget.controller.value.isPlaying ||
        inbuiltController.value.isPlaying) {
      widget.controller.pause();
      widget.controller.dispose();
      inbuiltController.pause();
      inbuiltController.dispose();
    }

    print("Back To old Screen");
  }

  Widget buildVideo() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        buildVideoPlayer(),
        BasicOverlayWidget(controller: widget.controller),
      ],
    );
  }

  Widget buildVideoPlayer() =>
      buildFullScreen(child: VideoPlayer(widget.controller));

  Widget buildFullScreen({
    @required Widget child,
  }) {
    final size = widget.controller.value.size;
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
