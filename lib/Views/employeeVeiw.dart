import 'package:flutter/material.dart';
import 'package:employee_list/Controller/employeeController.dart';
import 'package:employee_list/Models/employeeModel.dart';

class EmployeeView extends StatefulWidget {
  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeView> with SingleTickerProviderStateMixin {
  late Future<List<Employee>> futureEmployees;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Employee> _employees = [];
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    futureEmployees = fetchEmployees(); // Fetching the data when the widget is initialized
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    futureEmployees.then((employees) {
      setState(() {
        _employees = employees;
      });
      _addEmployeesToAnimatedList(employees);
    });
  }

  void _addEmployeesToAnimatedList(List<Employee> employees) {
    Future ft = Future(() {});
    for (var i = 0; i < employees.length; i++) {
      ft = ft.then((_) {
        return Future.delayed(const Duration(milliseconds: 100), () {
          if (_listKey.currentState != null && i <= _employees.length) { // Safety check
            _listKey.currentState!.insertItem(i);
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
      ),
      body: Center(
        child: FutureBuilder<List<Employee>>(
          future: futureEmployees,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No employees found');
            } else {
              return AnimatedList(
                key: _listKey,
                initialItemCount: _employees.length,
                itemBuilder: (context, index, animation) {
                  return _buildAnimatedEmployeeItem(_employees[index], animation);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedEmployeeItem(Employee employee, Animation<double> animation) {
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    ));

    return SlideTransition(
      position: _offsetAnimation,
      child: ListTile(
        title: Text(employee.name),
        subtitle: Text('${employee.department} - ${employee.designation}'),
        trailing: CircleAvatar(child: Text(employee.name[0])),
      ),
    );
  }
}
