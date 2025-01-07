import 'package:catatan_keuangan/controller/controller_transaksi.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class ControllerProfile extends GetxController {
  TextEditingController expenseController = TextEditingController();
  var themeMode = ThemeMode.light.obs;
  var currency = 'IDR'.obs;
  var maxExpense = 0.0.obs;
  var profilePhoto = ''.obs;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    loadPreferences();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String title, String body) async {
    print("Notifikasi akan muncul dengan title: $title");
    const androidDetails = AndroidNotificationDetails(
      'expense_channel_id',
      'Notifikasi Pengeluaran',
      importance: Importance.high,
      priority: Priority.high,
    );
    const platformDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
    );
  }

  Future<void> saveMaxExpense(double expense) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('maxExpense', expense);
    maxExpense.value = expense;
    checkExpenses(ControllerTransaksi().totalOutcome);
    Get.defaultDialog(
        title: 'Sukses', middleText: 'Batas Pengeluaran di simpan');
  }

  void checkExpenses(double currentExpense) {
    if (currentExpense > maxExpense.value) {
      _showNotification(
        'Pengeluaran Melebihi Batas',
        'Pengeluaran Anda telah melebihi batas yang telah ditentukan!',
      );
    }
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    themeMode.value = (prefs.getBool('isDarkMode') ?? false)
        ? ThemeMode.dark
        : ThemeMode.light;
    currency.value = prefs.getString('currency') ?? 'IDR';
    maxExpense.value = prefs.getDouble('maxExpense') ?? 5000;
    profilePhoto.value = prefs.getString('profilePhoto') ?? '';
  }

  Future<void> saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
    themeMode.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> saveCurrency(String newCurrency) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currency', newCurrency);
    currency.value = newCurrency;
    update();
  }

  Future<void> pickProfilePhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      await saveProfilePhoto(pickedFile.path);
    }
  }

  Future<void> saveProfilePhoto(String newProfilePhoto) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profilePhoto', newProfilePhoto);
    profilePhoto.value = newProfilePhoto;
  }

  String formatCurrency(double amount, String currency) {
    final currencyFormat = NumberFormat.currency(
      locale: currency == 'IDR' ? 'id_ID' : 'en_US',
      symbol: currency == 'IDR' ? 'Rp ' : '\$ ',
      decimalDigits: 2,
    );
    return currencyFormat.format(amount);
  }
}
