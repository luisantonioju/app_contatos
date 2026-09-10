import 'package:flutter/material.dart';
import 'database_helper.dart';

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
      body: contatos.isEmpty
          ? Center(
              child: Text('Nenhum contato ainda. Toque em + para adicionar.'),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: contatos.length,
              itemBuilder: (context, index) {
                final contato = contatos[index];

                // Pega os dados do mapa simples
                String nome = contato['titulo'] ?? 'Sem Nome';
                String numero = contato['numero'] ?? 'Sem Número';

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        nome.isNotEmpty
                            ? (nome.split(' ').length > 1
                                  ? nome[0].toUpperCase() +
                                        nome.split(' ')[1][0].toUpperCase()
                                  : nome[0].toUpperCase())
                            : '?',

                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(nome),
                    subtitle: Text(numero),
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
