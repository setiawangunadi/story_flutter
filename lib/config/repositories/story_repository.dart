import 'package:dio/dio.dart';
import 'package:story_app/config/data/network/canonical_path.dart';
import 'package:story_app/config/data/network/dio_provider.dart';

class StoryRepository {
  Future<Response> getListStory() async {
    final response = DioProvider().get(
      path: CanonicalPath.listStory,
    );
    return response;
  }

  Future<Response> getDetailStory({required String id}) async {
    final response = DioProvider().get(
      path: "${CanonicalPath.listStory}/$id",
    );
    return response;
  }
}
