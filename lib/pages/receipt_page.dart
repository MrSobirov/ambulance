import 'dart:math';

import 'package:flutter/material.dart';

import '../services/cache_values.dart';
import '../services/db_repository.dart';

class ReceiptPage extends StatefulWidget {
  final Map<String, dynamic> callForm;
  const ReceiptPage(this.callForm, {Key? key}) : super(key: key);

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  String? sickness = CachedModels.sicknesses[0]["name"];
  TextEditingController pillsController = TextEditingController();
  TextEditingController injectionController = TextEditingController();
  TextEditingController therapiesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Write prescription to patient"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    width: 350,
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
                        value: sickness,
                        items: CachedModels.sicknesses.map((e) => DropdownMenuItem<String>(
                          value: e["name"],
                          child: Text(e["name"]),
                        )).toList(),
                        onChanged: (String? val) {
                          if(val != null) {
                            setState(() {
                              sickness = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        int sicknessID = CachedModels.sicknesses.firstWhere((element) => element["name"] == sickness)["sickness_id"];
                        Map<String, dynamic> receipt = {
                          "receipt_id": Random().nextInt(100),
                          "pills": pillsController.text,
                          "injections": injectionController.text,
                          "therapies": therapiesController.text,
                          "patient_id": widget.callForm["patient_id"],
                          "medical_id": widget.callForm["medical_id"],
                          "sickness_id": sicknessID,
                          "doctor_id": widget.callForm["doctor_id"],
                        };
                        bool created = await DBRepo().createReceipt(receipt);
                        if(created) Navigator.pop(context);
                      },
                      child: const Text(
                          "Assign prescription"
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 50,
                width: 350,
                padding: const EdgeInsets.only(left: 15),
                margin: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12)
                ),
                child: TextFormField(
                  controller: pillsController,
                  decoration: const InputDecoration(
                    label: Text("Pills"),
                    border: InputBorder.none
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 350,
                padding: const EdgeInsets.only(left: 15),
                margin: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12)
                ),
                child: TextFormField(
                  controller: injectionController,
                  decoration: const InputDecoration(
                      label: Text("Injections"),
                      border: InputBorder.none
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 350,
                padding: const EdgeInsets.only(left: 15),
                margin: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12)
                ),
                child: TextFormField(
                  controller: therapiesController,
                  decoration: const InputDecoration(
                      label: Text("Therapies"),
                      border: InputBorder.none
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
