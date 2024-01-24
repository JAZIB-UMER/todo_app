class NotesModel {
  late final int? id;
  late final String title;
  late final int age;
  late final String description;
  late final String email;

  NotesModel(
      {this.id,
      required this.title,
      required this.age,
      required this.description,
      required this.email});

  NotesModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        age = res['age'],
        description = res['description'],
        email = res['email'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'age': age,
      'description': description,
      'email': email,
    };
  }
}
