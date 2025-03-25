import '../../../constants/apiEndPoints.dart';
import '../../../helper/ApiHandler.dart';
import '../model/category_model.dart';

class CategoryController {
  static Future<List<CategoryModel>> getCategory() async {
    try {
      var response = await GetDio.getDio()
          .get(ApiEndPoints.baseURL + ApiEndPoints.categoryapi);
      return categoryModelFromJson(response.data);
    } catch (e) {
      return <CategoryModel>[];
    }
  }
}