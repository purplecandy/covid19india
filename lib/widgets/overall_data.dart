import 'package:covid19india/widgets/empty_result.dart';
import 'package:covid19india/widgets/error_builder.dart';
import 'package:flutter/material.dart';
import 'package:covid19india/blocs/regional_bloc.dart';
import 'package:provider/provider.dart';
import 'package:covid19india/bloc_base.dart';
import 'package:covid19india/models/regionalstats_model.dart';
import 'color_tile.dart';
import 'progress_builder.dart';

class RegionalOverallData extends StatelessWidget {
  const RegionalOverallData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RegionalStatsBloc>(
      builder: (c, bloc, w) => BlocBuilder<RegionalState, RegionalStatsModel>(
        bloc: bloc,
        onSuccess: (context, event) {
          switch (event.state) {
            case RegionalState.empty:
              return EmptyResultBuilder(
                message: "We don't have any cases records for this state.",
              );
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
            case RegionalState.loading:
              return ProgressBuilder(
                message: "Loading overall data",
              );
            default:
              return Container(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.error_outline),
                  ],
                ),
              );
          }
        },
        onError: (context, error) => DefaultErrorBuilder(
          error: error,
        ),
      ),
    );
  }
}
