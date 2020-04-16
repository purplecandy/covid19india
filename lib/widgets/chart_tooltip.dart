import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_element.dart' as t;
import 'package:charts_flutter/src/text_style.dart' as style;

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
  final String text;
  CustomCircleSymbolRenderer(this.text);
  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      Color fillColor,
      FillPatternType fillPattern,
      Color strokeColor,
      double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        fillPattern: fillPattern,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
        Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10,
            bounds.height + 10),
        fill: Color.white);
    var textStyle = style.TextStyle();
    textStyle.color = Color.black;
    textStyle.fontSize = 21;
    canvas.drawText(t.TextElement(text, style: textStyle),
        (bounds.left + 20).round(), (bounds.top + 28).round());
  }
}

class TooltipText with ChangeNotifier {
  String value = "";
  DateTime date = DateTime(2020);
  TooltipText(this.value, this.date);

  update(int val, DateTime date) {
    value = val.toString();
    this.date = date;
    print(value);
    notifyListeners();
  }
}
