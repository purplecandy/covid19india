import 'package:covid19india/blocs/country_bloc.dart';
import 'package:covid19india/models/countrystats_model.dart';
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
              return _OverallStatsTiles(
                confirmed: event.object.totalConfirmed,
                deaths: event.object.deaths,
                recovered: event.object.discharged,
                active: (event.object.totalConfirmed -
                    (event.object.deaths + event.object.discharged)),
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

class CountryOverallData extends StatelessWidget {
  const CountryOverallData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CountryOverallBloc>(
      builder: (c, bloc, w) => BlocBuilder<CountryState, CountryOverallModel>(
        bloc: bloc,
        onSuccess: (context, event) {
          switch (event.state) {
            case CountryState.empty:
              return EmptyResultBuilder(
                message: "We don't have any cases records for this state.",
              );
            case CountryState.done:
              return _OverallStatsTiles(
                confirmed: event.object.totalConfirmed,
                deaths: event.object.deaths,
                recovered: event.object.discharged,
                active: event.object.active,
              );
              break;
            case CountryState.loading:
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

class _OverallStatsTiles extends StatelessWidget {
  final int confirmed, recovered, active, deaths;
  const _OverallStatsTiles(
      {Key key, this.confirmed, this.recovered, this.active, this.deaths})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double padding = 8.0;
    double cwidth = MediaQuery.of(context).size.width - padding * 2;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
            child: Text(
              "Overall",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
            ),
          ),
          Wrap(
            children: <Widget>[
              SizedBox(
                width: cwidth * 0.5,
                child: ColorTile(
                  title: "Confirmed",
                  content: confirmed.toString(),
                  background: Colors.red.shade100,
                  textColor: Color(0xFFff073a),
                ),
              ),
              SizedBox(
                width: cwidth * 0.5,
                child: ColorTile(
                  title: "Active",
                  content: active.toString(),
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
                  content: recovered.toString(),
                  background: Colors.green.shade100,
                  textColor: Colors.green,
                ),
              ),
              SizedBox(
                width: cwidth * 0.5,
                child: ColorTile(
                  title: "Deceased",
                  content: deaths.toString(),
                  background: Colors.grey.shade100,
                  textColor: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
