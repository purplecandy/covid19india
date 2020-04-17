import 'package:flutter/material.dart';
import 'package:covid19india/preferences.dart';

class StatePicker extends StatefulWidget {
  final Preferences pref;
  final bool isDialog;
  StatePicker({Key key, this.pref, this.isDialog = true}) : super(key: key);

  @override
  _StatePickerState createState() => _StatePickerState();
}

class _StatePickerState extends State<StatePicker> {
  Preferences get pref => widget.pref;
  bool get isDialog => widget.isDialog;
  Map<String, String> states = {
    "AN": "Andaman and Nicobar Islands",
    "AP": "Andhra Pradesh",
    "AR": "Arunachal Pradesh",
    "AS": "Assam",
    "BR": "Bihar",
    "CG": "Chandigarh",
    "CH": "Chhattisgarh",
    "DN": "Dadra and Nagar Haveli",
    "DD": "Daman and Diu",
    "DL": "Delhi",
    "GA": "Goa",
    "GJ": "Gujarat",
    "HR": "Haryana",
    "HP": "Himachal Pradesh",
    "JK": "Jammu and Kashmir",
    "JH": "Jharkhand",
    "KA": "Karnataka",
    "KL": "Kerala",
    "LA": "Ladakh",
    "LD": "Lakshadweep",
    "MP": "Madhya Pradesh",
    "MH": "Maharashtra",
    "MN": "Manipur",
    "ML": "Meghalaya",
    "MZ": "Mizoram",
    "NL": "Nagaland",
    "OR": "Odisha",
    "PY": "Puducherry",
    "PB": "Punjab",
    "RJ": "Rajasthan",
    "SK": "Sikkim",
    "TN": "Tamil Nadu",
    "TS": "Telangana",
    "TR": "Tripura",
    "UP": "Uttar Pradesh",
    "UK": "Uttarakhand",
    "WB": "West Bengal"
  };

  String selectedState = "";
  List<String> nameOfStates;

  @override
  void initState() {
    nameOfStates = states.values.toList();
    selectedState = pref.defaultStateName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: isDialog ? 15 : 0,
      contentPadding: EdgeInsets.all(4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      title: Text(
        "Choose your state",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Container(
        height: isDialog
            ? MediaQuery.of(context).size.height * 0.4
            : MediaQuery.of(context).size.height,
        width: isDialog
            ? MediaQuery.of(context).size.width * 0.8
            : MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 8),
              child: Text(
                selectedState.isEmpty
                    ? "You need to select your state"
                    : "Selected: " + selectedState,
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).accentColor),
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: states.length,
                itemBuilder: (context, index) => RadioListTile(
                    title: Text(nameOfStates[index]),
                    value: nameOfStates[index],
                    groupValue: selectedState,
                    onChanged: (val) {
                      setState(() {
                        selectedState = val;
                      });
                    }),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              if (selectedState != pref.defaultStateName)
                pref.setDefault(selectedState);
              if (selectedState.isNotEmpty) Navigator.pop(context);
            },
            child: Text("Done")),
      ],
    );
  }
}
