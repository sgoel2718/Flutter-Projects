import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:auto_size_text/auto_size_text.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String equation = "";
  String result = "";
  String expression = "";
  double equationFontSize = 40.0;
  double resultFontSize = 32.0;

  Size _screenSize;

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "";
        result = "";
      } else if (buttonText == 'DEL') {
        equation = equation.substring(0, equation.length - 1);
        if (buttonText == "") {
          result = "";
        }
      } else if (buttonText == "=") {
        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          result=eval.toString();
          equation = result;
        } catch (e) {
          result = 'Error';
        }
      } else {
        if (equation == '0') {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  Widget buildButton(
      String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        padding: EdgeInsets.all(16.0),
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.normal,
              color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          calculatorTop(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Table(
                    children: [
                      TableRow(children: [
                        buildButton("7", 1.5, Colors.black),
                        buildButton("8", 1.5, Colors.black),
                        buildButton("9", 1.5, Colors.black),
                      ]),
                      TableRow(children: [
                        buildButton("4", 1.5, Colors.black),
                        buildButton("5", 1.5, Colors.black),
                        buildButton("6", 1.5, Colors.black),
                        //buildButton("x", 1, Colors.grey),
                      ]),
                      TableRow(children: [
                        buildButton("1", 1.5, Colors.black),
                        buildButton("2", 1.5, Colors.black),
                        buildButton("3", 1.5, Colors.black),
                        //buildButton("C", 1, Colors.grey),
                      ]),
                      TableRow(children: [
                        buildButton(".", 1.5, Colors.black),
                        buildButton("0", 1.5, Colors.black),
                        buildButton("DEL", 1.5, Colors.black),
                        //buildButton("C", 1, Colors.grey),
                      ]),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Table(
                    children: [
                      TableRow(children: [
                        buildButton("C", 1, Colors.black45),
                      ]),
                      TableRow(children: [
                        buildButton("÷", 1, Colors.black45),
                      ]),
                      TableRow(children: [
                        buildButton("×", 1, Colors.black45),
                      ]),
                      TableRow(children: [
                        buildButton("-", 1, Colors.black45),
                      ]),
                      TableRow(children: [
                        buildButton("+", 1, Colors.black45),
                      ]),
                      TableRow(children: [
                        buildButton("=", 1, Colors.red),
                      ])
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget calculatorTop() {
    return Container(
      height: _screenSize.height * 0.4,
      color: Colors.black.withOpacity(0.8),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: AutoSizeText(
                equation,
                maxLines: 1,
                minFontSize: resultFontSize,
                style: TextStyle(fontSize: equationFontSize),
              )),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: AutoSizeText(
                result,
                maxLines: 1,
                minFontSize: resultFontSize,
                style: TextStyle(fontSize: resultFontSize),
              )),
        ],
      ),
    );
  }
}