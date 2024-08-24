import 'package:employee_list/Models/employeeModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
Future<List<Employee>> fetchEmployees() async {
  final response = await http.get(Uri.parse('https://66c9c2d059f4350f064d5c97.mockapi.io/api/v1/Employeedetails'));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    List<Employee> employees = jsonData.map((json) => Employee.fromJson(json)).toList();
    return employees;
  } else {
    throw Exception('Failed to load employees');
  }
}