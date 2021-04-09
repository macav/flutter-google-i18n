import 'dart:convert';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class GoogleI18nLoader {
  late List<String> loadedLanguages;
  late Map<String, Map<String, String>> localizedValues;
  String spreadsheetUrl;

  GoogleI18nLoader(this.spreadsheetUrl);

  /// Retrieve supported languages
  Future<List<String>> fetchLoadedLanguages() async {
    return loadedLanguages;
  }

  Future<File> _loadSpreadsheetWithCache() async {
    return await DefaultCacheManager().getSingleFile(spreadsheetUrl);
  }

  /// Load localized values from the spreadsheet. Uses cache, so if the network connection is not available,
  /// the cached version is returned.
  Future<bool> load() async {
    var _file = await _loadSpreadsheetWithCache();
    var data = jsonDecode(await _file.readAsString());
    List<dynamic> entries = data['feed']['entry'];
    loadedLanguages = entries[0]
        .keys
        .toList()
        .where((element) => element.startsWith('gsx') && element != 'gsx\$key')
        .map((element) => element.replaceFirst('gsx\$', ''))
        .toList()
        .cast<String>();
    localizedValues =
        Map.fromIterable(loadedLanguages, key: (e) => e, value: (_e) => {});

    entries.forEach((translation) {
      final key = translation['gsx\$key']['\$t'];
      loadedLanguages.forEach((language) {
        localizedValues[language]![key] = translation['gsx\$$language']['\$t'];
      });
    });
    return true;
  }
}
