import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payo_app/model/DataModel.dart';
import 'package:sms_maintained/sms.dart';

import 'daily_bargroup.dart';
import 'data_table.dart';
import 'global.dart';

class HomeOnlyPiePage extends StatefulWidget {
  final Widget child;

  HomeOnlyPiePage({Key key, this.child}) : super(key: key);

  _HomeOnlyPiePageState createState() => _HomeOnlyPiePageState();
}

class _HomeOnlyPiePageState extends State<HomeOnlyPiePage> {
  bool isLoad = true;
  int isStatus = 0;

  List<FinalDataModel> _finalList = [];
  List<DataModel> data = [];
  List<charts.Series<Task, String>> _seriesPieData;

  void dataCalculation([int status = 0]) async {
    data.clear();
    SmsQuery query = new SmsQuery();
    List<SmsMessage> messages = await query.getAllSms;

    messages.forEach((element) {
      var str = element.body;
      if (str.contains('credited ')) {
        data.add(DataModel(
            id: element.id,
            credited: Global.getIndianRupee(str),
            dateTime: element.date));
      } else if (str.contains('debited ')) {
        data.add(DataModel(
            id: element.id,
            debited: Global.getIndianRupee(str),
            dateTime: element.date));
      }
    });

    List<DataModel> short = [];

    if (status == 0) {
      short = data.where((l) => l.dateTime.day >= DateTime.now().day).toList();
    } else if (status == 3) {
      short = data.where((l) => l.dateTime.day <= DateTime.now().day).toList();
    } else {
      short = data.where((l) => l.dateTime.day <= DateTime.now().day).toList();
    }

    short.forEach((element) {
      print(
          '${element.id} =>  ${element.credited}  =>  ${element.debited}  => ${element.dateTime} ');
    });

    var totalCredit =
        short.fold(0.0, (previous, current) => previous + current.credited);
    var totalDebit =
        short.fold(0.0, (previous, current) => previous + current.debited);

    print("totalCredit : $totalCredit");
    print("totalDebit: $totalDebit");

    var sum = totalCredit + totalDebit;

    short.forEach((element) {
      _finalList.add(FinalDataModel(element.id,
          '${element.dateTime.day}-${element.dateTime.month}-${element.dateTime.year}',
          totalCredit.toString(), totalDebit.toString(), sum.toString()));
    });

    setState(() {
      isLoad = false;
      isStatus = status;
      _seriesPieData = List<charts.Series<Task, String>>();
      _generateData(totalCredit, totalDebit);
    });
  }

  void _todayHanler() {
    dataCalculation(0);
  }

  void _dialyHanler() {
    dataCalculation(1);
  }

  void _monthly() {
    dataCalculation(2);
  }

  void _summaryList() {
    dataCalculation(3);
  }

  _generateData(totalCredit, totalDebit) {
    var totalRs = totalCredit + totalDebit;
    var cr = totalCredit * 100 / totalRs;
    var dr = totalDebit * 100 / totalRs;
    var piedata = [
      Task('Total income Rs. $totalCredit',
          double.tryParse(cr.toStringAsExponential(3)), Color(0xff109618)),
      Task('Total expenses Rs. $totalDebit',
          double.tryParse(dr.toStringAsExponential(3)), Color(0xffdc3912)),
      Task('Total Rs .$totalRs', 0.0, Color(0xfffdbe19)),
    ];

    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'income',
        data: piedata,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}%',
      ),
    );
  }

  @override
  void initState() {
    dataCalculation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1976d2),
          //backgroundColor: Color(0xff308e1c),
          title: Text('Payo'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: dataCalculation,
          child: Icon(Icons.refresh),
        ),
        body: isLoad
            ? Container(
                child: Center(
                  child: Text('Please wait...'),
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: _todayHanler,
                        child: Text('Today'),
                      ),
                      RaisedButton(
                        onPressed: _dialyHanler,
                        child: Text('Daily'),
                      ),
                      RaisedButton(
                        onPressed: _monthly,
                        child: Text('Monthly'),
                      ),
                      RaisedButton(
                        onPressed: _summaryList,
                        child: Text('Summary'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  isStatus == 0
                      ? pieDraw()
                      : isStatus == 1
                          ? DailyBases()
                          : isStatus == 2
                              ? pieDraw()
                              : isStatus == 3
                                  ? DataListDraw(_finalList)
                                  : pieDraw()
                ],
              ),
      ),
    );
  }

  Widget pieDraw() {
    return Expanded(
      child: charts.PieChart(
        _seriesPieData,
        animate: true,
        animationDuration: Duration(seconds: 2),
        defaultRenderer:
            charts.ArcRendererConfig(arcWidth: 100, arcRendererDecorators: [
          charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.auto)
        ]),
        behaviors: [
          new charts.DatumLegend(
            outsideJustification: charts.OutsideJustification.start,
            horizontalFirst: false,
            desiredMaxRows: 12,
            cellPadding: new EdgeInsets.only(left: 44.0, top: 14.0),
            entryTextStyle: charts.TextStyleSpec(
                color: charts.MaterialPalette.purple.shadeDefault,
                fontFamily: 'Georgia',
                fontSize: 16),
          )
        ],
      ),
    );
  }
}

class Task {
  String task;
  double taskvalue;
  Color colorval;
  Task(this.task, this.taskvalue, this.colorval);
}

class DataModel {
  int id;
  double credited;
  double debited;
  DateTime dateTime;
  DataModel({
    this.id,
    this.credited = 00.00,
    this.debited = 00.00,
    this.dateTime,
  });
}
