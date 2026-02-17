import 'package:love_relationship/features/chat/domain/repositories/chat_partner_name_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPartnerNameRepositoryImpl implements ChatPartnerNameRepository {
  static const _key = 'changedChatNamePartner';
  static const _defaultName = 'Valéria';

  @override
  Future<String> getPartnerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? _defaultName;
  }

  @override
  Future<void> savePartnerName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, name);
  }
}
