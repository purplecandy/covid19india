import 'package:covid19india/bloc_base.dart';
import 'package:covid19india/blocs/state_bloc.dart';
import 'package:covid19india/models/regionalstats_model.dart';
import 'package:covid19india/repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegionalPage extends StatefulWidget {
  RegionalPage({Key key}) : super(key: key);

  @override
  _RegionalPageState createState() => _RegionalPageState();
}

class _RegionalPageState extends State<RegionalPage> {
  final bloc = RegionalStatsBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final repo = Provider.of<Repository>(context, listen: true);
    if (repo.casesCountLatest.isNotEmpty) startup(repo);
    super.didChangeDependencies();
  }

  void startup(Repository repo) {
    bloc.dispatch(RegionalAction.fetch,
        {"state_name": "Maharashtra", "json_data": repo.casesCountLatest});
  }

  @override
  Widget build(BuildContext context) {
    return Provider<RegionalStatsBloc>(
      create: (_) => bloc,
      child: Container(
        // height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:
            BlocBuilder<RegionalState, RegionalStatsModel, RegionalStatsBloc>(
          bloc: bloc,
          onSuccess: (context, event) {
            switch (event.state) {
              case RegionalState.done:
                // return Center(child: Text(event.object.loc));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        event.object.loc,
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Wrap(
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ColorTile(
                            title: "Confirmed",
                            content: event.object.totalConfirmed.toString(),
                            background: Colors.red.shade100,
                            textColor: Color(0xFFff073a),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
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
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ColorTile(
                            title: "Recovered",
                            content: event.object.discharged.toString(),
                            background: Colors.green.shade100,
                            textColor: Colors.green,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ColorTile(
                            title: "Deceased",
                            content: event.object.deaths.toString(),
                            background: Colors.grey.shade100,
                            textColor: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  ],
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
      ),
    );
  }
}

class ColorTile extends StatelessWidget {
  final String title, content;
  final Color background;
  final Color textColor;
  const ColorTile(
      {Key key, this.title, this.content, this.background, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      child: Card(
        color: background,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                content,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
