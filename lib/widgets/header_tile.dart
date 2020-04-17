import 'package:flutter/material.dart';
import 'dart:math';
import 'package:covid19india/blocs/regional_bloc.dart';
import 'package:provider/provider.dart';
import 'package:covid19india/bloc_base.dart';
import 'package:covid19india/models/entity.dart';
import 'package:covid19india/models/regionalstats_model.dart';
import 'package:covid19india/widgets/colorbagde.dart';

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
