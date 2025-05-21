import 'package:flutter/material.dart';
import 'package:mon_budget/core/database/database_helper.dart';

class BaseService extends ChangeNotifier {
  bool _isError = false;
  bool _isLoading = false;
  bool _isSuccess = false;
  bool get isError => _isError;
  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  final dbHelper = DatabaseHelper();

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setSuccess(bool value) {
    _isSuccess = value;
    _isLoading = false;
    notifyListeners();
  }

  void setError(String message) {
    _isError = true;
    _isSuccess = false;
    _isLoading = false;
    // AppNotifier.show(message: message, type: ToastificationType.error);
    notifyListeners();
  }
}
