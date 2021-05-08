import 'package:expenses/components/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:expenses/models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  //Gerenate a list of recent transaction
  //Gerando uma lista de transação
  final List<Transaction> recentTransaction;

  //Creating constructor
  //Criando o construtor.
  Chart(this.recentTransaction);

  //Creating a list map for the days of week.
  //Estamos criando uma lista de dias da semana que vai fazer a validação.
  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      //Creating a variable to make a subtract from the DATANOW.
      final weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        bool sameDay = recentTransaction[i].date.day == weekDay.day;
        bool sameMonth = recentTransaction[i].date.month == weekDay.month;
        bool sameYear = recentTransaction[i].date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransaction[i].value;
        }
      }

      return {
        'day':
            DateFormat.E().format(weekDay)[0], //DateWhere da sigla da semana.
        'value': totalSum,
      };
    }).reversed.toList();
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + tr['value'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((tr) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: tr['day'],
                value: tr['value'],
                percentage: _weekTotalValue == 0
                    ? 0
                    : (tr['value'] as double) / _weekTotalValue,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
