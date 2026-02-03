import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart'; // External package for expression evaluationer

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alexs Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key});

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _display = '';
  String _expression = '';

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _display = '';
        _expression = '';
      } else if (buttonText == '=') {
        if (_expression.isNotEmpty) {
          try {
            final expression = Expression.parse(_expression);
            final evaluator = const ExpressionEvaluator();
            final result = evaluator.eval(expression, {});
            _display = '$_expression = $result';
            _expression = result.toString();
          } catch (e) {
            _display = 'Error';
            _expression = '';
          }
        }
      } else {
        if (_display.contains('=')) {
          // After showing result, start new expression
          _expression = buttonText;
          _display = buttonText;
        } else {
          _expression += buttonText;
          _display = _expression;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        title: const Text('Alexs Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _display,
                style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(height: 1.0),
          Expanded(
            flex: 2,
            child: GridView.count(
              crossAxisCount: 4,
              children: <String>[
                '7', '8', '9', '/',
                '4', '5', '6', '*',
                '1', '2', '3', '-',
                '0', 'C', '=', '+',
              ].map((String text) {
                return GridTile(
                  child: ElevatedButton(
                    onPressed: () => _onButtonPressed(text),
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 24.0),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
