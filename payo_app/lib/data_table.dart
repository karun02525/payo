import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payo_app/model/DataModel.dart';

class DataListDraw extends StatelessWidget {
  List<FinalDataModel> finalList = [];
  DataListDraw(List<FinalDataModel> finalList) {
    this.finalList = finalList;

    finalList.forEach((element) {
      print('____________________________________');
      print(' '+element.srno.toString());
      print(' '+element.date.toString());
      print(' '+element.credit.toString());
      print(' '+element.debit.toString());
      print(' '+element.total.toString());
    });
  }



  @override
  Widget build(BuildContext context) {
    return Expanded(child:Container(
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FittedBox(
              child: DataTable(
            columns: colsHeader,
            rows: finalList
                .map(
                  (user) => DataRow(cells: [
                    DataCell(Text(user.srno.toString())),
                    DataCell(Text(user.date.toString())),
                    DataCell(Text(user.credit.toString())),
                    DataCell(Text(user.debit.toString())),
                    DataCell(Text(user.total.toString())),
                  ]),
                )
                .toList(),
          ))),
    ));
  }

  final colsHeader = [
    DataColumn(label: textWidget('SrNo')),
    DataColumn(label: textWidget('Date')),
    DataColumn(label: textWidget('Credit')),
    DataColumn(label: textWidget('Debit')),
    DataColumn(label: textWidget('Total')),
  ];

  final rowCell = [
    DataRow(cells: [
      DataCell(Text('1')),
      DataCell(Text('12-02-1293')),
      DataCell(Text('3233.32')),
      DataCell(Text('113.20')),
      DataCell(Text('42200.30')),
    ])
  ];

  static textWidget(String s) {
    return Text(
      s,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    );
  }
}

class Header {}
