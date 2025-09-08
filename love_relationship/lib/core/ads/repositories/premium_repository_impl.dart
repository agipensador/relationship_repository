import 'package:shared_preferences/shared_preferences.dart';
import 'package:love_relationship/core/ads/repositories/premium_repository.dart';

class PremiumRepositoryImpl implements PremiumRepository {
  static const _key = 'user_premium';

  @override
  Future<bool> isPremium() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getBool(_key) ?? false;
  }

  @override
  Future<void> setPremium(bool value) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setBool(_key, value);
  }
}
