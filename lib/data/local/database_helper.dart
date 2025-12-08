import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/local_article.dart';
import 'models/chat_message.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      uid TEXT PRIMARY KEY,
      email TEXT,
      displayName TEXT,
      photoUrl TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE articles (
      url TEXT PRIMARY KEY, 
      title TEXT,
      author TEXT,
      description TEXT,
      urlToImage TEXT,
      publishedAt TEXT,
      content TEXT,
      category TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE chats (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      text TEXT,
      imagePath TEXT,
      isSender INTEGER, 
      timestamp TEXT
    )
    ''');
  }

  Future<void> saveUser(Map<String, dynamic> userMap) async {
    final db = await instance.database;
    await db.insert(
      'users',
      userMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser() async {
    final db = await instance.database;
    final result = await db.query('users');
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> clearUser() async {
    final db = await instance.database;
    await db.delete('users');
  }

  Future<void> cacheArticles(List<LocalArticle> articles) async {
    final db = await instance.database;
    final batch = db.batch();

    for (var article in articles) {
      batch.insert(
        'articles',
        article.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<LocalArticle>> getCachedArticles({String? category}) async {
    final db = await instance.database;
    List<Map<String, dynamic>> result;

    if (category != null && category != 'Latest') {
      result = await db.query(
        'articles',
        where: 'category = ?',
        whereArgs: [category],
        orderBy: 'publishedAt DESC',
      );
    } else {
      result = await db.query('articles', orderBy: 'publishedAt DESC');
    }

    return result.map((json) => LocalArticle.fromMap(json)).toList();
  }

  Future<void> insertMessage(ChatMessage message) async {
    final db = await instance.database;
    await db.insert('chats', message.toMap());
  }

  Future<List<ChatMessage>> getChatHistory() async {
    final db = await instance.database;
    final result = await db.query('chats', orderBy: 'timestamp ASC');
    return result.map((json) => ChatMessage.fromMap(json)).toList();
  }
}