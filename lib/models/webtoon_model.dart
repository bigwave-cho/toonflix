class WebtoonModel {
  final String title, thumb, id;

// named constructor 이용해서 받아온 json 데이터로 위 프로퍼티들 초기화.
// fromJson 패턴은 플러터에서 많이 쓰이는 "패턴'!
  WebtoonModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'];
}

/*  아래처럼 기본 컨스트럭터로 만들어줘도 되지만 named constructor 사용 권장
class WebtoonModel {
  late final String title, thumb, id;

  WebtoonModel(Map<String, dynamic> json) {
    title = json['title'];
    thumb = json['thumb'];
    id = json['id'];
  }
}
*/
