class PBSetting {
  int _id;
  String _type;
  String _name;
  String _config;
  String _path;
  bool _visible;

  PBSetting();

  int get id => _id;
  String get type => _type;
  String get name => _name;
  String get config => _config;
  String get path => _path;
  bool get visible => _visible;

  PBSetting.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._type = map['type'];
    this._name = map['name'];
    this._config = map['config'];
    this._path = map['path'];
    this._visible = map['visible'] == 1;
  }

  Map<String, dynamic> toMap() {
    var map = {
      'id': _id,
      'type': _type,
      'name': _name,
      'config': _config,
      'path': _path,
      'visible': _visible ? 1 : 0,
    };
    return map;
  }
}
