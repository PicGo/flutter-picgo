class Uploaded {
  int id;
  String path;
  String type;

  Uploaded(this.id, this.path, this.type);

  Uploaded.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.type = map['type'];
    this.path = map['path'];
  }

  Map<String, dynamic> toMap() {
    var map = {'id': id, 'type': type, 'path': path};
    return map;
  }
}
