abstract class AdIds {
  String get bannerTopHome;
  String get bannerBottomHome;
  String get interstitialHome;
  String get interstitialReward;
  String get reward;
}

class AdIdsProd implements AdIds {
  @override
  String get bannerTopHome => 'ca-app-pub-5858677157354036/4492022468';
  @override
  String get bannerBottomHome => 'ca-app-pub-5858677157354036/5056534219';
  @override
  String get interstitialHome => 'ca-app-pub-5858677157354036/1482715740';
  @override
  String get interstitialReward => 'ca-app-pub-5858677157354036/1020268043';
  @override
  String get reward => 'ca-app-pub-5858677157354036/4652175698';
}
