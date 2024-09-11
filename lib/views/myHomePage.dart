import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  int maxValue = 20;
  String counterText = '';
  List<Map<String, dynamic>> products = [];

  void getData(int id) async {
    if (id > maxValue) {
      setState(() {
        counterText = 'Limite alcançado (20)';
      });
      return;
    }

    var url = Uri.https('fakestoreapi.com', 'products/$id');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemTitle = jsonResponse['title'];
      var itemPrice = jsonResponse['price'];
      var itemDescription = jsonResponse['description'];

      setState(() {
        products.add({
          'title': itemTitle,
          'price': itemPrice,
          'description': itemDescription,
        });
        counter++;
        print('Item na posição: $counter');
      });
    } else {
      print('Requisição falhou: ${response.statusCode}.');
      setState(() {
        counterText = 'Erro ao buscar dados: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF333333),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: Container(
        color: const Color(0xFF31a140), // Fundo verde
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Item cadastrado na posição:'),
            Text(
              '$counter',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white),
            ),
            if (counterText.isNotEmpty)
              Text(
                counterText,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    color: const Color(0xFF1a1a1a), // Card em cinza escuro
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['title'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.grey), // Texto em cinza
                          ),
                          const SizedBox(height: 5),
                          Text('Preço: \$${product['price']}',
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 5),
                          Text('Descrição: ${product['description']}',
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (counter < maxValue) {
            getData(counter + 1);
          } else {
            setState(() {
              counterText = 'Limite alcançado (20)';
            });
            print('Limite alcançado (20)');
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
