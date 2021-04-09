import 'package:flutter/material.dart';
import 'package:flutter_google_i18n/flutter_google_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyAppState extends State<MyApp> {
  Locale locale;

  @override
  void initState() {
    super.initState();
    locale = Locale('en');
  }

  onLocaleChange(Locale locale) {
    setState(() {
      this.locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google I18n Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        GoogleI18nLocalizationsDelegate(
            'https://spreadsheets.google.com/feeds/list/1TGbtKpdNRptYwUVtqmkI2L7Ix00i-fQMnrChGHx2Ajk/1/public/values?alt=json'),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: locale,
      home: MyHomePage(onLocaleChange),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyAppState();
  }
}

class MyHomePage extends StatelessWidget {
  final void Function(Locale locale) onLocaleSwitch;

  MyHomePage(this.onLocaleSwitch);

  @override
  Widget build(BuildContext context) {
    GoogleI18nLocalizations i18n = GoogleI18nLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Google I18n'),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Text(i18n.t('title')),
          Padding(padding: EdgeInsets.only(top: 30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownButton(
                items: i18n.supportedLocales.map((locale) {
                  return DropdownMenuItem(
                      child: Text(locale.toUpperCase()), value: locale);
                }).toList(),
                value: i18n.locale.languageCode,
                onChanged: (String value) {
                  Locale newLocale = Locale(value);
                  GoogleI18nLocalizations.setLocale(context, newLocale);
                  this.onLocaleSwitch(newLocale);
                },
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(color: Colors.white),
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                  ),
                  child: Text(
                      "Switch to ${i18n.locale.languageCode == 'en' ? 'DE' : 'EN'}"),
                  onPressed: () {
                    Locale newLocale = i18n.locale.languageCode == 'en'
                        ? const Locale('de')
                        : const Locale('en');
                    GoogleI18nLocalizations.setLocale(context, newLocale);
                    this.onLocaleSwitch(newLocale);
                  })
            ],
          )
        ],
      )),
    );
  }
}
