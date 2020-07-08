import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class DailyBases extends StatefulWidget {
  final Widget child;

  DailyBases({Key key, this.child}) : super(key: key);

  _DailyBasesState createState() => _DailyBasesState();
}

class _DailyBasesState extends State<DailyBases> {
  List<charts.Series<Pollution, String>> _seriesData;

  _generateData() {

    var data2 = [
      new Pollution(1985, 'Credit', 100),
      new Pollution(1980, 'Debit', 150),

    ];
    var data3 = [
      new Pollution(1985, 'Credit', 200),
      new Pollution(1980, 'Debit', 100),
    ];


    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2018',
        data: data2,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff109618)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2019',
        data: data3,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xffff9900)),
      ),
    );

  }

  @override
  void initState() {
    super.initState();
    _seriesData = List<charts.Series<Pollution, String>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      margin: EdgeInsets.only(bottom: 70),
      child:  charts.BarChart(
                              _seriesData,
                              animate: true,
                              barGroupingType: charts.BarGroupingType.grouped,
                              //behaviors: [new charts.SeriesLegend()],
                              animationDuration: Duration(seconds: 2),
                ),
      ),
    );
  }
}

class Pollution {
  String place;
  int year;
  int quantity;

  Pollution(this.year, this.place, this.quantity);
}