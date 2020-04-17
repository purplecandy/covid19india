import 'package:covid19india/bloc_base.dart';
import 'package:covid19india/blocs/regional_bloc.dart';
import 'package:covid19india/models/entity.dart';
import 'package:covid19india/models/regionalstats_model.dart';
import 'package:covid19india/repository.dart';
import 'package:covid19india/widgets/chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid19india/widgets/color_tile.dart';
import 'package:covid19india/preferences.dart';
import 'dart:math';

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
    final pref = Provider.of<Preferences>(context, listen: true);
    if (repo.casesCountLatest.isNotEmpty) {
      if (pref.initialized && pref.defaultStateName.isNotEmpty) {
        startup(repo, pref.defaultStateName);
      }
    }
    super.didChangeDependencies();
  }

  void startup(Repository repo, String stateName) {
    bloc.dispatch(RegionalAction.fetch,
        {"state_name": stateName, "json_data": repo.casesCountLatest});
    blocData.dispatch(RegionalAction.fetch,
        {"state_name": stateName, "json_data": repo.casesCountHistory});
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
                                title: "Last week",
                                days: 7,
                              ),
                              HeaderTile(
                                title: "Last month",
                                days: 30,
                              ),
                              ConfirmedChartDaily(
                                backgroundColor: Colors.red.shade100,
                                barColor:
                                    charts.MaterialPalette.red.shadeDefault,
                                title: "Confirmed",
                                toolTipColor: Colors.red,
                                type: "confirmed",
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              ConfirmedChartDaily(
                                backgroundColor: Colors.green.shade100,
                                barColor:
                                    charts.MaterialPalette.green.shadeDefault,
                                title: "Recovered",
                                toolTipColor: Colors.green,
                                type: "recovered",
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              ConfirmedChartDaily(
                                backgroundColor: Colors.grey.shade100,
                                barColor:
                                    charts.MaterialPalette.gray.shadeDefault,
                                title: "Deaths",
                                toolTipColor: Colors.grey,
                                type: "deaths",
                              )
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

  Map<String, int> getFlex(List<int> values) {
    Map<String, int> flexes = {};
    int maxV = values.reduce(max);
    int minV = values.reduce(min);
    for (var i = 0; i < values.length; i++) {
      if (values[i] == maxV) {
        flexes[_keyName(i)] = 3;
      } else if (values[i] == minV) {
        flexes[_keyName(i)] = 1;
      } else {
        flexes[_keyName(i)] = 2;
      }
    }

    return flexes;
  }

  String _keyName(int i) {
    switch (i) {
      case 0:
        return "confirmed";
        break;
      case 1:
        return "recovered";
        break;
      case 2:
        return "deaths";
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RegionalStatsData>(
      builder: (c, bloc, w) =>
          BlocBuilder<RegionalState, List<Entity<RegionalStatsModel>>>(
        bloc: bloc,
        onSuccess: (context, event) {
          switch (event.state) {
            case RegionalState.done:
              List<int> values = [];
              values.add(bloc.getTotalCasesByDays(days)["confirmed"]);
              values.add(bloc.getTotalCasesByDays(days)["recovered"]);
              values.add(bloc.getTotalCasesByDays(days)["deaths"]);
              final flex = getFlex(values);
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
                            Expanded(
                              flex: flex["confirmed"],
                              child: ColorBadge(
                                backgroundColor: Colors.red.shade100,
                                textColor: Colors.red,
                                content: values[0].toString(),
                              ),
                            ),
                            // Expanded(
                            //   child: ColorBadge(
                            //     backgroundColor: Colors.blue.shade100,
                            //     textColor: Colors.blue,
                            //     content: bloc
                            //         .getTotalCasesByDays(days)["active"]
                            //         .toString(),
                            //   ),
                            // ),
                            Expanded(
                              flex: flex["recovered"],
                              child: ColorBadge(
                                backgroundColor: Colors.green.shade100,
                                textColor: Colors.green,
                                content: values[1].toString(),
                              ),
                            ),
                            Expanded(
                              flex: flex["deaths"],
                              child: ColorBadge(
                                backgroundColor: Colors.grey.shade100,
                                textColor: Colors.grey,
                                content: values[2].toString(),
                              ),
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
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
                      child: Text(
                        "Overall",
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

class ConfirmedChartDaily extends StatelessWidget {
  final String type, title;
  final Color backgroundColor, toolTipColor;
  final charts.Color barColor;
  const ConfirmedChartDaily(
      {Key key,
      this.type,
      this.title,
      this.barColor,
      this.backgroundColor,
      this.toolTipColor})
      : super(key: key);

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
                child: ChartWidget<Entity<RegionalStatsModel>>(
                  backgroundColor: backgroundColor,
                  barColor: barColor,
                  tooltipColor: toolTipColor,
                  chartId: title,
                  xAxisData: (_, i) => event.object[i].date,
                  yAxisData: (d, i) {
                    int yPos;
                    int diff;
                    var entity = i == 0 ? event.object[i] : event.object[i - 1];

                    switch (type) {
                      case "confirmed":
                        yPos = d.data.totalConfirmed;
                        diff = entity.data.totalConfirmed;
                        break;
                      case "recovered":
                        yPos = d.data.discharged;
                        diff = entity.data.discharged;
                        break;
                      case "deaths":
                        yPos = d.data.deaths;
                        diff = entity.data.deaths;
                        break;
                      default:
                        throw ("Invalid type");
                    }
                    return i == 0 ? yPos : (yPos - diff).abs();
                  },
                  isCummulative: false,
                  seriesData: event.object,
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
