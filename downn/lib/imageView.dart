import 'dart:io';
import 'package:downn/ads.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';

class ImageView extends StatefulWidget {
  final String imageUrl;

  ImageView(this.imageUrl);
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  AdsClass ads = AdsClass();

  @override
  void initState() {
    super.initState();
    ads.initializeInter();
    ads.loadInterstitialAd();
  }

  @override
  void dispose() {
    ads.showInterstitial();
    ads.interstitialAdCallbacks();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: PhotoView(
          imageProvider: FileImage(
            File(widget.imageUrl),
          ),
        ),
      ),
      // new Image.file(
      //   File(widget.imageUrl),
      //   fit: BoxFit.cover,
      //   height: double.infinity,
      //   width: MediaQuery.of(context).size.width,
      //   alignment: Alignment.center,
      // ),
    );
  }
}
