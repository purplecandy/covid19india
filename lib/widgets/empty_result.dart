import 'package:flutter/material.dart';

class EmptyResultBuilder extends StatelessWidget {
  final String message;
  const EmptyResultBuilder({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 150,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              size: 21,
            ),
            Text(message)
          ],
        ),
      ),
    );
  }
}
