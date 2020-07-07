import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sms_maintained/sms.dart';

class HomeOnlyPiePage extends StatefulWidget {
  final Widget child;

  HomeOnlyPiePage({Key key, this.child}) : super(key: key);

  _HomeOnlyPiePageState createState() => _HomeOnlyPiePageState();
}

class _HomeOnlyPiePageState extends State<HomeOnlyPiePage> {
  bool isLoad = true;

  List<DataModel> data = [];
  List<charts.Series<Task, String>> _seriesPieData;

  void _incrementCounter([bool today=false]) async {
    data.clear();
    SmsQuery query = new SmsQuery();
    List<SmsMessage> messages = await query.getAllSms;

    messages.forEach((element) {
      var str = element.body;
      if (str.contains('credited ')) {
        data.add(DataModel(
            id: element.id,
            credited: getIndianRupee(str),
            dateTime: element.date));
      } else if (str.contains('debited ')) {
        data.add(DataModel(
            id: element.id,
            debited: getIndianRupee(str),
            dateTime: element.date));
      }
    });

    List<DataModel> short = [];

    if(today){
      short = data.where((l) => l.dateTime.day >= DateTime.now().day).toList();
    }else{
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

    setState(() {
      isLoad = false;
      _seriesPieData = List<charts.Series<Task, String>>();
      _generateData(totalCredit, totalDebit);
    });
  }

  void _dialyHanler() {
    _incrementCounter(true);
  }

  void _monthly() {
    _incrementCounter(false);
  }

  _generateData(totalCredit, totalDebit) {
    var totalRs=totalCredit+totalDebit;
    var cr=totalCredit*100/totalRs;
    var dr=totalDebit*100/totalRs;
    var piedata = [
       Task('Total income Rs. $totalCredit', double.tryParse(cr.toStringAsExponential(3)), Color(0xff109618)),
       Task('Total expenses Rs. $totalDebit', double.tryParse(dr.toStringAsExponential(3)), Color(0xffdc3912)),
       Task('Total Rs .$totalRs',0.0, Color(0xfffdbe19)),
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
    _incrementCounter();
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
          onPressed: _incrementCounter,
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
                  SizedBox(height: 20.0,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: 140,
                          child: RaisedButton(
                            onPressed: _dialyHanler,
                            child: Text('Daily'),
                          )),
                      SizedBox(
                          width: 140,
                          child: RaisedButton(
                            onPressed: _monthly,
                            child: Text('Monthly'),
                          ))
                    ],
                  ),

                  SizedBox(height: 10.0,),
                  Expanded(
                    child: charts.PieChart(
                      _seriesPieData,
                      animate: true,
                      animationDuration: Duration(seconds: 2),
                      defaultRenderer: charts.ArcRendererConfig(
                          arcWidth: 100,
                          arcRendererDecorators: [
                            charts.ArcLabelDecorator(
                                labelPosition: charts.ArcLabelPosition.auto)
                          ]),
                      behaviors: [
                        new charts.DatumLegend(
                          outsideJustification:
                              charts.OutsideJustification.start,
                          horizontalFirst: false,
                          desiredMaxRows: 12,
                          cellPadding:
                              new EdgeInsets.only(left: 44.0, top: 14.0),
                          entryTextStyle: charts.TextStyleSpec(
                              color: charts.MaterialPalette.purple.shadeDefault,
                              fontFamily: 'Georgia',
                              fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  getIndianRupee(value) {
    final regexp = RegExp("[Rs|IN][Rs\\s|IN.](\\d+[.](\\d\\d|\\d))");
    final match = regexp.firstMatch(value);
    return double.tryParse(match.group(1));
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
