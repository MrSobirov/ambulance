import 'package:ambulance/services/cache_values.dart';
import 'package:ambulance/services/db_service.dart';

class DBRepo {
  Future<void> getAllData() async {
    CachedModels.patients = await DBService().getData('patient');
    CachedModels.doctors = await DBService().getData('receipt');
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
    return DBService().writeDataToDB('callform', callForm);
  }

  Future<bool> createDoctor(Map<String, dynamic> doctor) async {
    doctor = {
      "doctor_id": 1, //random(1, 100)
      "name": "string", //input
      "hospital_id": 1, //drop down
      "experince": 10, //input
      "patient_id": 1, //drop down
    };
    return DBService().writeDataToDB('doctor', doctor);
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
    return DBService().writeDataToDB('hospital', hospital);
  }

  Future<bool> createMedicalHistory(Map<String, dynamic> medicalHistory) async {
    medicalHistory = {
      "medical_id": 1, //random(1, 100)
      "patient_id": 1, //drop down
      "receipt_id": 1, //drop down
      "sickness_id": 1, //drop down
      "call_id": "1", //drop down
    };
    return DBService().writeDataToDB('medicalhistory', medicalHistory);
  }

  Future<bool> createNurse(Map<String, dynamic> nurse) async {
    nurse = {
      "nurse_id": 1, //random(1, 100)
      "name": "string", //input
      "hospital_id": 1, //drop down
      "schedule": "08:00 - 13:00", //input
      "patient_id": 1, //drop down
    };
    return DBService().writeDataToDB('nurse', nurse);
  }

  Future<bool> createPatient(Map<String, dynamic> patient) async {
    patient = {
      "patient_id": 1, //random(1, 100)
      "name": "string", //input
      "phones": "94 659 08 50", //input
      "sickness_id": 1, //drop down
      "age": 20, //input
    };
    return DBService().writeDataToDB('patient', patient);
  }

  Future<bool> createReceipt(Map<String, dynamic> receipt) async {
    receipt = {
      "receipt_id": 1, //random(1, 100)
      "pills": "string", //input
      "injections": "string", //input
      "therapies": "string", //input
      "patient_id": 1, //drop down
      "medical_id": 1, //firstWhere bilan call form dan ovolasan
      "sickness_id": 1, //firstWhere bilan medicalHistory dan ovolasan medical id ni tepada yozdim olishni
      "doctor_id": 1, //firstWhere bilan call form dan ovolasan
    };
    return DBService().writeDataToDB('receipts', receipt);
  }

  Future<bool> createRegion(Map<String, dynamic> region) async {
    region = {
      "region_id": 1, //random(1, 100)
      "name": "string", //input
      "call_numbers": 0, //default 0
      "patient_numbers": 0, //default 0
      "hospital_numbers": 0, //default 0
    };
    return DBService().writeDataToDB('regions', region);
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
    return DBService().writeDataToDB('roads', road);
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
    return DBService().writeDataToDB('sickness', sickness);
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