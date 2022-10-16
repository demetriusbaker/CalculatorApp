import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

class SimpleCalculator extends StatefulWidget {
  const SimpleCalculator({Key? key}) : super(key: key);

  @override
  SimpleCalculatorState createState() => SimpleCalculatorState();
}

class SimpleCalculatorState extends State<SimpleCalculator> {
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  buttonPressed(String buttonText) {
    setState(() {
      HapticFeedback.vibrate();

      switch (buttonText) {
        case "C":
          equationFontSize = 38.0;
          resultFontSize = 48.0;

          equation = "0";
          result = "0";
          break;
        case "<":
          equationFontSize = 48.0;
          resultFontSize = 38.0;

          equation = equation.substring(0, equation.length - 1);
          if (equation.isEmpty) equation = "0";
          break;
        case "=":
          equationFontSize = 38.0;
          resultFontSize = 48.0;

          expression = equation;
          expression = expression.replaceAll('×', '*');
          expression = expression.replaceAll('÷', '/');
          expression = expression.replaceAll('−', '-');

          try {
            Parser parser = Parser();
            Expression exp = parser.parse(expression);
            ContextModel contextModel = ContextModel();
            result = "${exp.evaluate(EvaluationType.REAL, contextModel)}";
          } catch (e) {
            result = "Error";
          }
          break;
        default:
          equationFontSize = 48.0;
          resultFontSize = 38.0;

          if (equation.length > 12) {
            return;
          }

          if (equation == "0" || equation == "00") {
            equation = buttonText;
          } else {
            equation += buttonText;
          }
          break;
      }
    });
  }

  Widget buildButton(
      String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: FlatButton(
        onPressed: () => buttonPressed(buttonText),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
            side: const BorderSide(
                color: Colors.white, width: 1, style: BorderStyle.solid)),
        padding: const EdgeInsets.all(16.0),
        child: Text(
          buttonText,
          style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.normal,
              color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              equation,
              style: TextStyle(fontSize: equationFontSize),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Text(
              result,
              style: TextStyle(fontSize: resultFontSize),
            ),
          ),
          const Expanded(child: Divider()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: Table(
                  children: [
                    TableRow(children: [
                      buildButton("C", 1, Colors.redAccent),
                      buildButton("<", 1, Colors.blue),
                      buildButton("÷", 1, Colors.blue),
                    ]),
                    TableRow(children: [
                      buildButton("7", 1, Colors.black54),
                      buildButton("8", 1, Colors.black54),
                      buildButton("9", 1, Colors.black54),
                    ]),
                    TableRow(children: [
                      buildButton("4", 1, Colors.black54),
                      buildButton("5", 1, Colors.black54),
                      buildButton("6", 1, Colors.black54),
                    ]),
                    TableRow(children: [
                      buildButton("1", 1, Colors.black54),
                      buildButton("2", 1, Colors.black54),
                      buildButton("3", 1, Colors.black54),
                    ]),
                    TableRow(children: [
                      buildButton(".", 1, Colors.black54),
                      buildButton("0", 1, Colors.black54),
                      buildButton("00", 1, Colors.black54),
                    ]),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        buildButton("×", 1, Colors.blue),
                      ],
                    ),
                    TableRow(
                      children: [
                        buildButton("−", 1, Colors.blue),
                      ],
                    ),
                    TableRow(
                      children: [
                        buildButton("+", 1, Colors.blue),
                      ],
                    ),
                    TableRow(
                      children: [
                        buildButton("=", 2, Colors.redAccent),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
