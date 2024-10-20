class StatusModel {
  int? id_status;
  String? status;
  StatusModel({this.id_status, this.status});

  factory StatusModel.fromMap(Map<String, dynamic> status) {
    return StatusModel(
        id_status: status['id_status'], status: status['status']);
  }
}
