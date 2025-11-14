import 'package:dartz/dartz.dart';
// import 'package:postgres/postgres.dart'; // Unused for now
import '../errors/failures.dart';
import 'database_service.dart';

class DatabaseMigrationService {
  final DatabaseService _databaseService;

  DatabaseMigrationService(this._databaseService);

  /// Run all migrations and setup database
  Future<Either<Failure, bool>> runMigrations() async {
    try {
      print('🔄 Bắt đầu migration database...');
      
      // Initialize databases first
      final initResult = await _databaseService.initializeDatabases();
      if (initResult.isLeft()) {
        return initResult;
      }

      // Check and create tables
      final tablesResult = await _createAllTables();
      if (tablesResult.isLeft()) {
        return tablesResult;
      }

      // Insert sample data if needed
      await _insertSampleDataIfEmpty();

      print('✅ Migration hoàn thành thành công!');
      return const Right(true);
    } catch (e) {
      print('❌ Migration thất bại: $e');
      return Left(DatabaseFailure('Migration failed: $e'));
    }
  }

  /// Create all tables
  Future<Either<Failure, bool>> _createAllTables() async {
    try {
      print('📋 Đang tạo tables...');
      
      // Tables will be created automatically by DatabaseHelper
      // This method can be used for additional setup or verification
      
      return const Right(true);
    } catch (e) {
      return Left(DatabaseFailure('Failed to create tables: $e'));
    }
  }

  /// Insert sample data if database is empty
  Future<Either<Failure, bool>> _insertSampleDataIfEmpty() async {
    try {
      print('📝 Kiểm tra và thêm dữ liệu mẫu...');
      
      // Check if borrow_cards table has data
      final countResult = await _databaseService.databaseHelper.executeLocalQuery(
        'SELECT COUNT(*) as count FROM borrow_cards'
      );

      return countResult.fold(
        (failure) => Left(failure),
        (rows) async {
          final count = rows.first['count'] as int;
          
          if (count == 0) {
            print('📊 Database trống, thêm dữ liệu mẫu...');
            return await _insertSampleData();
          } else {
            print('📊 Database đã có $count bản ghi');
            return const Right(true);
          }
        },
      );
    } catch (e) {
      return Left(DatabaseFailure('Failed to check/insert sample data: $e'));
    }
  }

  /// Insert sample data
  Future<Either<Failure, bool>> _insertSampleData() async {
    try {
      // Sample borrow cards
      final sampleBorrows = [
        {
          'borrower_name': 'Nguyễn Văn A',
          'borrower_class': 'CNTT01',
          'borrower_student_id': 'SV001',
          'borrower_phone': '0123456789',
          'book_name': 'Lập trình Flutter cơ bản',
          'book_code': 'FLUTTER001',
          'borrow_date': DateTime.now().subtract(const Duration(days: 5)).toIso8601String().split('T')[0],
          'expected_return_date': DateTime.now().add(const Duration(days: 9)).toIso8601String().split('T')[0],
          'status': 'borrowed',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        {
          'borrower_name': 'Trần Thị B',
          'borrower_class': 'CNTT02',
          'borrower_student_id': 'SV002',
          'borrower_phone': '0987654321',
          'book_name': 'Cơ sở dữ liệu nâng cao',
          'book_code': 'DB001',
          'borrow_date': DateTime.now().subtract(const Duration(days: 20)).toIso8601String().split('T')[0],
          'expected_return_date': DateTime.now().subtract(const Duration(days: 6)).toIso8601String().split('T')[0],
          'status': 'borrowed',
          'created_at': DateTime.now().subtract(const Duration(days: 20)).toIso8601String(),
          'updated_at': DateTime.now().subtract(const Duration(days: 20)).toIso8601String(),
        },
        {
          'borrower_name': 'Lê Văn C',
          'borrower_class': 'CNTT01',
          'borrower_student_id': 'SV003',
          'book_name': 'Thuật toán và cấu trúc dữ liệu',
          'book_code': 'ALG001',
          'borrow_date': DateTime.now().subtract(const Duration(days: 30)).toIso8601String().split('T')[0],
          'expected_return_date': DateTime.now().subtract(const Duration(days: 16)).toIso8601String().split('T')[0],
          'actual_return_date': DateTime.now().subtract(const Duration(days: 10)).toIso8601String().split('T')[0],
          'status': 'returned',
          'created_at': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
          'updated_at': DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
        },
        {
          'borrower_name': 'Phạm Văn D',
          'borrower_class': 'D22CI01',
          'borrower_student_id': 'SV004',
          'borrower_phone': '0917654321',
          'book_name': 'Lập trình Web với Django',
          'book_code': 'DJANGO001',
          'borrow_date': DateTime.now().subtract(const Duration(days: 3)).toIso8601String().split('T')[0],
          'expected_return_date': DateTime.now().add(const Duration(days: 11)).toIso8601String().split('T')[0],
          'status': 'borrowed',
          'created_at': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
          'updated_at': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        },
        {
          'borrower_name': 'Hoàng Thị E',
          'borrower_class': 'D22CI01',
          'borrower_student_id': 'SV005',
          'borrower_phone': '0934123456',
          'book_name': 'Python cho khoa học dữ liệu',
          'book_code': 'PYTHON001',
          'borrow_date': DateTime.now().subtract(const Duration(days: 15)).toIso8601String().split('T')[0],
          'expected_return_date': DateTime.now().subtract(const Duration(days: 1)).toIso8601String().split('T')[0],
          'status': 'overdue',
          'created_at': DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
          'updated_at': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        },
      ];

      // Insert sample books
      final sampleBooks = [
        {
          'book_code': 'FLUTTER001',
          'title': 'Lập trình Flutter cơ bản',
          'author': 'Nguyễn Văn Dev',
          'category': 'Lập trình',
          'isbn': '978-0123456789',
          'total_copies': 5,
          'available_copies': 4,
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'book_code': 'DB001',
          'title': 'Cơ sở dữ liệu nâng cao',
          'author': 'Trần Thị Database',
          'category': 'Cơ sở dữ liệu',
          'isbn': '978-0987654321',
          'total_copies': 3,
          'available_copies': 2,
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'book_code': 'ALG001',
          'title': 'Thuật toán và cấu trúc dữ liệu',
          'author': 'Lê Văn Algorithm',
          'category': 'Thuật toán',
          'isbn': '978-0456789123',
          'total_copies': 4,
          'available_copies': 4,
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'book_code': 'DJANGO001',
          'title': 'Lập trình Web với Django',
          'author': 'Phạm Thành Web',
          'category': 'Lập trình Web',
          'isbn': '978-0789456123',
          'total_copies': 3,
          'available_copies': 2,
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'book_code': 'PYTHON001',
          'title': 'Python cho khoa học dữ liệu',
          'author': 'Hoàng Văn Data',
          'category': 'Khoa học dữ liệu',
          'isbn': '978-0123789456',
          'total_copies': 5,
          'available_copies': 4,
          'created_at': DateTime.now().toIso8601String(),
        },
      ];

      // Sample readers
      final sampleReaders = [
        {
          'name': 'Nguyễn Văn A',
          'student_id': 'SV001',
          'class': 'CNTT01',
          'phone': '0123456789',
          'email': 'nguyenvana@email.com',
          'address': 'Hà Nội',
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'name': 'Trần Thị B',
          'student_id': 'SV002',
          'class': 'CNTT02',
          'phone': '0987654321',
          'email': 'tranthib@email.com',
          'address': 'Hồ Chí Minh',
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'name': 'Lê Văn C',
          'student_id': 'SV003',
          'class': 'CNTT01',
          'email': 'levanc@email.com',
          'address': 'Đà Nẵng',
          'created_at': DateTime.now().toIso8601String(),
        },
      ];

      // Insert data
      for (final book in sampleBooks) {
        await _databaseService.databaseHelper.executeLocalInsert('books', book);
      }

      for (final reader in sampleReaders) {
        await _databaseService.databaseHelper.executeLocalInsert('readers', reader);
      }

      for (final borrow in sampleBorrows) {
        await _databaseService.databaseHelper.executeLocalInsert('borrow_cards', borrow);
      }

      print('✅ Đã thêm dữ liệu mẫu: ${sampleBooks.length} sách, ${sampleReaders.length} độc giả, ${sampleBorrows.length} thẻ mượn');
      return const Right(true);
    } catch (e) {
      return Left(DatabaseFailure('Failed to insert sample data: $e'));
    }
  }

  /// Get database info
  Future<Either<Failure, Map<String, dynamic>>> getDatabaseInfo() async {
    try {
      final info = <String, dynamic>{};
      
      // Get table counts from PostgreSQL only
      final tables = ['borrow_cards', 'books', 'readers'];
      for (final table in tables) {
        final result = await _databaseService.databaseHelper.executeRemoteQuery(
          'SELECT COUNT(*) as count FROM $table'
        );
        
        result.fold(
          (failure) {
            print('❌ Failed to get count for $table: ${failure.message}');
            info[table] = 'Error: ${failure.message}';
          },
          (rows) {
            final count = rows.first['count'];
            info[table] = count;
            print('✅ $table count from PostgreSQL: $count');
          },
        );
      }

      // Get database config
      info['config'] = _databaseService.getCurrentConfig();
      
      return Right(info);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get database info: $e'));
    }
  }

  /// Reset database (drop all data)
  Future<Either<Failure, bool>> resetDatabase() async {
    try {
      print('🗑️ Đang reset database...');
      
      final tables = ['borrow_cards', 'books', 'readers'];
      for (final table in tables) {
        await _databaseService.databaseHelper.executeLocalQuery('DELETE FROM $table');
      }
      
      print('✅ Database đã được reset');
      return const Right(true);
    } catch (e) {
      return Left(DatabaseFailure('Failed to reset database: $e'));
    }
  }

  /// Check table structure
  Future<Either<Failure, Map<String, List<Map<String, dynamic>>>>> getTableStructures() async {
    try {
      final structures = <String, List<Map<String, dynamic>>>{};
      
      // Get SQLite table info
      final tables = ['borrow_cards', 'books', 'readers'];
      for (final table in tables) {
        final result = await _databaseService.databaseHelper.executeLocalQuery(
          'PRAGMA table_info($table)'
        );
        
        result.fold(
          (failure) => structures[table] = [],
          (rows) => structures[table] = rows,
        );
      }
      
      return Right(structures);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get table structures: $e'));
    }
  }
}