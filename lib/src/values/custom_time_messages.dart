import 'package:timeago/timeago.dart';

// Override "en" locale messages with custom messages that are more precise and short
// setLocaleMessages('en', ReceiptsCustomMessages())

// my_custom_messages.dart
class ReceiptsCustomMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => 'd\'ici ';
  @override
  String suffixAgo() => 'depuis';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'maintenant';
  @override
  String aboutAMinute(int minutes) => 'environ une minute';
  @override
  String minutes(int minutes) => '$minutes minute${minutes > 1 ? 's' : ''}';
  @override
  String aboutAnHour(int minutes) => 'environ une heure';
  @override
  String hours(int hours) => '$hours heure${hours > 1 ? 's' : ''}';
  @override
  String aDay(int hours) => 'environ un jour';
  @override
  String days(int days) => '$days jour${days > 1 ? 's' : ''}';
  @override
  String aboutAMonth(int days) => 'environ un mois';
  @override
  String months(int months) => '$months mois';
  @override
  String aboutAYear(int year) => 'environ un an';
  @override
  String years(int years) => '$years an${years > 1 ? 's' : ''}';
  @override
  String wordSeparator() => ' ';
}
