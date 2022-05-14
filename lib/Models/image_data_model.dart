import 'package:coco_task/Models/images_instances.dart';

class ImageDataModel {
  String? flickrUrl;
  int? id;
  String? cocoUrl;
  List<ImageInstance>? instances;
  List<String>? captions;

  ImageDataModel(
      {this.flickrUrl, this.cocoUrl, this.instances, this.captions, this.id});

  ImageDataModel.fromJson(Map<String, dynamic> json) {
    flickrUrl = json['flickr_url'];
    cocoUrl = json['coco_url'];
    if (json['instances'] != null) {
      instances = <ImageInstance>[];
      json['orders'].forEach((v) {
        instances!.add(ImageInstance.fromJson(v));
      });
    } else {
      instances = <ImageInstance>[];
    }
    captions = json['captions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flickr_url'] = flickrUrl;
    data['coco_url'] = cocoUrl;
    data['instances'] = instances;
    data['captions'] = captions;
    return data;
  }

  String captionTogether() {
    String text = '';

    for (var element in captions!) {
      if (text == '') {
        text = element;
      } else {
        text += ', $element';
      }
    }

    return text;
  }
}
