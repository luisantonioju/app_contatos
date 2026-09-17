import 'package:flutter/material.dart';

class SobreAppPage extends StatelessWidget {
  const SobreAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sobre o APP"), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/logoContatos.jpg',
                width: 130,
                height: 130,
              ),
              SizedBox(height: 20),
              Text(
                "A rotina moderna exige mais do que apenas boa memória; exige organização inteligente. Um aplicativo de gestão de tarefas funciona como uma central de controle pessoal e profissional, transformando listas mentais caóticas em fluxos de trabalho estruturados e realizáveis.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                "Versão 1.0.0",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
