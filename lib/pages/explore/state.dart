import '../../common/utils/staticdata.dart';
import 'package:get/get.dart';

class ExploreState {
  late List<Map<String, dynamic>> playlistCategories;
  // 被选择中的分类
  late RxInt selectedCategory;

  ExploreState() {
    playlistCategories = playlistCategoriesStaticData.where((element) => element['enable'] == true).toList();
    selectedCategory = 0.obs;
  }
}
