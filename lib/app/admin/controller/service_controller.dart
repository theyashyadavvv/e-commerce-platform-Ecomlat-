import 'package:ecommerce_int2/app/admin/model/service_model.dart';

import '../../../constants/apiEndPoints.dart';
import '../../../helper/ApiHandler.dart';

class ServiceController {
  static Future<List<ServiceModel>> getService() async {
    try {
      var response = await GetDio.getDio()
          .get(ApiEndPoints.baseURL + ApiEndPoints.get_service);
      return serviceModelFromJson(response.data);
    } catch (e) {
      return <ServiceModel>[];
    }
  }
}