class GithubConfig {
  String repositoryName;
  String branchName;
  String token;
  String storagePath;
  String customDomain;

  GithubConfig(
      {this.repositoryName,
      this.branchName,
      this.token,
      this.storagePath,
      this.customDomain});

  GithubConfig.fromJson(Map<String, dynamic> json) {
    repositoryName = json['repositoryName'];
    branchName = json['branchName'];
    token = json['token'];
    storagePath = json['storagePath'];
    customDomain = json['customDomain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['repositoryName'] = this.repositoryName;
    data['branchName'] = this.branchName;
    data['token'] = this.token;
    data['storagePath'] = this.storagePath;
    data['customDomain'] = this.customDomain;
    return data;
  }
}