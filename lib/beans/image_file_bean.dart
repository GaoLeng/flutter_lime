class ImageFileBean {
  List<String> files;
  String folderName;

  ImageFileBean({this.files, this.folderName});

  ImageFileBean.fromJson(Map<String, dynamic> json) {
    files = json['files'].cast<String>();
    folderName = json['folderName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['files'] = this.files;
    data['folderName'] = this.folderName;
    return data;
  }
}
