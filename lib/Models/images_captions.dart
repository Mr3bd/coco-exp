class ImagesCaptions {
  List<ImageCaption>? imagesCaptions;

  ImagesCaptions({this.imagesCaptions});

  ImagesCaptions.fromJson(Map<String, dynamic> json) {
    if (json['ImagesCaptions'] != null) {
      imagesCaptions = <ImageCaption>[];
      json['ImagesCaptions'].forEach((v) {
        imagesCaptions!.add(ImageCaption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (imagesCaptions != null) {
      data['ImagesCaptions'] = imagesCaptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageCaption {
  String? caption;
  int? imageId;

  ImageCaption({this.caption, this.imageId});

  ImageCaption.fromJson(Map<String, dynamic> json) {
    caption = json['caption'];
    imageId = json['image_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['caption'] = caption;
    data['image_id'] = imageId;
    return data;
  }
}
