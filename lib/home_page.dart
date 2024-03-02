import 'package:calculator/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> numberList = [
    "AC",
    "(",
    ")",
    "/",
    "7",
    "8",
    "9",
    "*",
    "4",
    "5",
    "6",
    "+",
    "1",
    "2",
    "3",
    "-",
    "C",
    "0",
    ".",
    "=",
  ];
  String result = "0";
  String userInput = "";
  final CacheManager _cache = ManagerImpl();

  @override
  void initState() {
    _read();
    super.initState();
  }

  _read() async {
    userInput = await _cache.getNumber();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 4.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    userInput,
                    style: const TextStyle(color: Colors.white, fontSize: 32),
                  ),
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(20),
              child: Text(result,
                  style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold))),
          const Divider(color: Colors.grey),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: numberList.length,
                itemBuilder: (context, index) {
                  return NumberedButton(numberList[index]);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget NumberedButton(String numberList) {
    return InkWell(
      onTap: () async {
        useButton(numberList);
        await _cache.saveNumber(userInput);
        setState(() {});
      },
      borderRadius: BorderRadius.circular(10),
      splashColor: Colors.grey[850],
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: bgColor(numberList),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(.1),
              blurRadius: 4,
              spreadRadius: 0.5,
              offset: const Offset(-3, -3),
            )
          ],
        ),
        child: Center(
          child: Text(
            numberList,
            style: TextStyle(fontSize: 25, color: getColor(numberList)),
          ),
        ),
      ),
    );
  }

  getColor(String numberList) {
    if (numberList == "(" ||
        numberList == ")" ||
        numberList == "/" ||
        numberList == "*" ||
        numberList == "+" ||
        numberList == "-") {
      return const Color.fromARGB(252, 252, 100, 100);
    }
  }

  bgColor(String numberList) {
    if (numberList == "AC") {
      return const Color.fromARGB(252, 252, 100, 100);
    }
    if (numberList == "=") {
      return const Color.fromARGB(255, 125, 202, 49);
    }
    return const Color.fromARGB(255, 43, 43, 43);
  }

  useButton(String numberList) {
    if (numberList == "AC") {
      userInput = "";
      result = "0";
      return;
    }
    if (result == -0) {
      result = "0";
      return;
    }
    if (numberList == "C") {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
        return;
      } else {
        return null;
      }
    }
    if (numberList == "=") {
      result = calculate(numberList);
      if (result.endsWith(".0")) {
        result = result.replaceAll(".0", "");
        return;
      }
    }
    userInput = userInput + numberList;
  }

  calculate(numberList) {
    try {
      dynamic exp = Parser().parse(userInput);
      dynamic evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      return evaluation.toString();
    } catch (e) {
      "Error";
    }
  }
}
//shared preferences
