import 'package:covid19india/blocs/country_bloc.dart';
import 'package:covid19india/models/regionalstats_model.dart';
import 'package:covid19india/widgets/empty_result.dart';
import 'package:covid19india/widgets/error_builder.dart';
import 'package:covid19india/widgets/progress_builder.dart';
import 'package:flutter/material.dart';
import 'package:covid19india/blocs/regional_bloc.dart';
import 'package:provider/provider.dart';
import 'package:covid19india/bloc_base.dart';
import 'package:covid19india/models/district.dart';
import 'package:covid19india/app.dart';

class DistrictData extends StatelessWidget {
  DistrictData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RegionalDistrictBloc>(
      builder: (c, bloc, w) => BlocBuilder<RegionalState, List<DistrictModel>>(
        bloc: bloc,
        onError: (context, error) => DefaultErrorBuilder(
          error: error,
        ),
        onSuccess: (context, event) {
          switch (event.state) {
            case RegionalState.empty:
              return EmptyResultBuilder(
                message:
                    "We don't have any district level records for this state.",
              );
            case RegionalState.done:
              return _OrderedTiles(
                title: "Most affected districts",
                count: event.object.length,
                getTitle: (i) => event.object[i].name,
                getCount: (i) => event.object[i].confirmedCases.toString(),
              );
              break;
            case RegionalState.loading:
              return ProgressBuilder(
                message: "Finding district level data",
              );
            default:
              return Text("Hello WOrld");
          }
        },
      ),
    );
  }
}

class CountryRegionalData extends StatelessWidget {
  CountryRegionalData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CountryRegionalBloc>(
      builder: (c, bloc, w) =>
          BlocBuilder<CountryState, List<RegionalStatsModel>>(
        bloc: bloc,
        onError: (context, error) => DefaultErrorBuilder(
          error: error,
        ),
        onSuccess: (context, event) {
          switch (event.state) {
            case CountryState.empty:
              return EmptyResultBuilder(
                message:
                    "We don't have any state level records for this state.",
              );
            case CountryState.done:
              return _OrderedTiles(
                title: "Most affected states",
                count: event.object.length,
                getTitle: (i) => event.object[i].loc,
                getCount: (i) => event.object[i].totalConfirmed.toString(),
              );
              break;
            case CountryState.loading:
              return ProgressBuilder(
                message: "Finding state level data",
              );
            default:
              return Text("Hello WOrld");
          }
        },
      ),
    );
  }
}

class _OrderedTiles extends StatelessWidget {
  final String title;
  final String Function(int index) getTitle;
  final String Function(int index) getCount;
  final int count;
  final List<Color> shades = [
    Colors.pink.shade100,
    Colors.pink.shade200,
    Colors.pink.shade300,
    Colors.pink.shade400,
    Colors.pink.shade500
  ];
  _OrderedTiles({Key key, this.title, this.getTitle, this.getCount, this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8),
              child: Text(
                title,
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: count,
                itemBuilder: (context, index) => Container(
                  height: 40,
                  margin: EdgeInsets.all(1),
                  padding: EdgeInsets.only(left: 12, right: 12),
                  decoration: BoxDecoration(
                      // color: Colors.red.shade100,
                      color:
                          shades[(shades.length - 1) - index].withOpacity(0.5),
                      borderRadius: BorderRadius.circular(9)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getTitle(index),
                        style: TextStyle(
                            color: AppTheme.isDark(context)
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w300),
                      ),
                      Text(
                        getCount(index),
                        style: TextStyle(
                            // fontSize: 18,
                            // color: Color(0xFFff073a),
                            color: AppTheme.isDark(context)
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
