import 'package:covid19india/bloc_base.dart';
import 'package:covid19india/blocs/regional_bloc.dart';
import 'package:covid19india/models/entity.dart';
import 'package:covid19india/models/regionalstats_model.dart';
import 'package:covid19india/repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;

class RegionalPage extends StatefulWidget {
  RegionalPage({Key key}) : super(key: key);

  @override
  _RegionalPageState createState() => _RegionalPageState();
}

class _RegionalPageState extends State<RegionalPage> {
  final bloc = RegionalStatsBloc();
  final blocData = RegionalStatsData();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final repo = Provider.of<Repository>(context, listen: true);
    if (repo.casesCountLatest.isNotEmpty) startup(repo);
    super.didChangeDependencies();
  }

  void startup(Repository repo) {
    bloc.dispatch(RegionalAction.fetch,
        {"state_name": "Maharashtra", "json_data": repo.casesCountLatest});
    blocData.dispatch(RegionalAction.fetch,
        {"state_name": "Maharashtra", "json_data": repo.casesCountHistory});
  }

  @override
  Widget build(BuildContext context) {
    return Provider<RegionalStatsBloc>(
      create: (_) => bloc,
      child: Provider<RegionalStatsData>(
          create: (_) => blocData,
          child: SafeArea(
              child: Builder(
                  builder: (context) => CustomScrollView(
                        key: PageStorageKey("sad"),
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            // This is the flip side of the SliverOverlapAbsorber above.
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                          ),
                          SliverList(
                              delegate: SliverChildListDelegate(
                            [
                              MetaData(),
                              HeaderTile(
                                title: "Yesterday",
                                days: 1,
                              ),
                              HeaderTile(
                                title: "Last 7 days",
                                days: 7,
                              ),
                              HeaderTile(
                                title: "Last 14 days",
                                days: 14,
                              ),
                              Charts()
                            ],
                          ))
                        ],
                      )))),
    );
  }
}

class HeaderTile extends StatelessWidget {
  final String title;
  final int days;
  const HeaderTile({Key key, this.title, this.days}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RegionalStatsData>(
      builder: (c, bloc, w) =>
          BlocBuilder<RegionalState, List<Entity<RegionalStatsModel>>>(
        bloc: bloc,
        onSuccess: (context, event) {
          switch (event.state) {
            case RegionalState.done:
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ColorBadge(
                              backgroundColor: Colors.red.shade100,
                              textColor: Colors.red,
                              content: bloc
                                  .getTotalCasesByDays(days)["confirmed"]
                                  .toString(),
                            ),
                            ColorBadge(
                              backgroundColor: Colors.blue.shade100,
                              textColor: Colors.blue,
                              content: bloc
                                  .getTotalCasesByDays(days)["active"]
                                  .toString(),
                            ),
                            ColorBadge(
                              backgroundColor: Colors.green.shade100,
                              textColor: Colors.green,
                              content: bloc
                                  .getTotalCasesByDays(days)["recovered"]
                                  .toString(),
                            ),
                            ColorBadge(
                              backgroundColor: Colors.grey.shade100,
                              textColor: Colors.grey,
                              content: bloc
                                  .getTotalCasesByDays(days)["deaths"]
                                  .toString(),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
              break;
            default:
              return Container();
          }
        },
      ),
    );
  }
}

class ColorBadge extends StatelessWidget {
  final String content;
  final Color backgroundColor;
  final Color textColor;
  const ColorBadge(
      {Key key, this.content, this.backgroundColor, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(4)),
      child: Text(
        content,
        style: TextStyle(
            color: textColor, fontSize: 19, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class MetaData extends StatelessWidget {
  const MetaData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RegionalStatsBloc>(
      builder: (c, bloc, w) => BlocBuilder<RegionalState, RegionalStatsModel>(
        bloc: bloc,
        onSuccess: (context, event) {
          switch (event.state) {
            case RegionalState.done:
              double padding = 8.0;
              double cwidth = MediaQuery.of(context).size.width - padding * 2;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        event.object.loc,
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Wrap(
                      children: <Widget>[
                        SizedBox(
                          width: cwidth * 0.5,
                          child: ColorTile(
                            title: "Confirmed",
                            content: event.object.totalConfirmed.toString(),
                            background: Colors.red.shade100,
                            textColor: Color(0xFFff073a),
                          ),
                        ),
                        SizedBox(
                          width: cwidth * 0.5,
                          child: ColorTile(
                            title: "Active",
                            content: (event.object.totalConfirmed -
                                    (event.object.deaths +
                                        event.object.discharged))
                                .toString(),
                            background: Colors.blue.shade100,
                            textColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: cwidth * 0.5,
                          child: ColorTile(
                            title: "Recovered",
                            content: event.object.discharged.toString(),
                            background: Colors.green.shade100,
                            textColor: Colors.green,
                          ),
                        ),
                        SizedBox(
                          width: cwidth * 0.5,
                          child: ColorTile(
                            title: "Deceased",
                            content: event.object.deaths.toString(),
                            background: Colors.grey.shade100,
                            textColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
              break;
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
        onError: (context, error) => Center(
          child: Text(error.toString()),
        ),
      ),
    );
  }
}

class Charts extends StatefulWidget {
  const Charts({Key key}) : super(key: key);

  @override
  _ChartsState createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RegionalStatsData>(
      builder: (c, bloc, w) =>
          BlocBuilder<RegionalState, List<Entity<RegionalStatsModel>>>(
        bloc: bloc,
        onSuccess: (context, event) {
          switch (event.state) {
            case RegionalState.done:
              return Container(
                height: 400,
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: charts.TimeSeriesChart(
                      [
                        charts.Series<Entity<RegionalStatsModel>, DateTime>(
                            labelAccessorFn: (_, i) =>
                                event.object[i].data.totalConfirmed.toString(),
                            id: "Day wise ",
                            domainFn: (_, i) => event.object[i].date,
                            measureFn: (d, i) => i == 0
                                ? d.data.totalConfirmed
                                : (d.data.totalConfirmed -
                                        event.object[i - 1].data.totalConfirmed)
                                    .abs(),
                            data: event.object)
                      ],
                      defaultRenderer: new charts.BarRendererConfig<DateTime>(),
                    ),
                  ),
                ),
              );
              break;
            default:
              return Container();
          }
        },
      ),
    );
  }
}

class ColorTile extends StatelessWidget {
  final String title, content;
  final Color background;
  final Color textColor;
  const ColorTile(
      {Key key, this.title, this.content, this.background, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      child: Card(
        color: background,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                content,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
