class ImagesModel {
  List<ImageModel>? imagesModel;

  ImagesModel({this.imagesModel});

  ImagesModel.fromJson(Map<String, dynamic> json) {
    if (json['ImagesModel'] != null) {
      imagesModel = <ImageModel>[];
      json['ImagesModel'].forEach((v) {
        imagesModel!.add(ImageModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (imagesModel != null) {
      data['ImagesModel'] = imagesModel!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageModel {
  int? id;
  String? cocoUrl;
  String? flickrUrl;

  ImageModel({this.id, this.cocoUrl, this.flickrUrl});

  ImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cocoUrl = json['coco_url'];
    flickrUrl = json['flickr_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['coco_url'] = cocoUrl;
    data['flickr_url'] = flickrUrl;
    return data;
  }
}
