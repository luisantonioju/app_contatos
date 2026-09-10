import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;

  // Abre ou cria o arquivo do banco de dados
  static Future<Database> abrirBanco() async {
    final caminho = join(await getDatabasesPath(), 'contatos.db');

    return openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE contatos ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'titulo TEXT, '
          'numero TEXT, ' // Adicionada a coluna para o número
          'situacao INTEGER' // 0 = false, 1 = true
          ')',
        );
      },
    );
  }

  // Getter que devolve o banco de dados aberto (ou abre se não existir)
  static Future<Database> get database async {
    _db ??= await abrirBanco();
    return _db!;
  }

  // READ: Buscar todos os contatos salvos no banco
  static Future<List<Map<String, dynamic>>> buscarContatos() async {
    final db = await DatabaseHelper.database;
    return db.query('contatos'); // SELECT * FROM contatos
  }

  // CREATE: Inserir um novo contato no banco aceitando título e número
  static Future<void> inserirContato(String titulo, String numero) async {
    final db = await DatabaseHelper.database;
    await db.insert('contatos', {
      'titulo': titulo,
      'numero': numero,
      'situacao': 0,
    });
  }
}
