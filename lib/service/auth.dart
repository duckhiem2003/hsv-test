import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:web_test/service/local.dart';
enum LoginType { user, admin, none }
class AuthService {
  final database = FirebaseDatabase.instance.ref('Account');
  Future<void> createAccountForTesting(int from, int to) async {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

    for (var i = from; i < to; i++) {
      String password = getRandomString(6);
      String index = i.toString().padLeft(3, '0');
      String username = 'test-$index';
      FirebaseDatabase.instance.ref('Account/$username').set(password);
    }
  }

  Future<LoginType> login(String username, String password) async {
    final userDatabase = await FirebaseDatabase.instance.ref('Account/$username').get();
    if (userDatabase.exists) {
      if (userDatabase.value.toString() == password) {
        return LoginType.user;
      }
    }
    final adminDatabase = await FirebaseDatabase.instance.ref('AdminAccount/$username').get();
    if (adminDatabase.exists) {
      if (adminDatabase.value.toString() == password) {
        return LoginType.admin;
      }
    }
    return LoginType.none;
  }

Future<void> logout() async {
  await LocalStorageUtility.storeData('username', '');
  await LocalStorageUtility.storeData('userType', '');
}
}
