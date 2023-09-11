import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';

class Ads {
  static AdmobBanner? _bannerAd;

  static void initialize() {
    Admob.initialize();

    _bannerAd = AdmobBanner(
      adUnitId: 'ca-app-pub-5904323837747867~2450997073',
      adSize: AdmobBannerSize.BANNER,
    );
  }

  static Widget? getBannerAdWidget() {
    return _bannerAd;
  }
}
