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
                  // Salva o nome e o número separados
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
              leading: Icon(Icons.list),
              title: Text("Todas os Contatos"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text("Concluídas"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.circle_outlined),
              title: Text("Pendentes"),
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

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        contato['sigla'] ?? '?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(contato['titulo'] ?? ''),
                    subtitle: Text(contato['numero'] ?? ''),
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
