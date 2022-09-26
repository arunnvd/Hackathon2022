import 'package:flutter/material.dart';
import 'package:medialliswell/services/database_service.dart';
import 'package:medialliswell/services/date_formater.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool waitingforinit = true;
  List<Medicine> medicineList = [];
  late EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(
        controlFinishLoad: true, controlFinishRefresh: true);
    initDB();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initDB() async {
    await getAllMedicines();
    setState(() {
      waitingforinit = false;
      print('Load complete');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 175, 98, 1),
      body: EasyRefresh(
          controller: _controller,
          header: const ClassicHeader(),
          footer: const ClassicFooter(),
          onRefresh: () async {
            print('started loading');
            setState(() {
              waitingforinit = true;
            });
            await getAllMedicines();
            if (!mounted) {
              return;
            }
            setState(() {
              waitingforinit = false;
            });
            _controller.finishRefresh();
            _controller.resetFooter();
          },
          child: homepageBody()),
    );
  }

  Stack homepageBody() {
    return Stack(
      children: [
        buildCoverImage(),
        waitingforinit
            ? Center(
                child: LoadingAnimationWidget.discreteCircle(
                    secondRingColor: Colors.red,
                    thirdRingColor: Colors.blue,
                    color: Colors.white,
                    size: 50),
              )
            : (gMedicineList.isEmpty
                ? Container(
                    child: Center(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                                (route) => false);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No Data Available",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 140,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 5,
                                        color: Colors.grey,
                                      ),
                                    ]),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.autorenew,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Try Again',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                  )
                : SingleChildScrollView(
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
                            children: getMedicineList(),
                          ),
                        )
                      ],
                    ),
                  ))
      ],
    );
  }
}

Widget buildCoverImage() {
  return Container(
    color: Colors.grey,
    child: Image.asset('assets/images/bg.jpg'),
  );
}

List<Widget> getMedicineList() {
  List<Widget> listings = [];

  gMedicineList.forEach((element) {
    String name = element.name;
    String dateOfExp = getFormatedDateString(element.dateOfExp);
    String dateOfMan = element.dateOfMan;
    int daysLeft = element.daysLeft;
    String id = element.id;

    bool expiring = element.isExpiring();
    bool belowThreshold = element.isBelowThreshold();

    IconData warningIcon;

    if (expiring || belowThreshold)
      warningIcon = Icons.warning;
    else
      warningIcon = Icons.check_circle;

    listings.add(ItemTile(
        dateOfExp: dateOfExp,
        dateOfMan: dateOfMan,
        name: name,
        daysLeft: daysLeft,
        expiring: expiring,
        belowThreshold: belowThreshold,
        warningIcon: warningIcon,
        id: id));
  });

  return listings;
}

class ItemTile extends StatelessWidget {
  final String name;
  final String id;
  final String dateOfExp;
  final String dateOfMan;
  final int daysLeft;
  final bool expiring;
  final bool belowThreshold;
  final IconData warningIcon;
  const ItemTile({
    Key? key,
    required this.name,
    required this.dateOfExp,
    required this.dateOfMan,
    required this.daysLeft,
    required this.expiring,
    required this.belowThreshold,
    required this.warningIcon,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GestureDetector(
        onTap: () => showMaterialModalBottomSheet(
            context: context,
            builder: (context) =>
                medicineDetailsPopup(getMedicineByID(id), context)),
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
                BoxShadow(
                    color: Colors.grey, blurRadius: 6, offset: Offset(0, 0))
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Exp Date : $dateOfExp",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  Text(
                    '($daysLeft Days Left)',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
              /* Column(
                children: [
                  const Text(
                    "Next Dose",
                    style: TextStyle(
                        color: Color.fromARGB(255, 177, 2, 17), fontSize: 11),
                  ),
                  Text(
                    nxt_date,
                    style: TextStyle(color: Colors.green.shade900, fontSize: 12),
                  ),
                  Text(
                    start_date,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "After Food",
                    style: TextStyle(color: Colors.green.shade900, fontSize: 12),
                  ),
                ],
              ), */
              Column(
                children: [
                  Icon(
                    warningIcon,
                    color: (expiring || belowThreshold)
                        ? Colors.red
                        : Colors.green,
                  ),
                  Text(expiring
                      ? 'Expiring soon'
                      : (belowThreshold ? 'Out off stock' : 'All good'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container medicineDetailsPopup(Medicine? medicineData, BuildContext context) {
    if (medicineData != null) {
      String expDate = getFormatedDateString(medicineData.dateOfExp);
      String manDate = getFormatedDateString(medicineData.dateOfMan);
      String qty = medicineData.quantity.toString();
      String currentWeight = medicineData.weight.toString();
      String initialWeight = medicineData.initialWeight.toString();
      String consumedPercentage = medicineData.persentageConsumed().toString();
      return Container(
        height: 200,
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            medicineData.name,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const Divider(
            color: Colors.grey,
            endIndent: 50,
            indent: 50,
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MFD : $manDate",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  Text(
                    "EXP : $expDate",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  Text(
                    "QTY : $qty",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Initial Weight : $initialWeight",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  Text(
                    "Current Weight : $currentWeight",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  Text(
                    "Consumed : $consumedPercentage%",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            child: GestureDetector(
              onTap: () {
                //back to previous page
                //deleteMedicine(medicineData);
                showAlertDialog(context, medicineData);
                //Navigator.of(context).pop(true);
              },
              child: Container(
                width: 140,
                height: 40,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 150, 30, 1),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.grey,
                      ),
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                      size: 25,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Remove',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
      );
    } else {
      return Container();
    }
  }
}

showAlertDialog(BuildContext context, Medicine medcineData) {
  // set up the buttons
  Widget cancelButton = GestureDetector(
    onTap: () {
      Navigator.of(context).pop(true);
    },
    child: Text(
      'Cancel',
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey),
    ),
  );
  Widget continueButton = GestureDetector(
    onTap: () {
      deleteMedicine(medcineData).then((value) => {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false)
          });
    },
    child: Text(
      'Confirm',
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue),
    ),
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Remove Tablet?"),
    content:
        Text("Please ensure to remove the tablet from Smart Medicine Cabinet."),
    actions: [
      cancelButton,
      SizedBox(
        width: 5,
      ),
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
