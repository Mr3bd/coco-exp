class ImagesInstances {
  List<ImageInstance>? imagesInstances;

  ImagesInstances({this.imagesInstances});

  ImagesInstances.fromJson(Map<String, dynamic> json) {
    if (json['ImagesInstances'] != null) {
      imagesInstances = <ImageInstance>[];
      json['ImagesInstances'].forEach((v) {
        imagesInstances!.add(ImageInstance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (imagesInstances != null) {
      data['ImagesInstances'] =
          imagesInstances!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageInstance {
  int? imageId;
  List<double>? segmentation;
  int? categoryId;

  ImageInstance({this.imageId, this.segmentation, this.categoryId});

  ImageInstance.fromJson(Map<String, dynamic> json) {
    imageId = json['image_id'];

    if (json['segmentation'] != null) {
      segmentation = [];
      // String segmentationString =
      //     json['segmentation'].toString().trim().replaceAll(' ', '');
      // segmentationString =
      //     segmentationString.substring(2, segmentationString.length - 2);
      // segmentationString =
      //     segmentationString.replaceAll('[', '').replaceAll(']', '');
      // segmentationString.split(',').forEach((element) {
      //   segmentation!.add(double.parse(element));
      // });
    }
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_id'] = imageId;
    data['segmentation'] = segmentation;
    data['category_id'] = categoryId;
    return data;
  }
}
