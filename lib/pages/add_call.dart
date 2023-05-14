import 'dart:math';

import 'package:ambulance/services/cache_values.dart';
import 'package:ambulance/services/db_repository.dart';
import 'package:flutter/material.dart';

class AddCallPage extends StatefulWidget {
  const AddCallPage({Key? key}) : super(key: key);

  @override
  State<AddCallPage> createState() => _AddCallPageState();
}

class _AddCallPageState extends State<AddCallPage> {
  String? patient = CachedModels.patients[0]["name"];
  String? doctor = CachedModels.doctors[0]["name"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add call form"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 280,
                  padding: const EdgeInsets.only(left: 15),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: doctor,
                      items: CachedModels.doctors.map((e) => DropdownMenuItem<String>(
                        value: e["name"],
                        child: Text(e["name"]),
                      )).toList(),
                      onChanged: (String? val) {
                        if(val != null) {
                          setState(() {
                            doctor = val;
                          });
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 280,
                  padding: const EdgeInsets.only(left: 15),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: patient,
                      items: CachedModels.patients.map((e) => DropdownMenuItem<String>(
                        value: e["name"],
                        child: Text(e["name"]),
                      )).toList(),
                      onChanged: (String? val) {
                        if(val != null) {
                          setState(() {
                            patient = val;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  int patientID = CachedModels.patients.firstWhere((element) => element["name"] == patient)["patient_id"];
                  int doctorID = CachedModels.doctors.firstWhere((element) => element["name"] == doctor)["doctor_id"];
                  Map<String, dynamic> callForm = {
                    "call_id": Random().nextInt(100),
                    "doctor_id": doctorID,
                    "patient_id": patientID,
                    //"created_at": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                    "created_at": DateTime.now().millisecondsSinceEpoch,
                    "road_id": DBRepo().getBestRoute(),
                    "medical_id": CachedModels.medialHistories.firstWhere((element) => element["patient_id"] == patientID)["medical_id"]
                  };
                  bool created = await DBRepo().createCallForm(callForm);
                  if(created) Navigator.pop(context);
                },
                child: const Text(
                    "Create"
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
