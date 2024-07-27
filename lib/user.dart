class User {
  final int? id;
  final String email;
  final String? password;
  final String? firstname;
  final String? lastname;
  final String? universitas;
  final String? alamat;

  User({
    this.id,
    required this.email,
    this.password,
    this.firstname,
    this.lastname,
    this.universitas,
    this.alamat,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'firstname': firstname,
      'lastname': lastname,
      'universitas': universitas,
      'alamat': alamat,
    };
  }
}