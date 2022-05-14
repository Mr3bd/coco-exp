import 'dart:convert';

import 'package:coco_task/Models/categories_model.dart';
import 'package:coco_task/Models/image_data_model.dart';
import 'package:coco_task/Models/images_captions.dart';
import 'package:coco_task/Models/images_instances.dart';
import 'package:coco_task/Models/images_models.dart';
import 'package:dio/dio.dart';

class ApiProvider {
  final Dio _dio = Dio();
  final String _url = 'https://cocodataset.org/other/cocoexplorer.js';

  Future<CategoriesModel> fetchCategoriesList() async {
    try {
      Response response = await _dio.get(_url,
          options: Options(
            contentType: 'application/json;charset=UTF-8',
          ));
      String r = response.data
          .toString()
          .split('var')[3]
          .replaceAll('\n', '')
          .replaceAll(' ', '');

      RegExp regExp = RegExp(
        "{'supercategory':'[a-zA-Z]+','id':[0-9]+,'name':'[^']*'}",
        caseSensitive: false,
        multiLine: false,
      );

      String result = '{"Categories":' +
          regExp
              .allMatches(r)
              .map((z) => z.group(0))
              .toList()
              .toString()
              .replaceAll('\'', '"') +
          '}';
      final body = json.decode(result);

      return CategoriesModel.fromJson(body);
    } catch (error) {
      //print("Exception occured: $error stackTrace: $stacktrace");
      return CategoriesModel.withError("Data not found / Connection issue");
    }
  }

  Future<List<int>> fetchImageByCatsList(List<Category> list) async {
    List<int> intList = [];
    for (var element in list) {
      intList.add(element.id!);
    }

    try {
      Response response = await _dio.post(
          'https://us-central1-open-images-dataset.cloudfunctions.net/coco-dataset-bigquery',
          data: {"category_ids": intList, "querytype": "getImagesByCats"});

      String result = response.data.toString().trim().replaceAll(' ', '');
      intList.clear();
      result = result.substring(1, result.length - 1);
      result.split(',').forEach((element) {
        intList.add(int.parse(element));
      });
    } catch (error) {
      print(error);
      intList.clear();
    }

    return intList;
  }

  Future<List<ImageDataModel>> loadImageData(List<int> imageIds) async {
    List<ImageDataModel> imagesData = [];

    var querytypes = ["getImages", "getInstances", "getCaptions"];
    var responses = [];
    for (var element in querytypes) {
      try {
        Response response = await _dio.post(
            'https://us-central1-open-images-dataset.cloudfunctions.net/coco-dataset-bigquery',
            data: {"image_ids": imageIds, "querytype": element});

        responses.add(response.data);
      } catch (error) {
        //print("Exception occured: $error stackTrace: $stacktrace");
      }
    }

    if (responses[0] != null) {
      print(0);

      List<ImageModel> imagesSec = List<ImageModel>.from(json
          .decode(json.encode(responses[0]))
          .map((x) => ImageModel.fromJson(x)));

      for (var i = 0; i < imagesSec.length; i++) {
        var imgId = imagesSec[i].id;
        imagesData.add(ImageDataModel(
            flickrUrl: imagesSec[i].flickrUrl,
            cocoUrl: imagesSec[i].cocoUrl,
            id: imgId,
            instances: [],
            captions: []));
      }
    }

    if (responses[1] != null) {
      print(1);

      List<ImageInstance> instances = List<ImageInstance>.from(json
          .decode(json.encode(responses[1]))
          .map((x) => ImageInstance.fromJson(x)));

      for (var i = 0; i < instances.length; i++) {
        var imgId = instances[i].imageId;
        int iv = imagesData.indexWhere((element) => element.id == imgId);

        imagesData[iv].instances!.add(instances[i]);
      }
    }

    if (responses[2] != null) {
      print(2);
      List<ImageCaption> captions = List<ImageCaption>.from(json
          .decode(json.encode(responses[2]))
          .map((x) => ImageCaption.fromJson(x)));

      for (var i = 0; i < captions.length; i++) {
        var imgId = captions[i].imageId;
        int iv = imagesData.indexWhere((element) => element.id == imgId);

        if (captions[i].caption != null) {
          imagesData[iv].captions!.add(captions[i].caption!.toLowerCase());
        }
      }
    }

    return imagesData;
  }
}
