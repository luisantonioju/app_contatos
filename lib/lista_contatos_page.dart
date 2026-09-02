import 'package:flutter/material.dart';

class ListaContatosPage extends StatelessWidget {
  const ListaContatosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tarefas = [
      {'titulo': 'Ana Souza', 'numero': '(14) 99187-0597', 'situacao': true},
      {'titulo': 'Bruno Lima', 'numero': '(14) 99298-1608', 'situacao': false},
      {'titulo': 'Carla Mendes', 'numero': '(14) 99309-2719', 'situacao': true},
      {'titulo': 'Diego Alves', 'numero': '(14) 99410-3820', 'situacao': false},
      {'titulo': 'Diego Alves', 'numero': '(14) 99221-4931', 'situacao': false},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("Meus Contatos"), centerTitle: true),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          final tarefa = tarefas[index];
          final bool situacao = tarefa['situacao'];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: situacao ? Colors.green : Colors.purple,
                child: Icon(
                  situacao ? Icons.add_circle : Icons.circle,
                  color: Colors.white,
                ),
              ),
              title: Text(
                tarefa['titulo'],
                style: TextStyle(decoration: TextDecoration.none),
              ),
              subtitle: Text(tarefa['numero']),

              trailing: Icon(
                Icons.star,
                color: situacao ? Colors.orange : Colors.grey,
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
