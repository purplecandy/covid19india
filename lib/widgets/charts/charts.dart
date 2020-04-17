import 'package:flutter/material.dart';
import 'package:covid19india/widgets/charts/chart_widget.dart';
import 'package:provider/provider.dart';
import 'package:covid19india/models/entity.dart';
import 'package:covid19india/models/regionalstats_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid19india/blocs/regional_bloc.dart';
import 'package:covid19india/bloc_base.dart';

class ChartType with ChangeNotifier {
  int type = 0;
  void update(int val) {
    type = val;
    notifyListeners();
  }
}

class ChartSwitcher extends StatelessWidget {
  final Widget cummulative;
  final Widget daily;
  const ChartSwitcher({Key key, this.cummulative, this.daily})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartType>(
      builder: (c, obj, _) => obj.type == 0 ? cummulative : daily,
    );
  }
}

class ChartContainer extends StatelessWidget {
  final String title;
  final Widget child;
  const ChartContainer({Key key, this.child, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class ChartDaily extends StatelessWidget {
  final String type, title;
  final Color backgroundColor, toolTipColor;
  final charts.Color barColor;
  const ChartDaily(
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

class ChartCummulative extends StatelessWidget {
  final String type, title;
  final Color backgroundColor, toolTipColor;
  final charts.Color barColor;
  const ChartCummulative(
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
                    return yPos;
                  },
                  isCummulative: true,
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
