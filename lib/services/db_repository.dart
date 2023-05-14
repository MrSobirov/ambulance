import 'package:ambulance/services/cache_values.dart';
import 'package:ambulance/services/db_service.dart';

class DBRepo {
  Future<void> getAllData() async {
    await DBService().openAssetDatabase();
    CachedModels.patients = await DBService().getData('patient');
    CachedModels.doctors = await DBService().getData('doctor');
    CachedModels.nurses = await DBService().getData('nurse');
    CachedModels.hospitals = await DBService().getData('hospital');
    CachedModels.sicknesses = await DBService().getData('sickness');
    CachedModels.callForms = await DBService().getData('callform');
    CachedModels.medialHistories = await DBService().getData('medicalhistory');
    CachedModels.regions = await DBService().getData('regions');
    CachedModels.roads = await DBService().getData('roads');
    CachedModels.receipts = await DBService().getData('receipts');
  }

  Future<bool> createCallForm(Map<String, dynamic> callForm) async {
    callForm = {
      "call_id": 1, //random(1, 100)
      "doctor_id": 1, //drop down
      "patient_id": 1, //drop down
      "created_at": DateTime.now(),
      "road_id": getBestRoute(),
      "medical_id": 1, //medicalHistory listdan patient id orqali firstWhere qivolasan
    };
    bool created =  await DBService().writeDataToDB('callform', callForm);
    if(created) CachedModels.callForms = await DBService().getData('callform');
    return created;
  }

  Future<bool> createDoctor(Map<String, dynamic> doctor) async {
    doctor = {
      "doctor_id": 1, //random(1, 100)
      "name": "string", //input
      "hospital_id": 1, //drop down
      "experince": 10, //input
      "patient_id": 1, //drop down
    };
    bool created = await DBService().writeDataToDB('doctor', doctor);
    if(created) CachedModels.doctors = await DBService().getData('doctor');
    return created;
  }

  Future<bool> createHospital(Map<String, dynamic> hospital) async {
    hospital = {
      "hospital_id": 1, //random(1, 100)
      "name": "string", //input
      "region_id": 1, //drop down
      "location": "string", //input
      "opened_at": DateTime.now(),
      "nurse_id": 1, //drop down
      "doctor_id": 1, //drop down
    };
    bool created = await DBService().writeDataToDB('hospital', hospital);
    if(created) CachedModels.hospitals = await DBService().getData('hospital');
    return created;
  }

  Future<bool> createMedicalHistory(Map<String, dynamic> medicalHistory) async {
    medicalHistory = {
      "medical_id": 1, //random(1, 100)
      "patient_id": 1, //drop down
      "receipt_id": 1, //drop down
      "sickness_id": 1, //drop down
      "call_id": "1", //drop down
    };
    bool created = await DBService().writeDataToDB('medicalhistory', medicalHistory);
    if(created) CachedModels.medialHistories = await DBService().getData('medicalhistory');
    return created;
  }

  Future<bool> createNurse(Map<String, dynamic> nurse) async {
    nurse = {
      "nurse_id": 1, //random(1, 100)
      "name": "string", //input
      "hospital_id": 1, //drop down
      "schedule": "08:00 - 13:00", //input
      "patient_id": 1, //drop down
    };
    bool created = await DBService().writeDataToDB('nurse', nurse);
    if(created) CachedModels.nurses = await DBService().getData('nurse');
    return created;
  }

  Future<bool> createPatient(Map<String, dynamic> patient) async {
    patient = {
      "patient_id": 1, //random(1, 100)
      "name": "string", //input
      "phones": "94 659 08 50", //input
      "sickness_id": 1, //drop down
      "age": 20, //input
    };
    bool created = await DBService().writeDataToDB('patient', patient);
    if(created) CachedModels.patients = await DBService().getData('patient');
    return created;
  }

  Future<bool> createReceipt(Map<String, dynamic> receipt) async {
    receipt = {
      "receipt_id": 1, //random(1, 100)
      "pills": "List of pills", //input
      "injections": "List of injections", //input
      "therapies": "List of therapies", //input
      "patient_id": 1, //drop down
      "medical_id": 1, //firstWhere bilan call form dan ovolasan
      "sickness_id": 3, //firstWhere bilan medicalHistory dan ovolasan medical id ni tepada yozdim olishni
      "doctor_id": 2, //firstWhere bilan call form dan ovolasan
    };
    bool created = await DBService().writeDataToDB('receipts', receipt);
    if(created) CachedModels.receipts = await DBService().getData('receipts');
    return created;
  }

  Future<bool> createRegion(Map<String, dynamic> region) async {
    region = {
      "region_id": 1, //random(1, 100)
      "name": "string", //input
      "call_numbers": 0, //default 0
      "patient_numbers": 0, //default 0
      "hospital_numbers": 0, //default 0
    };
    bool created = await DBService().writeDataToDB('regions', region);
    if(created) CachedModels.regions = await DBService().getData('regions');
    return created;
  }

  Future<bool> createRoad(Map<String, dynamic> road) async {
    road = {
      "road_id": 1, //random(1, 100)
      "name": "string", //input
      "region_id": 1, //drop down
      "width": 0, //input
      "traffic": 0, //input
      "stops": 0, //input
    };
    bool created = await DBService().writeDataToDB('roads', road);
    if(created) CachedModels.roads = await DBService().getData('roads');
    return created;
  }

  Future<bool> createSickness(Map<String, dynamic> sickness) async {
    sickness = {
      "sickness_id": 1, //random(1, 100)
      "name": "string", //input
      "analysis": "string", //input
      "diagnosis": "string", //input
      "symptoms": "string", //input
      "treatment": "string", //input
    };
    bool created = await DBService().writeDataToDB('sickness', sickness);
    if(created) CachedModels.sicknesses = await DBService().getData('sickness');
    return created;
  }

  int getBestRoute() {
    int bestRouteId = 0;
    double bestRouteCoefficient = 0;
    for(Map<String, dynamic> item in CachedModels.roads) {
      //width -- more wider, more faster 1 = 2
      //stops -- more stops, more slower 1 = 0.3
      //traffic -- more higher traffic, more slower 1 = 0.1
      double currentRoadCoefficient = item["traffic"] * 0.1 + item["width"] * 2 + item["stops"] * 0.3;
      if(bestRouteCoefficient < currentRoadCoefficient) {
        bestRouteId = item["road_id"];
      }
    }
    return bestRouteId;
  }
}