import 'package:flutter/material.dart';

class DefaultErrorBuilder extends StatelessWidget {
  final error;
  const DefaultErrorBuilder({Key key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.sentiment_dissatisfied),
          Text(error.message)
        ],
      ),
    );
  }
}
