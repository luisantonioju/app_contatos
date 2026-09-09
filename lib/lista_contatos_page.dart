import 'package:flutter/material.dart';
import 'database_helper.dart'; // Importe o caminho correto do seu arquivo helper

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
    final novoContatoController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Novo Contato'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: novoContatoController,
                decoration: InputDecoration(hintText: 'Digite o nome...'),
              ),
              TextField(
                controller: novoContatoController,
                keyboardType:
                    TextInputType.phone, // Abre o teclado numérico no celular
                decoration: const InputDecoration(
                  hintText: 'Digite o número...',
                ),
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
                if (novoContatoController.text.isNotEmpty) {
                  await DatabaseHelper.inserirContato(
                    novoContatoController.text,
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
      appBar: AppBar(title: const Text("Lista de Contatos"), centerTitle: true),
      body: contatos.isEmpty
          ? Center(
              child: Text('Nenhum contato ainda. Toque em + para adicionar.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: contatos.length,
              itemBuilder: (context, index) {
                final contato = contatos[index];
                final bool situacao =
                    contato['situacao'] ==
                    1; // Ajustado caso seu banco use 0 e 1 para booleano

                // Pega o nome digitado pelo usuário (Ex: "Ana Souza")
                final String nomeCompleto = contato['titulo'] ?? 'Sem Nome';

                // Divide o nome por espaços e pega as primeiras letras
                final List<String> partesNome = nomeCompleto.trim().split(' ');
                final String sigla = partesNome.length > 1
                    ? '${partesNome[0][0]}${partesNome[1][0]}'
                          .toUpperCase() // Pega a primeira letra do 1º e 2º nome
                    : partesNome[0].isNotEmpty
                    ? partesNome[0][0].toUpperCase()
                    : '?'; // Se for só um nome, pega só a primeira letra

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.lightBlueAccent,
                      child: Text(
                        sigla,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      nomeCompleto,
                      style: TextStyle(
                        decoration: situacao
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(contato['numero'] ?? 'Sem número'),
                    trailing: Icon(
                      Icons.star,
                      color: situacao ? Colors.orange : Colors.grey,
                      size: 24,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: adicionarContato,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
