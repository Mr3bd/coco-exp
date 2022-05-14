import 'package:coco_task/API/api_provider.dart';
import 'package:coco_task/Blocs/Categories/categories_bloc.dart';
import 'package:coco_task/Blocs/Images/images_bloc.dart';
import 'package:coco_task/Models/categories_model.dart';
import 'package:coco_task/Models/image_data_model.dart';
import 'package:coco_task/Utilities/Constansts/Style/AppColors.dart';
import 'package:coco_task/Utilities/Tools/local_get.dart';
import 'package:coco_task/Widgets/categorey_image.dart';
import 'package:coco_task/Widgets/categorey_selected.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final CategoriesBloc _categoriesBloc = CategoriesBloc();
  late ImagesBloc _imagesBloc;
  final LocalGet localGet = LocalGet();
  late Size screenSize;
  List<Category> selectedItems = [];
  bool loadImages = false;
  int results = 0, pageSize = 5, pages = 0;

  @override
  void initState() {
    _categoriesBloc.add(GetCategoriesList());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: SizedBox(
              height: kToolbarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Image.asset(localGet.getAssetsImage('logo.png')),
              ),
            ),
          ),
          body: ListView(
            children: [_buildListCategories(), _buildListImages()],
          )),
    );
  }

  Widget _buildListCategories() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => _categoriesBloc,
        child: BlocListener<CategoriesBloc, CategoriesState>(
          listener: (context, state) {
            if (state is CategoriesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                ),
              );
            }
          },
          child: BlocBuilder<CategoriesBloc, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesInitial) {
                return _buildLoading();
              } else if (state is CategoriesLoading) {
                return _buildLoading();
              } else if (state is CategoriesLoaded) {
                return _buildPage(context, state.categoriesModel);
              } else if (state is CategoriesError) {
                return const SizedBox();
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  // (Search & Categories)
  Widget _buildPage(BuildContext context, CategoriesModel model) {
    return Column(
      children: [
        _buildSearch(),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 10,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 1.0,
          ),
          itemCount: model.categories!.length,
          itemBuilder: (context, index) {
            bool selected = selectedItems
                .where((element) => element.id == model.categories![index].id)
                .isNotEmpty;

            return GestureDetector(
              onTap: () {
                if (!selected) {
                  setState(() => selectedItems.add(model.categories![index]));
                } else {
                  setState(() => selectedItems.removeWhere(
                      (element) => element.id == model.categories![index].id));
                }
              },
              child: CategoryImage(
                  id: model.categories![index].id!, selected: selected),
            );
          },
        )
      ],
    );
  }

  // (Loadindg)
  Widget _buildLoading() => const Center(child: CircularProgressIndicator());

  // (Results)

  Widget _buildListImages() {
    return loadImages
        ? Container(
            margin: const EdgeInsets.all(8.0),
            child: BlocProvider(
              create: (_) => _imagesBloc,
              child: BlocListener<ImagesBloc, ImagesState>(
                listener: (context, state) {
                  if (state is ImagesError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(''),
                      ),
                    );
                  }
                },
                child: BlocBuilder<ImagesBloc, ImagesState>(
                  builder: (context, state) {
                    if (state is ImagesInitial) {
                      return _buildLoading();
                    } else if (state is ImagesLoading) {
                      return _buildLoading();
                    } else if (state is ImagesLoaded) {
                      return FutureBuilder<List<ImageDataModel>>(
                        future: getSearchResult(state.images),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            loadImages = false;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  child: Text(
                                    '${snapshot.data!.length} results',
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    addAutomaticKeepAlives: false,
                                    itemBuilder: (context, index) {
                                      return snapshot.data![index].cocoUrl !=
                                              null
                                          ? Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  snapshot.data![index]
                                                              .instances !=
                                                          null
                                                      ? SizedBox(
                                                          height:
                                                              screenSize.width *
                                                                  0.1,
                                                          width:
                                                              screenSize.width,
                                                          child:
                                                              ListView.builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: snapshot
                                                                      .data![
                                                                          index]
                                                                      .instances!
                                                                      .length,
                                                                  itemExtent:
                                                                      screenSize.width *
                                                                          0.1,
                                                                  scrollDirection:
                                                                      Axis
                                                                          .horizontal,
                                                                  itemBuilder:
                                                                      (context,
                                                                          instanceIndex) {
                                                                    return Container(
                                                                      height:
                                                                          screenSize.width *
                                                                              0.1,
                                                                      width: screenSize
                                                                              .width *
                                                                          0.1,
                                                                      margin: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10.0),
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                              width: 2.0,
                                                                              color: Colors.transparent),
                                                                          image: DecorationImage(image: NetworkImage('https://cocodataset.org/images/cocoicons/${snapshot.data![index].instances![instanceIndex].categoryId}.jpg'))),
                                                                    );
                                                                  }),
                                                        )
                                                      : const SizedBox(),
                                                  const SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  snapshot.data![index]
                                                              .captions !=
                                                          null
                                                      ? Column(
                                                          children: [
                                                            Text(snapshot
                                                                .data![index]
                                                                .captionTogether()),
                                                            const SizedBox(
                                                              height: 10.0,
                                                            ),
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                  Container(
                                                    height:
                                                        screenSize.width * 0.4,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              snapshot
                                                                  .data![index]
                                                                  .cocoUrl!)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox();
                                    }),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            loadImages = false;
                            print(snapshot.error);
                            return const Center(
                              child: Icon(
                                Icons.error,
                                color: AppColors.red,
                              ),
                            );
                          }
                          return _buildLoading();
                        },
                      );
                      // return _buildPage(context, state.categoriesModel);
                    } else if (state is ImagesError) {
                      return Container();
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  // (Search Box & Button)

  Widget _buildSearch() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          constraints: BoxConstraints(
            minHeight: screenSize.width * 0.1,
            minWidth: screenSize.width * 0.7,
            maxWidth: screenSize.width * 0.7,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(width: 1.0, color: AppColors.grey)),
          child: Wrap(
            children: selectedItems
                .map((i) => CategorySelected(
                    category: i,
                    reomveFunction: (int id) {
                      setState(() => selectedItems
                          .removeWhere((element) => element.id == id));
                    }))
                .toList(),
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              if (selectedItems.isNotEmpty) {
                _imagesBloc = ImagesBloc(selectedItems);
                _imagesBloc.add(GetImagesList());
                setState(() {
                  loadImages = true;
                });
              }
            },
            child: const Text('Search')),
      ],
    );
  }

  Future<List<ImageDataModel>> getSearchResult(List<int> images) async {
    List<ImageDataModel> data = await ApiProvider().loadImageData(images);
    return data;
  }
}
