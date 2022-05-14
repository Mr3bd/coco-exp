class CategoriesModel {
  List<Category>? categories;
  String? error;

  CategoriesModel({
    this.categories,
  });

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    if (json['Categories'] != null) {
      categories = <Category>[];
      json['Categories'].forEach((v) {
        categories!.add(Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categories != null) {
      data['Categories'] = categories!.map((v) => v.toJson()).toList();
    }

    return data;
  }

  CategoriesModel.withError(String errorMessage) {
    error = errorMessage;
  }
}

class Category {
  String? supercategory;
  int? id;
  String? name;

  Category({this.supercategory, this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    supercategory = json['supercategory'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['supercategory'] = supercategory;
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
