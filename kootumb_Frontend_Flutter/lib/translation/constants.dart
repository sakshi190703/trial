import 'dart:core';
import 'dart:ui';

const supportedLocales = [
  Locale('en', 'US'),
  Locale('es-ES', 'ES'),
  Locale('nl', 'NL'),
// const Locale('ar', 'SA'),
// const Locale('zh', 'CN'),
// const Locale('zh-TW', 'TW'),
// const Locale('cs', 'CZ'),
  Locale('da', 'DK'),
// const Locale('fi', 'FI'),
  Locale('fr', 'FR'),
  Locale('de', 'DE'),
  Locale('hu', 'HU'),
// const Locale('he', 'IL'),
// const Locale('hi', 'IN'),
// const Locale('id', 'ID'),
  Locale('it', 'IT'),
// const Locale('ja', 'JP'),
// const Locale('ko', 'KR'),
// const Locale('ms', 'MY'),
// const Locale('no', 'NO'),
// const Locale('fa', 'IR'),
// const Locale('pl', 'PL'),
  Locale('pt-BR', 'BR'),
// const Locale('ru', 'RU'),
  Locale('sv-SE', 'SE'),
  Locale('tr', 'TR'),
];

var supportedLanguages =
    supportedLocales.map((Locale locale) => locale.languageCode).toList();
