import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: [
        'YOUR_TEST_DEVICE_ID'
      ], // Replace with your test device ID
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdMob & Subscription Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  AppOpenAd? _appOpenAd;
  NativeAd? _nativeAd;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _loadInterstitialAd();
    _loadRewardedAd();
    _loadAppOpenAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _bannerAd?.dispose();
    _nativeAd?.dispose();
    super.dispose();
  }

  //This function is for showing Banner Ad
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId:
          'ca-app-pub-3940256099942544/6300978111', // Use test ad unit ID for banner
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('Banner ad loaded.');
          setState(() {}); // Update UI after banner ad loaded
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint('Banner ad failed to load: $error');
        },
      ),
    );
    _bannerAd!.load();
  }

  //This function is for showing InterstitialAd
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-3940256099942544/1033173712', // Use test ad unit ID for interstitial
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('Interstitial ad loaded.');
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  void _showInterstitialAd() {
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        debugPrint('Interstitial ad closed.');
        _loadInterstitialAd(); // Load the next interstitial ad after it is closed
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        debugPrint('Failed to show interstitial ad: $error');
        _loadInterstitialAd(); // Load the next interstitial ad after it is closed
      },
    );

    _interstitialAd?.show();
  }

  //This function is for showing AppOpenAd
  void _loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/9257395921',
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (AppOpenAd ad) {
          debugPrint('AppOpen ad loaded.');
          _appOpenAd = ad;
          _showAppOpenAd(); // Call _showAppOpenAd when the ad is loaded
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('AppOpen ad failed to load: $error');
        },
      ),
    );
  }

  void _showAppOpenAd() {
    _appOpenAd?.show();
  }

  //This function is for showing RewardedAd
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId:
          'ca-app-pub-3940256099942544/5224354917', // Use test ad unit ID for rewarded ad
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('Rewarded ad loaded.');
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Rewarded ad failed to load: $error');
        },
      ),
    );
  }

  void _showRewardedAd() {
    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        debugPrint('Rewarded ad closed.');
        // Load the next rewarded ad after it is closed
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        debugPrint('Failed to show rewarded ad: $error');
        // Load the next rewarded ad after it is closed
        _loadRewardedAd();
      },
      onAdShowedFullScreenContent: (RewardedAd ad) {
        debugPrint('Rewarded ad showed full screen content.');
      },
    );

    _rewardedAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdMob & Subscription Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_bannerAd != null)
              SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ElevatedButton(
              onPressed: _showInterstitialAd,
              child: const Text('Show Interstitial Ad'),
            ),
            ElevatedButton(
              onPressed: _showRewardedAd,
              child: const Text('Show Rewarded Ad'),
            ),
          ],
        ),
      ),
    );
  }
}
