// import 'package:covid19india/bloc_base.dart';
import 'package:covid19india/bloc_base.dart';
import 'package:covid19india/blocs/country_bloc.dart';
import 'package:covid19india/models/countrystats_model.dart';
import 'package:covid19india/models/entity.dart';
// import 'package:covid19india/blocs/regional_bloc.dart';
// import 'package:covid19india/models/entity.dart';
// import 'package:covid19india/models/regionalstats_model.dart';
import 'package:covid19india/repository.dart';
import 'package:covid19india/widgets/charts/charts.dart';
import 'package:covid19india/widgets/district_data.dart';
import 'package:covid19india/widgets/error_builder.dart';
// import 'package:covid19india/widgets/error_builder.dart';
import 'package:covid19india/widgets/overall_data.dart';
import 'package:covid19india/widgets/progress_builder.dart';
import 'package:covid19india/widgets/testing_data.dart';
// import 'package:covid19india/widgets/progress_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid19india/preferences.dart';
import 'package:covid19india/widgets/header_tile.dart';
// import 'package:covid19india/widgets/district_data.dart';
// import 'package:covid19india/widgets/hospital_data.dart';
// import 'package:covid19india/widgets/charts/charts.dart';

class CountryPage extends StatefulWidget {
  CountryPage({Key key}) : super(key: key);

  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage>
    with AutomaticKeepAliveClientMixin {
  final bloc = CountryOverallBloc();
  final blocData = CountryStatsBloc();
  final blocRegional = CountryRegionalBloc();
  final blocTesting = CountryTestingBloc();
  final chartType = ChartType();

  final confirmedChart = ChartContainer(
    title: "Total Confirmed",
    child: ChartSwitcher(
      cummulative: CountryChartCummulative(
        backgroundColor: Colors.red.shade100,
        barColor: charts.MaterialPalette.red.shadeDefault,
        title: "Confirmed",
        toolTipColor: Colors.red,
        type: "confirmed",
      ),
      daily: CountryChartDaily(
        backgroundColor: Colors.red.shade100,
        barColor: charts.MaterialPalette.red.shadeDefault,
        title: "Confirmed",
        toolTipColor: Colors.red,
        type: "confirmed",
      ),
    ),
  );

  final recoveredChart = ChartContainer(
    title: "Total Recovered",
    child: ChartSwitcher(
      cummulative: CountryChartCummulative(
        backgroundColor: Colors.green.shade100,
        barColor: charts.MaterialPalette.green.shadeDefault,
        title: "Recovered",
        toolTipColor: Colors.green,
        type: "recovered",
      ),
      daily: CountryChartDaily(
        backgroundColor: Colors.green.shade100,
        barColor: charts.MaterialPalette.green.shadeDefault,
        title: "Recovered",
        toolTipColor: Colors.green,
        type: "recovered",
      ),
    ),
  );

  final deceasedChart = ChartContainer(
    title: "Total Deceased",
    child: ChartSwitcher(
      cummulative: CountryChartCummulative(
        backgroundColor: Colors.grey.shade100,
        barColor: charts.MaterialPalette.gray.shadeDefault,
        title: "Deaths",
        toolTipColor: Colors.grey,
        type: "deaths",
      ),
      daily: CountryChartDaily(
        backgroundColor: Colors.grey.shade100,
        barColor: charts.MaterialPalette.gray.shadeDefault,
        title: "Deaths",
        toolTipColor: Colors.grey,
        type: "deaths",
      ),
    ),
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final repo = Provider.of<Repository>(context, listen: true);
    final pref = Provider.of<Preferences>(context, listen: true);
    if (pref.initialized && pref.defaultStateName.isNotEmpty) {
      startup(repo, pref.defaultStateName);
    }
    super.didChangeDependencies();
  }

  void startup(Repository repo, String stateName) {
    if (repo.casesCountLatest != null) {
      bloc.dispatch(CountryAction.fetch, {"json_data": repo.casesCountLatest});
      blocRegional
          .dispatch(CountryAction.fetch, {"json_data": repo.casesCountLatest});
    }
    if (repo.casesCountHistory != null)
      blocData
          .dispatch(CountryAction.fetch, {"json_data": repo.casesCountHistory});

    if (repo.testingDataLatest != null)
      blocTesting
          .dispatch(CountryAction.fetch, {"json_data": repo.testingDataLatest});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // print("BEING DISPOSED");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Provider<CountryOverallBloc>(
      create: (_) => bloc,
      child: Provider<CountryStatsBloc>(
        create: (_) => blocData,
        child: Provider<CountryRegionalBloc>(
          create: (_) => blocRegional,
          child: Provider<CountryTestingBloc>(
            create: (_) => blocTesting,
            child: ChangeNotifierProvider<ChartType>(
              create: (_) => chartType,
              child: SafeArea(
                  top: false,
                  minimum: EdgeInsets.only(top: 8),
                  child: Builder(
                      builder: (context) => CustomScrollView(
                            key: PageStorageKey("sad"),
                            slivers: <Widget>[
                              SliverOverlapInjector(
                                // This is the flip side of the SliverOverlapAbsorber above.
                                handle: NestedScrollView
                                    .sliverOverlapAbsorberHandleFor(context),
                              ),
                              SliverList(
                                  delegate: SliverChildListDelegate(
                                [
                                  CountryOverallData(),
                                  PastCountryDataTiles(),
                                  CountryRegionalData(),
                                  TestingDataWidget(),
                                  BlocBuilder<CountryState,
                                          List<Entity<CountryOverallModel>>>(
                                      bloc: blocData,
                                      onError: (context, error) =>
                                          DefaultErrorBuilder(
                                            error: error,
                                          ),
                                      onSuccess: (c, event) {
                                        switch (event.state) {
                                          case CountryState.loading:
                                            return ProgressBuilder(
                                              message: "Plotting graphs",
                                            );
                                            break;
                                          case CountryState.done:
                                            return Column(
                                              children: <Widget>[
                                                ChartSwitch(),
                                                confirmedChart,
                                                recoveredChart,
                                                deceasedChart,
                                              ],
                                            );
                                            break;
                                          default:
                                            return Container();
                                        }
                                      }),
                                ],
                              ))
                            ],
                          ))),
            ),
          ),
        ),
      ),
    );
  }
}
