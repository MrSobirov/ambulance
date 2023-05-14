import 'package:sqflite/sqflite.dart';

class CachedModels {
  static Database? database;
  static List<Map<String, dynamic>> patients = [];
  static List<Map<String, dynamic>> doctors = [];
  static List<Map<String, dynamic>> nurses = [];
  static List<Map<String, dynamic>> hospitals = [];
  static List<Map<String, dynamic>> sicknesses = [];
  static List<Map<String, dynamic>> callForms = [];
  static List<Map<String, dynamic>> medialHistories = [];
  static List<Map<String, dynamic>> regions = [];
  static List<Map<String, dynamic>> roads = [];
  static List<Map<String, dynamic>> receipts = [];
}