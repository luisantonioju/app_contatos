import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:app_contatos/sobre_app_page.dart';

class ListaContatosPage extends StatefulWidget {
  const ListaContatosPage({super.key});

  @override
  State<ListaContatosPage> createState() => _ListaContatosPageState();
}

class _ListaContatosPageState extends State<ListaContatosPage> {
  List<Map<String, dynamic>> contatos = [];

  @override
  void initState() {
    super.initState();
    carregarContatos();
  }

  void carregarContatos() async {
    final dados = await DatabaseHelper.buscarContatos();
    setState(() {
      contatos = dados;
    });
  }

  void alternarEstrela(int id, int situacaoAtual) async {
    int novaSituacao = situacaoAtual == 1 ? 0 : 1;
    await DatabaseHelper.atualizarSituacao(id, novaSituacao);
    carregarContatos();
  }

  void adicionarContato() {
    final nomeController = TextEditingController();
    final numeroController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Novo Contato'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(hintText: 'Digite o nome...'),
              ),
              TextField(
                controller: numeroController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(hintText: 'Digite o número...'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (nomeController.text.isNotEmpty) {
                  await DatabaseHelper.inserirContato(
                    nomeController.text,
                    numeroController.text,
                  );
                  carregarContatos();

                  if (!context.mounted) return;

                  Navigator.pop(context);
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void editarContato(Map<String, dynamic> contato) {
    final nomeController = TextEditingController(text: contato['titulo']);
    final numeroController = TextEditingController(text: contato['numero']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Contato'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(hintText: 'Digite o nome...'),
              ),
              TextField(
                controller: numeroController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(hintText: 'Digite o número...'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (nomeController.text.isNotEmpty) {
                  await DatabaseHelper.editarContato(
                    contato['id'],
                    nomeController.text,
                    numeroController.text,
                  );
                  carregarContatos();

                  if (!context.mounted) return;

                  Navigator.pop(context);
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Contatos"), centerTitle: true),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text(
                "Meus Contatos",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text("Todas os Contatos"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text("Contatos Favoritos"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.star_border),
              title: Text("Contatos Não Favoritos"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("Sobre o App"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SobreAppPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: contatos.isEmpty
          ? Center(
              child: Text('Nenhum contato ainda. Toque em + para adicionar.'),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: contatos.length,
              itemBuilder: (context, index) {
                final contato = contatos[index];
                bool estaFavorito = contato['situacao'] == 1;

                return Dismissible(
                  key: Key(contato['id'].toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) async {
                    await DatabaseHelper.excluirContato(contato['id']);
                    carregarContatos();
                  },
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        editarContato(contato);
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          contato['sigla'] ?? '?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(contato['titulo'] ?? ''),
                      subtitle: Text(contato['numero'] ?? ''),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.star,
                          color: estaFavorito ? Colors.orange : Colors.grey,
                        ),
                        onPressed: () {
                          alternarEstrela(
                            contato['id'],
                            contato['situacao'] ?? 0,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: adicionarContato,
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}