import 'package:aming_kit/aming_kit.dart';
import 'package:demo/pages/widget.dart';
import 'package:demo/router.dart';
import 'package:flutter/material.dart';

void main() async {
  await OuiApp.run(
    appChild: MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OuiMaterialApp(
      title: 'AMing Demo',
      routes: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return pageBody(
      title: "AMing Demo",
      children: [
        OuiButton(
          onClick: () {
            OuiRoute.goto("utils.permission");
          },
          child: Text(
            "权限",
            style: TextStyle(),
          ),
        ),
      ],
    );
  }
}
