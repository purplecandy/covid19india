import 'package:covid19india/blocs/country_bloc.dart';
import 'package:covid19india/models/testing.dart';
import 'package:covid19india/widgets/empty_result.dart';
import 'package:covid19india/widgets/error_builder.dart';
import 'package:covid19india/widgets/progress_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:covid19india/bloc_base.dart';

class TestingDataWidget extends StatelessWidget {
  TestingDataWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CountryTestingBloc>(
      builder: (c, bloc, w) => BlocBuilder<CountryState, TestingModel>(
        bloc: bloc,
        onError: (context, error) => DefaultErrorBuilder(
          error: error,
        ),
        onSuccess: (context, event) {
          switch (event.state) {
            case CountryState.empty:
              return EmptyResultBuilder(
                message: "We don't have any testing data.",
              );
            case CountryState.done:
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
                          "Testing Stats",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade100,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                      event.object.totalSamplesTested
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                  Text(
                                    "Samples Tested",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 45,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.indigo.shade100,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Center(
                                      child: Text(
                                        "${event.object.totalIndividualsTested} Individuals",
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 45,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.indigo.shade100,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Center(
                                      child: Text(
                                        "${event.object.totalPositiveCases} Postive Cases",
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
              break;
            default:
              return ProgressBuilder(
                message: "Calculating testing samples",
              );
          }
        },
      ),
    );
  }
}
