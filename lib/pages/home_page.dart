import 'package:ambulance/services/cache_values.dart';
import 'package:ambulance/services/db_repository.dart';
import 'package:ambulance/services/db_service.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ambulance app"),
      ),
      body: loading ? const Center(
        child: SingleChildScrollView(),
      ) :Column(
        children: CachedModels.callForms.map((item) => Row(
          children: [
            Text("${item["doctor_id"]}")
          ],
        )).toList(),
      ),
    );
  }
}
