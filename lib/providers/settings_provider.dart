import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  late bool _withSound;
  late String _selectedBoard;
  late String _selectedPattern;

  SettingsProvider() {
    _withSound = true;
    _selectedBoard = "City Walk";
    _selectedPattern = "One Line";
    loadPreferences();
  }

  bool get withSound => _withSound;
  String get selectedBoard => _selectedBoard;
  String get selectedPattern => _selectedPattern;

  void setWithSound(bool withSound) {
    _withSound = withSound;
    notifyListeners();
    savePreferences();
  }

  void setBoard(String selectedBoard) {
    _selectedBoard = selectedBoard;
    notifyListeners();
    savePreferences();
  }

  void setPattern(String selectedPattern) {
    _selectedPattern = selectedPattern;
    notifyListeners();
    savePreferences();
  }

  savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('withSound', _withSound);
    prefs.setString('selectedBoard', _selectedBoard);
    prefs.setString('selectedPattern', _selectedPattern);
  }

  loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? withSound = prefs.getBool('withSound');
    String? selectedBoard = prefs.getString('selectedBoard');
    String? selectedPattern = prefs.getString('selectedPattern');

    if (withSound != null) setWithSound(withSound);
    if (selectedPattern != null) setPattern(selectedPattern);
    if (selectedBoard != null) setBoard(selectedBoard);
  }
}
