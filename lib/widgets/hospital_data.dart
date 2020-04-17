import 'package:flutter/material.dart';
import 'package:covid19india/blocs/regional_bloc.dart';
import 'package:provider/provider.dart';
import 'package:covid19india/bloc_base.dart';
import 'package:covid19india/models/hospital.dart';

class HospitalData extends StatelessWidget {
  final List<Color> shades = [
    Colors.pink.shade100,
    Colors.pink.shade200,
    Colors.pink.shade300,
    Colors.pink.shade400,
    Colors.pink.shade500
  ];
  HospitalData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RegionalHospitalsData>(
      builder: (c, bloc, w) => BlocBuilder<RegionalState, HospitalModel>(
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
                          "Hospitals & Beds",
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
                                  Text(event.object.totalHospitals.toString(),
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                  Text(
                                    "Hospitals",
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
                                        "Rural ${event.object.ruralH}",
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
                                        "Urban ${event.object.urbanH}",
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 45,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.deepOrange.shade100,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Center(
                                      child: Text(
                                        "Rural ${event.object.ruralB}",
                                        style: TextStyle(
                                            color: Colors.deepOrange,
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
                                        color: Colors.deepOrange.shade100,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Center(
                                      child: Text(
                                        "Urban ${event.object.urbanB}",
                                        style: TextStyle(
                                            color: Colors.deepOrange,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.brown.shade100,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(event.object.totalBeds.toString(),
                                      style: TextStyle(
                                          color: Colors.brown,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                  Text(
                                    "Beds",
                                    style: TextStyle(
                                        color: Colors.brown,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
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
