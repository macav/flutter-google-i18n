import 'dart:convert';

import 'package:async_resource/file_resource.dart';
import 'package:path_provider/path_provider.dart';

class GoogleI18nLoader {
  List<String> loadedLanguages;
  Map<String, Map<String, String>> localizedValues;
  String spreadsheetUrl;

  GoogleI18nLoader(this.spreadsheetUrl);

  /// Retrieve supported languages. If they haven't been loaded yet, it calls the `load` method.
  Future<List<String>> fetchLoadedLanguages() async {
    if (loadedLanguages == null) {
      await load();
    }
    return loadedLanguages;
  }

  Future<dynamic> _loadSpreadsheetWithCache() async {
    final path = (await getApplicationDocumentsDirectory()).path;
    final cacheFile = File('$path/translations.json');

    final myDataResource = HttpNetworkResource<dynamic>(
      url: spreadsheetUrl,
      parser: (contents) => json.decode(contents),
      cache: FileResource(cacheFile),
      strategy: CacheStrategy.networkFirst,
    );
    return await myDataResource.get();
  }

  /// Load localized values from the spreadsheet. Uses cache, so if the network connection is not available,
  /// the cached version is returned.
  Future<bool> load() async {
    var _result = await _loadSpreadsheetWithCache();
    List<dynamic> entries = _result['feed']['entry'];
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
        localizedValues[language][key] = translation['gsx\$$language']['\$t'];
      });
    });
    return true;
  }
}
