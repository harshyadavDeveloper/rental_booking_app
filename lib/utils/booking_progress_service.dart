import 'package:sqflite/sqflite.dart';
import '../models/booking_progress_model.dart';
import 'db_helper.dart';

class BookingProgressService {
  static const String table = "booking_progress";

  /// Insert a blank progress row if not exists yet
  Future<void> _ensureRowExists() async {
    final db = await DBHelper.instance.database;
    final rows = await db.query(table);

    if (rows.isEmpty) {
      await db.insert(table, {"id": 1}); // Create default initial row
    }
  }

  /// Update a single field column in the booking progress table
  Future<void> updateProgressField(String field, dynamic value) async {
    final db = await DBHelper.instance.database;

    await _ensureRowExists(); // Ensure row is present

    await db.update(
      table,
      {field: value},
      where: "id = ?",
      whereArgs: [1],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Fetch stored progress (returns only 1 record always)
  Future<BookingProgressModel?> getProgress() async {
    final db = await DBHelper.instance.database;
    final rows = await db.query(table, limit: 1);

    if (rows.isNotEmpty) {
      return BookingProgressModel.fromMap(rows.first);
    }
    return null;
  }

  /// Clear the table → used after booking success
  Future<void> clearProgress() async {
    final db = await DBHelper.instance.database;
    await db.delete(table);
  }
}
