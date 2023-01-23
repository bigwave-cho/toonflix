class WebtoonModel {
  final String title, thumb, id;

// named constructor 이용해서 받아온 json 데이터로 위 프로퍼티들 초기화.
  WebtoonModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'];
}
