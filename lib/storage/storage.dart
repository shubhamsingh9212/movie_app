import 'package:get_storage/get_storage.dart';

class Storage {
  static final box = GetStorage();

  static void clear() {
    box.erase();
  }

  static void setToken(String? token) {
    box.write(StorageKey.token, token);
  }

  static String? getToken() {
    return box.read(StorageKey.token);
  }
}

class StorageKey {
  static const String token = "token";
}
