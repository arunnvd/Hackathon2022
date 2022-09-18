import 'package:firebase_database/firebase_database.dart';

final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

class MediCabinet {
  static final MediCabinet _mediCabinet = MediCabinet._init();

  MediCabinet._init() {}
  Future<void> test_data() async {
    final snapshot = await _databaseRef.child('dolo_550').get();
    if (snapshot.exists) {
      print(snapshot.value);
    } else {
      print('No data available.');
    }
  }

  static MediCabinet get userMediCabinetObj {
    return _mediCabinet;
  }
}
