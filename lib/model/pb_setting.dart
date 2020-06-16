class PbSetting {
  final String id;
  final String type;
  final String name;
  final String config;
  final String  path;
  final bool visible;

  PbSetting(this.id, this.type, this.name, this.path, {this.config, this.visible});

}