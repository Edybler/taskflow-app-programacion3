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
<<<<<<< HEAD
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Insertado: $value')));
  }

  void popValue() {
    final item = stack.pop();
    if (item == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La pila está vacía'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {});
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Eliminado: $item')));
  }

  void peekValue() {
    final item = stack.peek();
    lastPeeked = item;
=======
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Insertado: $value')),
    );
  }

  void popValue() {
    final value = stack.pop();
>>>>>>> 5d389afce327bcb9b0a4380794e911934e089f9a
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
<<<<<<< HEAD
        content: Text(item != null ? 'Último: $item' : 'La pila está vacía'),
=======
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
>>>>>>> 5d389afce327bcb9b0a4380794e911934e089f9a
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      appBar: AppBar(title: const Text('Pila (Stack)'), centerTitle: true),
=======
    final items = stack.items.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stack - Pila'),
        centerTitle: true,
      ),
>>>>>>> 5d389afce327bcb9b0a4380794e911934e089f9a
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
<<<<<<< HEAD
                    icon: const Icon(Icons.delete),
=======
                    icon: const Icon(Icons.remove),
>>>>>>> 5d389afce327bcb9b0a4380794e911934e089f9a
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
<<<<<<< HEAD
              elevation: 2,
=======
              margin: EdgeInsets.zero,
>>>>>>> 5d389afce327bcb9b0a4380794e911934e089f9a
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
<<<<<<< HEAD
                      'Elementos en la pila',
=======
                      'Elementos de la pila',
>>>>>>> 5d389afce327bcb9b0a4380794e911934e089f9a
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
<<<<<<< HEAD
                    const SizedBox(height: 8),
                    if (stack.isEmpty)
                      const Text('No hay elementos en la pila')
                    else
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          itemCount: stack.items.length,
                          itemBuilder: (context, index) {
                            final position = stack.items.length - index;
                            final item = stack.items.reversed.toList()[index];
                            final isTop = index == 0;
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isTop
                                    ? Colors.deepPurple
                                    : Colors.grey,
                                child: Text('$position'),
                              ),
                              title: Text(item),
                              subtitle: isTop ? const Text('Tope') : null,
=======
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
>>>>>>> 5d389afce327bcb9b0a4380794e911934e089f9a
                            );
                          },
                        ),
                      ),
                    if (lastPeeked != null) ...[
<<<<<<< HEAD
                      const SizedBox(height: 12),
=======
                      const SizedBox(height: 10),
>>>>>>> 5d389afce327bcb9b0a4380794e911934e089f9a
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
<<<<<<< HEAD
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
=======
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
>>>>>>> 5d389afce327bcb9b0a4380794e911934e089f9a
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: stack.history.isEmpty
<<<<<<< HEAD
                  ? const Center(child: Text('No hay acciones registradas'))
=======
                  ? const Center(child: Text('No hay acciones aún'))
>>>>>>> 5d389afce327bcb9b0a4380794e911934e089f9a
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
