class Employee {
  final String id;
  final String name;
  final String avatar;
  final String department;
  final String designation;
  final DateTime joinDate;
  final String phone;

  Employee({
    required this.id,
    required this.name,
    required this.avatar,
    required this.department,
    required this.designation,
    required this.joinDate,
    required this.phone,
  });

  // Factory method to create an Employee from a JSON object
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      department: json['department'] as String,
      designation: json['designation'] as String,
      joinDate: DateTime.parse(json['join_date'] as String),
      phone: json['phone'] as String,
    );
  }

  // Method to convert an Employee object to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'department': department,
      'designation': designation,
      'join_date': joinDate.toIso8601String(),
      'phone': phone,
    };
  }
}
