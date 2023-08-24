import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: non_constant_identifier_names
String FormatData(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String year = dateTime.year.toString();
  String month = dateTime.month.toString();
  String day = dateTime.day.toString();
  String formatteData = '$day/$month/$year';
  return formatteData;
}
