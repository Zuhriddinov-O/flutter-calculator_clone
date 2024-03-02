import 'package:shared_preferences/shared_preferences.dart';

class ManagerImpl extends CacheManager {
  @override
  Future<String> getNumber() async {
    final shared = await SharedPreferences.getInstance();
    return shared.getString("number") ?? "";
  }

  @override
  Future<void> saveNumber(String number) async {
    final shared = await SharedPreferences.getInstance();
    shared.setString("number", number);
  }
}

abstract class CacheManager {
  Future<void> saveNumber(String number);

  Future<String> getNumber();
}
