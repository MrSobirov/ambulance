import 'dart:math';

import 'package:flutter/material.dart';

import '../services/cache_values.dart';
import '../services/db_repository.dart';
class CreateHospital extends StatefulWidget {
  const CreateHospital({Key? key}) : super(key: key);

  @override
  State<CreateHospital> createState() => _CreateHospitalState();
}

class _CreateHospitalState extends State<CreateHospital> {
  @override
  Widget build(BuildContext context) {
    String? regions = CachedModels.regions[1]["name"];
    String? doctor = CachedModels.doctors[1]["name"];
    String? nurse = CachedModels.nurses[1]["name"];
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Doctor name",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      height: 50,
                      width: 170,
                      padding: const EdgeInsets.only(left: 15),
                      margin: const EdgeInsets.symmetric(vertical: 15),
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
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nurse Name",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      height: 50,
                      width: 170,
                      padding: const EdgeInsets.only(left: 15),
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: nurse,
                          items: CachedModels.nurses.map((e) => DropdownMenuItem<String>(
                            value: e["name"],
                            child: Text(e["name"]),
                          )).toList(),
                          onChanged: (String? val) {
                            if(val != null) {
                              setState(() {
                                nurse = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Region name",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      height: 50,
                      width: 170,
                      padding: const EdgeInsets.only(left: 15),
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: regions,
                          items: CachedModels.regions.map((e) => DropdownMenuItem<String>(
                            value: e["name"],
                            child: Text(e["name"]),
                          )).toList(),
                          onChanged: (String? val) {
                            if(val != null) {
                              setState(() {
                                regions = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  int regionID = CachedModels.regions.firstWhere((element) => element["name"] == regions)["region_id"];
                  int doctorID = CachedModels.doctors.firstWhere((element) => element["name"] == doctor)["doctor_id"];
                  int nurseID = CachedModels.nurses.firstWhere((element) => element["name"] == nurse)["nurse_id"];
                  Map<String, dynamic> hospital = {
                    "hospital_id": Random().nextInt(100), //random(1, 100)
                    "name": "string", //input
                    "region_id": regionID, //drop down
                    "location": "string", //input
                    "opened_at": DateTime.now().toString(),
                    "nurse_id": nurseID, //drop down
                    "doctor_id": doctorID, //drop down
                  };
                  bool created = await DBRepo().createHospital(hospital);
                  if(created) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
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
