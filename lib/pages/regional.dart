import 'package:covid19india/bloc_base.dart';
import 'package:covid19india/blocs/regional_bloc.dart';
import 'package:covid19india/models/entity.dart';
import 'package:covid19india/models/regionalstats_model.dart';
import 'package:covid19india/repository.dart';
import 'package:covid19india/widgets/overall_data.dart';
import 'package:covid19india/widgets/progress_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid19india/preferences.dart';
import 'package:covid19india/widgets/header_tile.dart';
import 'package:covid19india/widgets/district_data.dart';
import 'package:covid19india/widgets/hospital_data.dart';
import 'package:covid19india/widgets/charts/charts.dart';

class RegionalPage extends StatefulWidget {
  RegionalPage({Key key}) : super(key: key);

  @override
  _RegionalPageState createState() => _RegionalPageState();
}

class _RegionalPageState extends State<RegionalPage>
    with AutomaticKeepAliveClientMixin {
  final bloc = RegionalStatsBloc();
  final blocData = RegionalStatsData();
  final blocDistrict = RegionalDistrictBloc();
  final blocHospital = RegionalHospitalsData();
  final chartType = ChartType();

  int activeIndex = 0;

  final deceasedChart = ChartContainer(
    title: "Total Deceased",
    child: ChartSwitcher(
      cummulative: ChartCummulative(
        backgroundColor: Colors.grey.shade100,
        barColor: charts.MaterialPalette.gray.shadeDefault,
        title: "Deaths",
        toolTipColor: Colors.grey,
        type: "deaths",
      ),
      daily: ChartDaily(
        backgroundColor: Colors.grey.shade100,
        barColor: charts.MaterialPalette.gray.shadeDefault,
        title: "Deaths",
        toolTipColor: Colors.grey,
        type: "deaths",
      ),
    ),
  );

  final confirmedChat = ChartContainer(
    title: "Total Confirmed",
    child: ChartSwitcher(
      cummulative: ChartCummulative(
        backgroundColor: Colors.red.shade100,
        barColor: charts.MaterialPalette.red.shadeDefault,
        title: "Confirmed",
        toolTipColor: Colors.red,
        type: "confirmed",
      ),
      daily: ChartDaily(
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
      cummulative: ChartCummulative(
        backgroundColor: Colors.green.shade100,
        barColor: charts.MaterialPalette.green.shadeDefault,
        title: "Recovered",
        toolTipColor: Colors.green,
        type: "recovered",
      ),
      daily: ChartDaily(
        backgroundColor: Colors.green.shade100,
        barColor: charts.MaterialPalette.green.shadeDefault,
        title: "Recovered",
        toolTipColor: Colors.green,
        type: "recovered",
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
    if (repo.casesCountLatest.isNotEmpty) {
      if (pref.initialized && pref.defaultStateName.isNotEmpty) {
        startup(repo, pref.defaultStateName);
      }
    }
    super.didChangeDependencies();
  }

  void startup(Repository repo, String stateName) {
    bloc.dispatch(RegionalAction.fetch,
        {"state_name": stateName, "json_data": repo.casesCountLatest});
    blocData.dispatch(RegionalAction.fetch,
        {"state_name": stateName, "json_data": repo.casesCountHistory});
    blocDistrict.dispatch(RegionalAction.fetch,
        {"state_name": stateName, "json_data": repo.districtData});
    blocHospital.dispatch(RegionalAction.fetch,
        {"state_name": stateName, "json_data": repo.hospitalBeds});
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
    return Provider<RegionalStatsBloc>(
      create: (_) => bloc,
      child: Provider<RegionalStatsData>(
          create: (_) => blocData,
          child: Provider<RegionalDistrictBloc>(
            create: (_) => blocDistrict,
            child: Provider<RegionalHospitalsData>(
              create: (_) => blocHospital,
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
                                    RegionalOverallData(),
                                    PastRegionalDataTiles(),
                                    DistrictData(),
                                    HospitalData(),
                                    BlocBuilder<RegionalState,
                                            List<Entity<RegionalStatsModel>>>(
                                        bloc: blocData,
                                        onSuccess: (c, event) {
                                          switch (event.state) {
                                            case RegionalState.loading:
                                              return ProgressBuilder(
                                                message: "Plotting graphs",
                                              );
                                              break;
                                            case RegionalState.done:
                                              return Column(
                                                children: <Widget>[
                                                  ChartSwitch(),
                                                  confirmedChat,
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
          )),
    );
  }
}

class ChartSwitch extends StatelessWidget {
  const ChartSwitch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartType>(
      builder: (c, chartType, _) => SizedBox(
        // height: MediaQuery.of(context),
        width: MediaQuery.of(context).size.width * 0.8,
        child: CupertinoSegmentedControl<int>(
            children: {0: Text("Cummulative"), 1: Text("Daily")},
            groupValue: chartType.type,
            onValueChanged: (v) {
              chartType.update(v);
            }),
      ),
    );
  }
}
