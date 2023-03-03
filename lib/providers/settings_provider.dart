import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  late bool _withSound;
  late String _selectedBoard;
  late String _selectedPattern;
  int _gamesStarted = 0;
  int _gamesWon = 0;
  List<String> _currentGame = [];

  SettingsProvider() {
    _withSound = true;
    _selectedBoard = "City Walk";
    _selectedPattern = "One Line";
    _gamesStarted = 0;
    _gamesWon = 0;
    _currentGame = [];
    loadPreferences();
  }

  bool get withSound => _withSound;
  String get selectedBoard => _selectedBoard;
  String get selectedPattern => _selectedPattern;
  int get gamesStarted => _gamesStarted;
  int get gamesWon => _gamesWon;
  List get currentGame => _currentGame;

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

  void setGamesStarted(int gamesStarted) {
    _gamesStarted = gamesStarted;
    notifyListeners();
    savePreferences();
  }

  void setGamesWon(int gamesWon) {
    _gamesWon = gamesWon;
    notifyListeners();
    savePreferences();
  }

  setCurrentGame(List<String> currentGame) {
    _currentGame = currentGame;
    notifyListeners();
    savePreferences();
  }

  savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('withSound', _withSound);
    prefs.setString('selectedBoard', _selectedBoard);
    prefs.setString('selectedPattern', _selectedPattern);
    prefs.setInt('gamesWon', _gamesWon);
    prefs.setInt('gamesStarted', _gamesStarted);
    prefs.setStringList('currentGame', _currentGame);
  }

  loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? withSound = prefs.getBool('withSound');
    String? selectedBoard = prefs.getString('selectedBoard');
    String? selectedPattern = prefs.getString('selectedPattern');
    int? gamesStarted = prefs.getInt('gamesStarted');
    int? gamesWon = prefs.getInt('gamesWon');
    List<String>? currentGame = prefs.getStringList('currentGame');

    if (withSound != null) setWithSound(withSound);
    if (selectedPattern != null) setPattern(selectedPattern);
    if (selectedBoard != null) setBoard(selectedBoard);
    if (gamesStarted != null) setGamesStarted(gamesStarted);
    if (gamesWon != null) setGamesWon(gamesWon);
    if (currentGame != null) setCurrentGame(currentGame);
  }
}
