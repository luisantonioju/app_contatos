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
          'numero TEXT, '
          'sigla TEXT, '
          'situacao INTEGER'
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
    return await db.query('contatos');
  }

  // CREATE: Inserir um novo contato no banco salvando titulo, numero e sigla
  static Future<void> inserirContato(String titulo, String numero) async {
    final db = await DatabaseHelper.database;

    String sigla = '?';
    if (titulo.isNotEmpty) {
      sigla = titulo[0].toUpperCase();
    }

    await db.insert('contatos', {
      'titulo': titulo,
      'numero': numero,
      'sigla': sigla,
      'situacao': 0,
    });
  }

  // UPDATE: Acionar contato
  static Future<void> atualizarSituacao(int id, int novaSituacao) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'contatos',
      {'situacao': novaSituacao},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // UPDATE: Edição de número e nome
  static Future<void> editarContato(
    int id,
    String titulo,
    String numero,
  ) async {
    final db = await DatabaseHelper.database;

    String sigla = '?';
    if (titulo.isNotEmpty) {
      sigla = titulo[0].toUpperCase();
    }

    await db.update(
      'contatos',
      {'titulo': titulo, 'numero': numero, 'sigla': sigla},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE: Apagar contato do banco
  static Future<void> excluirContato(int id) async {
    final db = await DatabaseHelper.database;
    await db.delete('contatos', where: 'id = ?', whereArgs: [id]);
  }
}
