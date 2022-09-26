import 'dart:convert';

import 'package:http/http.dart' as http;

//const _uri = 'http://52.50.31.181:8080/medibox/tablets/details';
const _uri = 'http://192.168.119.191:8081/medibox/tablets/details';
const weightThreshold = 0.50;

class Medicine {
  final String id;
  final int quantity;
  final double weight;
  final double initialWeight;
  final String name;
  final String dateOfExp;
  final String dateOfMan;
  final int daysLeft;

  const Medicine({
    required this.id,
    required this.quantity,
    required this.weight,
    required this.name,
    required this.dateOfExp,
    required this.dateOfMan,
    required this.daysLeft,
    required this.initialWeight,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
        id: json['id'],
        quantity: json['details']['quantity'],
        weight: json['details']['currentWeight'],
        name: json['details']['tabletName'],
        dateOfExp: json['details']['dateOfExpiry'],
        dateOfMan: json['details']['dateOfManufacture'],
        daysLeft: json['details']['daysLeft'],
        initialWeight: json['details']['initialWeight']);
  }

  bool isExpiring() {
    print('ARUN' + daysLeft.toString());
    if (daysLeft < 30) {
      print('Returning true');
      return true;
    } else {
      return false;
    }
  }

  bool isBelowThreshold() {
    if (weight < (initialWeight * weightThreshold)) {
      return true;
    } else {
      return false;
    }
  }

  String getMedicineID() {
    return id;
  }

  double persentageConsumed() {
    double weightConsumed = initialWeight - weight;
    return ((weightConsumed / initialWeight) * 100);
  }
}

List<Medicine> gMedicineList = [];
bool gMedListEmpty = true;

Medicine? getMedicineByID(String id) {
  for (var element in gMedicineList) {
    if (element.id == id) {
      return element;
    }
  }
  return null;
}

Future<void> getAllMedicines() async {
  print('Querying for medicine list');
  gMedicineList.clear();
  final response = await http.get(Uri.parse(_uri));
  // print(jsonDecode(response.body));
  List<dynamic> responseList = jsonDecode(response.body);

  responseList.forEach((element) {
    gMedicineList.add(Medicine.fromJson(element));
    if (gMedListEmpty == true) {
      gMedListEmpty = false;
    }
  });
}

Future<void> deleteMedicine(Medicine medicine) async {
  var deleteUri = '$_uri/${medicine.id}';
  print(gMedicineList);
  await http.delete(Uri.parse(_uri), body: {'id': medicine.id});
  // gMedicineList.remove(medicine);
  if (gMedicineList.isEmpty) {
    gMedListEmpty = true;
  }
  print(gMedicineList);
}
