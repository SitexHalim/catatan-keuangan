class ModelTransaksi {
  int id;
  DateTime date;
  String title;
  double value;
  String description;
  String status;
  int categoryId;

  ModelTransaksi({
    required this.id,
    required this.date,
    required this.title,
    required this.value,
    required this.description,
    required this.status,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'value': value,
      'description': description,
      'status': status,
      'categoryId': categoryId,
    };
  }

  factory ModelTransaksi.fromMap(Map<String, dynamic> map) {
    return ModelTransaksi(
      id: map['id'],
      date: DateTime.parse(map['date']),
      title: map['title'],
      value: map['value'],
      description: map['description'],
      status: map['status'],
      categoryId: map['categoryId'],
    );
  }
}
