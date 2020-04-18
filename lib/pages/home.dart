import 'package:covid19india/app.dart';
import 'package:covid19india/pages/country.dart';
import 'package:covid19india/pages/regional.dart';
import 'package:covid19india/preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:covid19india/widgets/state_picker.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = ScrollController();
  final _tabChildren = <Widget>[
    RegionalPage(
      key: UniqueKey(),
    ),
    CountryPage(
      key: UniqueKey(),
    )
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    startup();
  }

  void startup() {
    final pref = Provider.of<Preferences>(context, listen: true);
    if (pref.initialized) {
      if (pref.defaultStateName.isEmpty)
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => StatePicker(
                  pref: pref,
                  isDialog: false,
                ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // This is the number of tabs.
      child: Scaffold(
          body: NestedScrollView(
            controller: _controller,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  child: SliverAppBar(
                    title: const Text(
                        'COVID-19 India'), // This is the title in the app bar.
                    pinned: false,
                    expandedHeight: 80.0,
                    forceElevated: innerBoxIsScrolled,
                    actions: <Widget>[SwitchTheme()],
                    bottom: TabBar(
                      // These are the widgets to put in each tab in the tab bar.
                      tabs: [
                        Consumer<Preferences>(
                          builder: (c, pref, _) => Tab(
                            text: pref.initialized ? pref.defaultStateName : "",
                          ),
                        ),
                        Tab(
                          text: "India",
                        )
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(key: UniqueKey(), children: _tabChildren),
          ),
          floatingActionButton: Consumer<Preferences>(
            builder: (c, pref, _) => pref.initialized
                ? (pref.defaultStateName.isEmpty
                    ? Container()
                    : FloatingActionButton(
                        child: Icon(Icons.menu),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => StatePicker(
                                    isDialog: false,
                                    pref: Provider.of<Preferences>(context,
                                        listen: true),
                                  ));
                        },
                      ))
                : Container(),
          )),
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
