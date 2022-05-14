import 'dart:math';

class Functions {
  popRandImageIds(List<int> imIdList) {
    List<int> randImIds = [];
    var N = imIdList.length;
    for (int i = 0; i < min(N, 5); i++) {
      var M = imIdList.length;
      var rng = Random();
      int randInd = (rng.nextInt(M) * M).floor();
      randImIds.add(imIdList[randInd]);
    }
    return randImIds;
  }
}
