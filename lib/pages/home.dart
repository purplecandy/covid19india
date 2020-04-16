import 'package:covid19india/app.dart';
import 'package:covid19india/pages/regional.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("COVID 19 India"),
          actions: <Widget>[SwitchTheme()],
          bottom: TabBar(tabs: [
            Tab(
              text: "STATE",
            ),
            Tab(
              text: "COUNTRY",
            ),
          ]),
        ),
        body: TabBarView(children: [RegionalPage(), Container()]),
      ),
    );
  }
}

class SwitchTheme extends StatelessWidget {
  const SwitchTheme({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
            AppTheme.isDark(context) ? Icons.wb_sunny : Icons.brightness_2),
        onPressed: () => AppTheme.toggleTheme(context));
  }
}
