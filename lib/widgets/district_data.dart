import 'package:flutter/material.dart';
import 'package:covid19india/blocs/regional_bloc.dart';
import 'package:provider/provider.dart';
import 'package:covid19india/bloc_base.dart';
import 'package:covid19india/models/district.dart';
import 'package:covid19india/app.dart';

class DistrictData extends StatelessWidget {
  final List<Color> shades = [
    Colors.pink.shade100,
    Colors.pink.shade200,
    Colors.pink.shade300,
    Colors.pink.shade400,
    Colors.pink.shade500
  ];
  DistrictData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RegionalDistrictBloc>(
      builder: (c, bloc, w) => BlocBuilder<RegionalState, List<DistrictModel>>(
        bloc: bloc,
        onSuccess: (context, event) {
          switch (event.state) {
            case RegionalState.done:
              return Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8),
                        child: Text(
                          "Most affected districts",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: event.object.length,
                          itemBuilder: (context, index) => Container(
                            height: 40,
                            margin: EdgeInsets.all(1),
                            padding: EdgeInsets.only(left: 12, right: 12),
                            decoration: BoxDecoration(
                                // color: Colors.red.shade100,
                                color: shades[(shades.length - 1) - index]
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(9)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  event.object[index].name,
                                  style: TextStyle(
                                      color: AppTheme.isDark(context)
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  event.object[index].confirmedCases.toString(),
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
