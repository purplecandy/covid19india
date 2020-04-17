import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:covid19india/app.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as t;
import 'package:charts_flutter/src/text_style.dart' as style;

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
                    ? tooltipText.value +
                        " cases on " +
                        DateFormat.MMMMd().format(tooltipText.date)
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
                  animationDuration: Duration(milliseconds: 450),
                  behaviors: [
                    charts.LinePointHighlighter(
                        symbolRenderer:
                            CustomCircleSymbolRenderer(tooltipText)),
                    charts.SelectNearest(
                        eventTrigger: charts.SelectionTrigger.tapAndDrag)
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

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  final _TooltipText text;
  CustomCircleSymbolRenderer(this.text);
  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      charts.Color fillColor,
      charts.FillPatternType fillPattern,
      charts.Color strokeColor,
      double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        fillPattern: fillPattern,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
        Rectangle(
            bounds.left - 5, bounds.top, bounds.width + 30, bounds.height + 10),
        fill: charts.Color.white);
    var textStyle = style.TextStyle();
    textStyle.color = charts.Color.black;
    textStyle.fontSize = 21;
    canvas.drawText(t.TextElement(text.value, style: textStyle),
        (bounds.left).round(), (bounds.top - 30).round());
  }
}
