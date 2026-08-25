import 'package:flutter/material.dart';

class ListaContatosPage extends StatelessWidget {
  const ListaContatosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meus Contatos"), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 0, 88, 170),
              ),
              title: Text('Ana Souza'),
              subtitle: Text('(14) 998765-4321'),
              trailing: Icon(Icons.star, color: Colors.amber[900]),
            ),
          ),
        ],
      ),
    );
  }
}
