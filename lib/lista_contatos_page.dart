import 'package:flutter/material.dart';

class ListaContatosPage extends StatelessWidget {
  const ListaContatosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tarefas = [
      {
        'sigla': 'AS',
        'titulo': 'Ana Souza',
        'numero': '(14) 99187-0597',
        'situacao': true,
      },
      {
        'sigla': 'BL',
        'titulo': 'Bruno Lima',
        'numero': '(14) 99298-1608',
        'situacao': false,
      },
      {
        'sigla': 'CM',
        'titulo': 'Carla Mendes',
        'numero': '(14) 99309-2719',
        'situacao': true,
      },
      {
        'sigla': 'DA',
        'titulo': 'Diego Alves',
        'numero': '(14) 99410-3820',
        'situacao': false,
      },
      {
        'sigla': 'ET',
        'titulo': 'Elisa Torres',
        'numero': '(14) 99221-4931',
        'situacao': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Meus Contatos"), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          final tarefa = tarefas[index];
          final bool situacao = tarefa['situacao'];

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.lightBlueAccent,
                child: Text(tarefa['sigla']),
              ),
              title: Text(tarefa['titulo']),
              subtitle: Text(tarefa['numero']),
              trailing: Icon(
                Icons.star,
                color: situacao ? Colors.orange : Colors.grey,
                size: 48,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
