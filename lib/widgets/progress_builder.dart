import 'package:flutter/material.dart';

class ProgressBuilder extends StatelessWidget {
  final String message;
  const ProgressBuilder({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: 3,
                width: 90,
                child: LinearProgressIndicator(
                    // strokeWidth: 5,
                    )),
            SizedBox(
              height: 10,
            ),
            Text(
              message,
              style: TextStyle(fontWeight: FontWeight.w100),
            )
          ],
        ),
      ),
    );
  }
}
