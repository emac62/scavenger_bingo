import 'package:flutter/material.dart';

import '../data/winning_patterns.dart';

class Controller extends ChangeNotifier {
  List<int> _selectedTiles = [];
  List _result = [];
  bool _gameWon = false;
  String _winningPattern = "One Line";
  bool _disableTiles = false;
  List _winPattern = [];

  List get selectedTiles => _selectedTiles;
  String get winningPattern => _winningPattern;
  bool get gameWon => _gameWon;
  bool get disableTiles => _disableTiles;
  List get winPattern => _winPattern;

  void addToSelectedTiles(int) {
    _selectedTiles.add(int);
    notifyListeners();
  }

  void setDisableTiles(bool disableTiles) {
    _disableTiles = disableTiles;
    notifyListeners();
  }

  void setWinningPattern(String pattern) {
    _winningPattern = pattern;
    notifyListeners();
  }

  void removeFromSelectedTiles(int) {
    _selectedTiles.removeWhere((element) => element == int);
    notifyListeners();
  }

  void resetWinPattern() {
    _winPattern = [];
  }

  void clearResult() {
    _result = [];
    notifyListeners();
  }

  void clearSelectedTiles() {
    _selectedTiles = [];
    notifyListeners();
  }

  void resetGameWon() {
    _gameWon = false;
    notifyListeners();
  }

  findOneLineWinner() {
    for (var i = 0; i < Patterns.oneLine.length; i++) {
      _result = Patterns.oneLine[i]
          .where((element) => !_selectedTiles.contains(element))
          .toList();
      if (_result.isEmpty) {
        _winPattern = Patterns.oneLine[i];
        _disableTiles = true;
        _gameWon = true;
        _result.clear();

        break;
      }
    }
  }

  findCrossWinner() {
    _result = Patterns.cross
        .where((element) => !_selectedTiles.contains(element))
        .toList();
    if (_result.isEmpty) {
      _disableTiles = true;
      _gameWon = true;
      _result.clear();
      _winPattern = Patterns.cross;
    }
  }

  findFullCardWinner() {
    _result = Patterns.full
        .where((element) => !_selectedTiles.contains(element))
        .toList();
    if (_result.isEmpty) {
      _disableTiles = true;
      _gameWon = true;
      _result.clear();
      _winPattern = Patterns.full;
    }
  }

  checkForWinner() {
    if (_winningPattern == "One Line" && _selectedTiles.length > 4) {
      findOneLineWinner();
    }
    if (_winningPattern == "Letter X" && _selectedTiles.length > 8) {
      findCrossWinner();
    }
    if (_winningPattern == "Full Card" && _selectedTiles.length == 25) {
      findFullCardWinner();
    }
  }
}
