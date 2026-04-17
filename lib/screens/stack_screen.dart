import 'package:flutter/material.dart';
import '../data_structures/stack.dart';

class StackScreen extends StatefulWidget {
  const StackScreen({super.key});

  @override
  State<StackScreen> createState() => _StackScreenState();
}

class _StackScreenState extends State<StackScreen> {
  final MyStack<String> stack = MyStack<String>();
  final TextEditingController valueController = TextEditingController();
  String? lastPeeked;

  @override
  void dispose() {
    valueController.dispose();
    super.dispose();
  }

  void pushValue() {
    final value = valueController.text.trim();
    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un valor para insertar')),
      );
      return;
    }

    stack.push(value);
    valueController.clear();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Insertado: $value')),
    );
  }

  void popValue() {
    final value = stack.pop();
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value != null ? 'Eliminado: $value' : 'La pila está vacía',
        ),
        backgroundColor: value != null ? Colors.green : Colors.orange,
      ),
    );
  }

  void peekValue() {
    final value = stack.peek();
    lastPeeked = value;
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value != null ? 'Último: $value' : 'La pila está vacía'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = stack.items.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stack - Pila'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: valueController,
              decoration: const InputDecoration(
                labelText: 'Valor a insertar',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: pushValue,
                    icon: const Icon(Icons.arrow_upward),
                    label: const Text('Push'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: popValue,
                    icon: const Icon(Icons.remove),
                    label: const Text('Pop'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: peekValue,
                    icon: const Icon(Icons.visibility),
                    label: const Text('Peek'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Elementos de la pila',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (items.isEmpty)
                      const Text('La pila está vacía')
                    else
                      SizedBox(
                        height: 180,
                        child: ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: index == 0
                                    ? Colors.deepPurple
                                    : Colors.grey,
                                child: Text('${items.length - index}'),
                              ),
                              title: Text(item),
                              subtitle: index == 0 ? const Text('Tope') : null,
                            );
                          },
                        ),
                      ),
                    if (lastPeeked != null) ...[
                      const SizedBox(height: 10),
                      Text('Último visto: $lastPeeked'),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Historial de acciones',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: stack.history.isEmpty
                  ? const Center(child: Text('No hay acciones aún'))
                  : ListView.separated(
                      itemCount: stack.history.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final log = stack.history[index];
                        return ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(log.action),
                          subtitle: Text(log.value.toString()),
                          trailing: Text(
                            log.timestamp.toString().substring(11, 19),
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
