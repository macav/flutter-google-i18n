library flutter_google_i18n;

import 'dart:async';

import 'package:flutter/widgets.dart';

import 'google_i18n_loader.dart';

class GoogleI18nLocalizations {
  GoogleI18nLocalizations(spreadsheetUrl) {
    googleI18n = GoogleI18nLoader(spreadsheetUrl);
  }

  Locale locale;
  List<String> supportedLocales;
  GoogleI18nLoader googleI18n;

  static GoogleI18nLocalizations of(BuildContext context) {
    return Localizations.of<GoogleI18nLocalizations>(context, GoogleI18nLocalizations);
  }

  Map<String, Map<String, String>> _localizedValues;

  Future<bool> load() async {
    var result = await googleI18n.load();
    this.supportedLocales = googleI18n.loadedLanguages;
    this._localizedValues = googleI18n.localizedValues;
    return result;
  }

  static refresh(final BuildContext context, final Locale newLocale) {
    final currentInstance = GoogleI18nLocalizations.of(context);
    currentInstance.locale = newLocale;
  }

  String t(String key) {
    try {
      return this._localizedValues[locale.languageCode][key];
    } on NoSuchMethodError {
      return '$key translation missing.';
    }
  }
}

class GoogleI18nLocalizationsDelegate extends LocalizationsDelegate<GoogleI18nLocalizations> {
  static GoogleI18nLocalizations _localizations;
  Locale currentLocale;

  GoogleI18nLocalizationsDelegate(spreadsheetUrl) {
    _localizations = GoogleI18nLocalizations(spreadsheetUrl);
  }

  bool isSupported(Locale locale) {
    var supportedLocales = _localizations.supportedLocales;
    return supportedLocales == null
        ? true
        : supportedLocales.contains(locale) || supportedLocales.contains(locale.languageCode);
  }

  @override
  bool shouldReload(GoogleI18nLocalizationsDelegate old) {
    return false;
  }

  @override
  Future<GoogleI18nLocalizations> load(Locale locale) async {
    _localizations.locale = currentLocale = locale;
    await _localizations.load();

    return _localizations;
  }
}
