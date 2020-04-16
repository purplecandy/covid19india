import 'package:covid19india/app.dart';
import 'package:covid19india/pages/regional.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // This is the number of tabs.
      child: Scaffold(
        body: NestedScrollView(
          controller: _controller,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                  bottom: TabBar(
                    // These are the widgets to put in each tab in the tab bar.
                    tabs: [
                      Tab(
                        text: "Maharastra",
                      ),
                      Tab(
                        text: "Country",
                      )
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            // These are the contents of the tab views, below the tabs.
            children: [RegionalPage(), Container()],
          ),
        ),
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
