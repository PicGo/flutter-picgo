class Uploaded {
  int id;
  String path;
  String type;
  String info;

  Uploaded(this.id, this.path, this.type, {this.info});

  Uploaded.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.type = map['type'];
    this.path = map['path'];
    this.info = map['info'];
  }

  Map<String, dynamic> toMap() {
    var map = {'id': id, 'type': type, 'path': path, 'info': info};
    return map;
  }
}
