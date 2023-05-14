import 'package:ambulance/pages/add_call.dart';
import 'package:ambulance/pages/receipt_page.dart';
import 'package:ambulance/services/cache_values.dart';
import 'package:ambulance/services/db_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'creat_hospital.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  void getAllData() async {
    await DBRepo().getAllData();
    setState(() {
      loading = false;
    });
  }

  Widget drawerItem(String name, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 15),
            Text(name),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ambulance app"),
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 48, bottom: 15, left: 10),
              color: Colors.blue,
              alignment: Alignment.bottomLeft,
              child: const Text("Menu", textAlign: TextAlign.right, style: TextStyle(fontSize: 20, color: Colors.white),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                children: [
                  drawerItem("Hospitals", Icons.local_hospital, const CreateHospital()),
                  drawerItem("Doctors", Icons.medical_services, const AddCallPage()),
                  drawerItem("Nurses", Icons.medication_liquid_sharp, const AddCallPage()),
                  drawerItem("Patients", Icons.accessible, const AddCallPage()),
                  drawerItem("Sicknesses", Icons.newspaper, const AddCallPage()),
                  drawerItem("Regions", Icons.area_chart_outlined, const AddCallPage()),
                ],
              ),
            )
          ],
        ),
      ),
      body: loading ? const Center(
        child: SingleChildScrollView(),
      ) : Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "List of call forms",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Expanded(
                    flex: 1,
                    child: Text("ID", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text("Patient", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text("Doctor", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text("Road", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text("Date", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Column(
                  children: CachedModels.callForms.map((item) => GestureDetector(
                    onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => ReceiptPage(item))),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 7),
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                      color: Colors.grey.shade200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text("${item["call_id"]}"),
                          ),
                          Expanded(
                            flex: 6,
                            child: Text("${CachedModels.patients.firstWhere((element) => element["patient_id"] == item["patient_id"])["name"]}"),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text("${CachedModels.doctors.firstWhere((element) => element["doctor_id"] == item["doctor_id"])["name"]}"),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text("${CachedModels.roads.firstWhere((element) => element["road_id"] == item["road_id"])["name"]}"),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(item["created_at"].toString().substring(0, 10)),
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      floatingActionButton:  Align(
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
          onPressed: () async {
            await Navigator.push(context, CupertinoPageRoute(builder: (_) => const AddCallPage()));
            setState(() {});
          },
          child: const Text(
              "Add call"
          ),
        ),
      ),
    );

  }
}
