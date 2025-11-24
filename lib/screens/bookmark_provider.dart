import 'package:flutter/foundation.dart';

class BookmarkProvider extends ChangeNotifier {
  final List<Map<String, String>> _savedHostels = [];

  List<Map<String, String>> get savedHostels => _savedHostels;

  bool isSaved(Map<String, String> hostel) {
    return _savedHostels.contains(hostel);
  }

  void toggleBookmark(Map<String, String> hostel) {
    if (_savedHostels.contains(hostel)) {
      _savedHostels.remove(hostel);
    } else {
      _savedHostels.add(hostel);
    }
    notifyListeners();
  }

  void removeBookmark(Map<String, String> hostel) {
    _savedHostels.remove(hostel);
    notifyListeners();
  }
}
