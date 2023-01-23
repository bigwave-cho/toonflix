import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webflix/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      'https://webtoon-crawler.nomadcoders.workers.dev';
  static const String today = "today";

  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];

    final url = Uri.parse('$baseUrl/$today');
    //get은 future를 반환(Pormise) - async await
    // Future<Response> get()
    // get함수는 Future타입을 반환; Future는 지금이 아닌 나중에 완료된다는 뜻
    // 완료되면 Response 타입을 반환할 예정.
    // http 요청 완료 기다리게 하기.
    final response = await http.get(url);
    if (response.statusCode == 200) {
      //response.body는 배열로 들어오며 요소 타입은 확실치 않아서 dynamic
      final List<dynamic> webtoons = jsonDecode(response.body);

      for (var webtoon in webtoons) {
        //webtoonModel클래스의 fromJson 컨트트럭터에 의해
        // 인스턴스화 된 데이터들이 차례대로 webtoonInstatnces 배열에 추가됨.
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
      }
      return webtoonInstances;
    }
    throw Error();
  }
}
