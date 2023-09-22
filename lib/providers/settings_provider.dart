import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  late bool _withSound;
  late String _selectedBoard;
  late String _selectedPattern;
  late int _gamesStarted;
  late int _gamesWon;
  late List<String> _currentGame;
  late bool _removeAds;
  late bool _reviewed;
  late List<String> _purchasedCards;
  late List<String> _createdCards;
  late bool _hiveActivated;

  SettingsProvider() {
    _withSound = true;
    _selectedBoard = "City Walk";
    _selectedPattern = "One Line";
    _gamesStarted = 0;
    _gamesWon = 0;
    _currentGame = [];
    _removeAds = false;
    _reviewed = false;
    _purchasedCards = [];
    _createdCards = [];
    _hiveActivated = false;
    loadPreferences();
  }

  bool get withSound => _withSound;
  String get selectedBoard => _selectedBoard;
  String get selectedPattern => _selectedPattern;
  int get gamesStarted => _gamesStarted;
  int get gamesWon => _gamesWon;
  List get currentGame => _currentGame;
  bool get removeAds => _removeAds;
  bool get reviewed => _reviewed;
  List get purchasedCards => _purchasedCards;
  List get createdCards => _createdCards;
  bool get hiveActivated => _hiveActivated;

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

  void setRemoveAds(bool removeAds) {
    _removeAds = removeAds;
    notifyListeners();
    savePreferences();
  }

  void setReviewed(bool reviewed) {
    _reviewed = reviewed;
    notifyListeners();
    savePreferences();
  }

  setPurchasedCards(List<String> purchasedCards) {
    _purchasedCards = purchasedCards;
    notifyListeners();
    savePreferences();
  }

  setCreatedCards(List<String> createdCards) {
    _createdCards = createdCards;
    notifyListeners();
    savePreferences();
  }

  setHive(bool hiveActivated) {
    _hiveActivated = hiveActivated;
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
    prefs.setBool('removeAds', _removeAds);
    prefs.setBool('reviewed', _reviewed);
    prefs.setStringList('purchasedCards', _purchasedCards);
    prefs.setStringList('createdCards', _createdCards);
    prefs.setBool('hiveActivated', _hiveActivated);
  }

  loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? withSound = prefs.getBool('withSound');
    String? selectedBoard = prefs.getString('selectedBoard');
    String? selectedPattern = prefs.getString('selectedPattern');
    int? gamesStarted = prefs.getInt('gamesStarted');
    int? gamesWon = prefs.getInt('gamesWon');
    List<String>? currentGame = prefs.getStringList('currentGame');
    bool? removeAds = prefs.getBool('removeAds');
    bool? reviewed = prefs.getBool('reviewed');
    List<String>? purchasedCards = prefs.getStringList('purchasedCards');
    List<String>? createdCards = prefs.getStringList('createdCards');
    bool? hiveActivated = prefs.getBool('hiveActivated');

    if (withSound != null) setWithSound(withSound);
    if (selectedPattern != null) setPattern(selectedPattern);
    if (selectedBoard != null) setBoard(selectedBoard);
    if (gamesStarted != null) setGamesStarted(gamesStarted);
    if (gamesWon != null) setGamesWon(gamesWon);
    if (currentGame != null) setCurrentGame(currentGame);
    if (removeAds != null) setRemoveAds(removeAds);
    if (reviewed != null) setReviewed(reviewed);
    if (purchasedCards != null) setPurchasedCards(purchasedCards);
    if (createdCards != null) setCreatedCards(createdCards);
    if (hiveActivated != null) setHive(hiveActivated);
  }
}
