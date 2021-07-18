//import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'dart:html';

//import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

class AdsClass {
  static const interstitialAdUnitId = "ca-app-pub-3071933490034842/9586350751";
  InterstitialAd interstitialAd;
  initializeInter() {
    interstitialAd = InterstitialAd();
  }

  loadInterstitialAd() {
    interstitialAd..load(unitId: interstitialAdUnitId);
  }

  showInterstitial() {
    if (interstitialAd.isAvailable) {
      interstitialAd.show();
    } else if (!interstitialAd.isAvailable) {
      interstitialAd.load();
    }
  }

  interstitialAdCallbacks() {
    interstitialAd.onEvent.listen((e) {
      final event = e.keys.first;
      switch (event) {
        case FullScreenAdEvent.loading:
          print('from callbacks loading');
          break;
        case FullScreenAdEvent.loaded:
          print('from callbacks loaded');
          break;
        case FullScreenAdEvent.loadFailed:
          final errorCode = e.values.first;
          print('from callbacks loadFailed $errorCode');
          break;
        case FullScreenAdEvent.showed:
          print('from callbacks ad showed');
          break;
        case FullScreenAdEvent.closed:
          interstitialAd.load();
          print('from callbacks ad closed');
          break;
        case FullScreenAdEvent.showFailed:
          final errorCode = e.values.first;
          print(' from callbacks ad failed to show $errorCode');
          break;
        default:
          break;
      }
    });
  }
}
