import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:covid19india/app.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class _TooltipText with ChangeNotifier {
  String value = "";
  DateTime date = DateTime(2020);
  _TooltipText(this.value, this.date);

  update(int val, DateTime date) {
    value = val.toString();
    this.date = date;
    notifyListeners();
  }
}

class ChartWidget<T> extends StatefulWidget {
  final Color backgroundColor;
  final Color tooltipColor;
  final charts.Color barColor;
  final String chartId;
  final DateTime Function(dynamic item, int index) xAxisData;
  final num Function(dynamic item, int index) yAxisData;
  final List<T> seriesData;
  final bool isCummulative;
  const ChartWidget({
    Key key,
    this.chartId,
    this.xAxisData,
    this.yAxisData,
    this.seriesData,
    this.backgroundColor,
    this.barColor,
    this.tooltipColor,
    this.isCummulative,
  }) : super(key: key);

  @override
  _ChartWidgetState createState() => _ChartWidgetState<T>();
}

class _ChartWidgetState<T> extends State<ChartWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_TooltipText>(
      create: (_) => _TooltipText("", null),
      child: _Chart<T>(
        xAxisData: widget.xAxisData,
        yAxisData: widget.yAxisData,
        seriesData: widget.seriesData,
        backgroundColor: widget.backgroundColor,
        barColor: widget.barColor,
        tooltipColor: widget.tooltipColor,
        isCumulative: widget.isCummulative,
        chartId: widget.chartId,
      ),
    );
  }
}

class _Chart<T> extends StatelessWidget {
  final Color backgroundColor;
  final charts.Color barColor;
  final Color tooltipColor;
  final String chartId;
  final DateTime Function(dynamic item, int index) xAxisData;
  final num Function(dynamic item, int index) yAxisData;
  final List<T> seriesData;
  final bool isCumulative;
  const _Chart({
    Key key,
    this.chartId,
    this.xAxisData,
    this.yAxisData,
    this.seriesData,
    this.backgroundColor,
    this.barColor,
    this.tooltipColor,
    this.isCumulative,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<_TooltipText>(
      builder: (c, tooltipText, _) => Card(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                tooltipText.date != null
                    ? DateFormat.MMMMd().format(tooltipText.date) +
                        " - " +
                        tooltipText.value
                    : "",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: tooltipColor),
              ),
              Expanded(
                child: charts.TimeSeriesChart(
                  [
                    charts.Series<T, DateTime>(
                      colorFn: (_, i) => barColor,
                      id: chartId,
                      data: seriesData,
                      domainFn: xAxisData,
                      measureFn: yAxisData,
                    )
                  ],

                  // primaryMeasureAxis: charts.NumericAxisSpec(
                  //     renderSpec: charts.GridlineRendererSpec(
                  //         labelStyle: charts.TextStyleSpec(
                  //   color: AppTheme.isDark(context)
                  //       ? charts.MaterialPalette.white
                  //       : charts.MaterialPalette.black,
                  // ))),
                  // domainAxis: charts.DateTimeAxisSpec(
                  //     renderSpec: charts.GridlineRendererSpec(
                  //         labelStyle: charts.TextStyleSpec(
                  //   color: AppTheme.isDark(context)
                  //       ? charts.MaterialPalette.white
                  //       : charts.MaterialPalette.black,
                  // ))),
                  // secondaryMeasureAxis: charts.NumericAxisSpec(
                  //     renderSpec: charts.GridlineRendererSpec(
                  //         labelStyle: charts.TextStyleSpec(
                  //   color: AppTheme.isDark(context)
                  //       ? charts.MaterialPalette.white
                  //       : charts.MaterialPalette.black,
                  // ))),
                  defaultRenderer: !isCumulative
                      ? charts.BarRendererConfig<DateTime>()
                      : null,
                  selectionModels: [
                    charts.SelectionModelConfig(
                        changedListener: (charts.SelectionModel model) {
                      if (model.hasDatumSelection)
                        // print(model.selectedDatum.first.datum.date);
                        tooltipText.update(
                            (model.selectedSeries[0]
                                .measureFn(model.selectedDatum[0].index)),
                            model.selectedDatum.first.datum.date);
                    })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
