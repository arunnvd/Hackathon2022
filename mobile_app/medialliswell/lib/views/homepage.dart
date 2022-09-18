import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool waitingforinit = true;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() => {initDB()});
  }

  void initDB() {
    sleep(const Duration(seconds: 3));
    setState(() {
      waitingforinit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 175, 98, 1),
        body: Stack(
          children: [
            buildCoverImage(),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 200,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(1, 255, 175, 98),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: getInvestmentsList(),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}

Widget buildCoverImage() {
  return Container(
    color: Colors.grey,
    child: Image.asset('assets/images/bg.jpg'),
  );
}

List<Widget> getInvestmentsList(
    [String filter = "branch_id", int filterValue = -1]) {
  List<Widget> listings = [];

  List<dynamic> dataList = [1, 2, 3, 4, 6, 7, 7, 6, 5];

  dataList.forEach((element) {
    String branchName = "Dollo 650";
    List<String> exp_date = ["24-12-23"];
    List<String> start_date = ["timestampToStringList"];
    int depAmount = 1000;
    double interest = 1000.5;
    int matAmount = 10005;

    listings.add(ItemTile(
        branch: branchName,
        exp_date: exp_date,
        start_date: start_date,
        dep_amount: depAmount,
        interst: interest,
        mat_amount: matAmount));
  });

  return listings;
}

class ItemTile extends StatelessWidget {
  final String branch;
  final List<String> exp_date, start_date;
  final int dep_amount, mat_amount;
  final double interst;
  const ItemTile(
      {Key? key,
      required this.branch,
      required this.exp_date,
      required this.start_date,
      required this.dep_amount,
      required this.interst,
      required this.mat_amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            /* gradient: LinearGradient(
              colors: [Colors.white, Colors.cyan.shade300],
              begin: Alignment.topCenter,
              end: Alignment.topRight,
            ), */
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(color: Colors.grey, blurRadius: 6, offset: Offset(0, 0))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  branch,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Expiry Date : 24 - DEC - 2023",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                /* Text(
                  "Maturity amount = $mat_amount rs",
                  style: TextStyle(color: Colors.grey.shade700),
                ), */
              ],
            ),
            Column(
              children: [
                const Text(
                  "Next Dose",
                  style: TextStyle(
                      color: Color.fromARGB(255, 177, 2, 17), fontSize: 11),
                ),
                Text(
                  "Today",
                  style: TextStyle(color: Colors.green.shade900, fontSize: 12),
                ),
                Text(
                  "12.30PM",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "After Food",
                  style: TextStyle(color: Colors.green.shade900, fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
