import 'dart:math';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:expenses/components/chart.dart';
import 'package:flutter/material.dart';
import 'package:expenses/models/transaction.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/components/transaction_form.dart';

//Criando as variaveis para mostrar no menu footer
const _kPages = <String, IconData>{
  'Adicionar': Icons.add_shopping_cart,
};

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabStyle _tabStyle = TabStyle.reactCircle;
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  //Creating a modal for add new transactions
  _opentransactionFormodal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  //Funtion to make de setStat works.
  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    //Closing Modal.
    //Fechar o modal
    Navigator.of(context).pop();
  }

  //Creating a method/function to delete the transition.
  //Criando o metodo para deletar por id.
  _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    //Making the dynamic height
    //Fazendo a altura dinamicamente para os container.
    final availableHeight = MediaQuery.of(context).size.height;

    //Landscape will apperars if the bottom was seteup as true.
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Exibir Gráfico'),
                  Switch(
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    },
                  ),
                ],
              ),
            if (_showChart || !isLandscape)
              Container(
                height: availableHeight * (isLandscape ? 0.7 : 0.25),
                child: Chart(_recentTransactions),
              ),
            if (!_showChart || !isLandscape)
              Container(
                height: availableHeight * 0.75,
                child: TransactionList(_transactions, _deleteTransaction),
              ),
          ],
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        style: _tabStyle,
        backgroundColor: Colors.purple,
        items: <TabItem>[
          for (final entry in _kPages.entries)
            TabItem(icon: entry.value, title: entry.key),
        ],
        onTap: (int i) => _opentransactionFormodal(context),
      ),
    );
  }
}
