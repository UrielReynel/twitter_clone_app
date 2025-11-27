/*
  UBICACIÓN: lib/helper/helper_methods.dart
*/

import 'package:cloud_firestore/cloud_firestore.dart';

// Función para formatear la fecha
String formatDate(Timestamp timestamp) {
  // Convertir Timestamp a DateTime
  DateTime dateTime = timestamp.toDate();

  // Obtener año, mes y día
  String year = dateTime.year.toString();
  String month = dateTime.month.toString();
  String day = dateTime.day.toString();

  // Formato final: d/m/a
  String formattedData = '$day/$month/$year';

  return formattedData;
}