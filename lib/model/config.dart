class Config {
  String name;
  String value;
  String label;
  bool needValidate;
  String placeholder;

  Config(
      {this.name, this.value, this.label, this.needValidate, this.placeholder});

  Config.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
    label = json['label'];
    needValidate = json['needValidate'];
    placeholder = json['placeholder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    data['label'] = this.label;
    data['needValidate'] = this.needValidate;
    data['placeholder'] = this.placeholder;
    return data;
  }
}