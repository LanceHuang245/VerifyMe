import 'dart:async';
import 'dart:convert';
import 'package:base32/base32.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:otp/otp.dart';

class GenerateController extends GetxController {
  var totpList = <Map<String, dynamic>>[].obs;
  Timer? timer;
  final _secureStorage = const FlutterSecureStorage();
  var progress = 0.0.obs;
  var remainingSeconds = 30.obs;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    await loadList();
    if (totpList.isNotEmpty) {
      startTimer();
    }
    updateProgress();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  Future<bool> add(String accountName, String secret, String algorithm,
      String length, String mode,
      {String? oldSecret}) async {
    int index = -1;
    if (oldSecret != null) {
      index = totpList.indexWhere((element) => element['secret'] == oldSecret);
    } else {
      index = totpList.indexWhere(
          (element) => element['secret'] == secret && element['mode'] == mode);
    }
    if (_isValidBase32(secret)) {
      if (index != -1) {
        totpList[index] = {
          'accountName': accountName,
          'secret': secret,
          'algorithm': algorithm,
          'length': length,
          'mode': mode,
          'counter': totpList[index]['counter'] ?? 0
        };
      } else {
        totpList.add({
          'accountName': accountName,
          'secret': secret,
          'algorithm': algorithm,
          'length': length,
          'mode': mode,
          'counter': 0
        });
        if (totpList.length == 1) {
          startTimer();
        }
      }
      await saveList();
      refreshList();
      return true;
    } else {
      return false;
    }
  }

  Future<void> delete(int index) async {
    totpList.removeAt(index);
    await saveList();
    if (totpList.isEmpty) {
      stopTimer();
    }
  }

  void refreshList() {
    totpList.refresh();
  }

  String generate(String secret, String algorithm, String length, String mode,
      {int? counter}) {
    Algorithm algo;
    switch (algorithm) {
      case 'SHA-256':
        algo = Algorithm.SHA256;
        break;
      case 'SHA-512':
        algo = Algorithm.SHA512;
        break;
      case 'SHA-1':
      default:
        algo = Algorithm.SHA1;
    }
    if (mode == "TOTP") {
      return OTP.generateTOTPCodeString(
          secret, DateTime.now().millisecondsSinceEpoch,
          interval: 30,
          length: int.parse(length),
          algorithm: algo,
          isGoogle: true);
    }
    return OTP.generateHOTPCodeString(secret, counter ?? 0,
        algorithm: algo, isGoogle: true, length: int.parse(length));
  }

  Future<void> saveList() async {
    final jsonString = jsonEncode(totpList.toList());
    await _secureStorage.write(key: 'totpList', value: jsonString);
  }

  Future<void> loadList() async {
    final jsonString = await _secureStorage.read(key: 'totpList');
    if (jsonString != null) {
      final List<dynamic> storedList = jsonDecode(jsonString);
      totpList.assignAll(
          storedList.map((e) => Map<String, dynamic>.from(e)).toList());
    }
  }

  bool _isValidBase32(String input) {
    try {
      base32.decode(input);
      return true;
    } catch (e) {
      return false;
    }
  }

  void updateProgress() {
    final seconds = DateTime.now().second;
    progress.value = 1 - (seconds % 30) / 30;
    remainingSeconds.value = 30 - (seconds % 30);
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      updateProgress();
      refreshList();
    });
  }

  void stopTimer() {
    timer?.cancel();
  }
}
