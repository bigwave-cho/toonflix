import 'package:flutter/material.dart';
import 'package:webflix/models/webtoon_model.dart';
import 'package:webflix/services/api_service.dart';
import 'package:webflix/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    // print(webtoons); //Instance of 'Future<List<WebtoonModel>>
//원래라면 Future타입은 asnyc/await으로 기다려야 하지만 이를 위한 widget 존재
// 'FutureBuilder'

    // Scaffold는 screen을 위한 기본적 레이아웃과 설정을 제공.
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.white,
          foregroundColor: Colors.green,
          title: const Text(
            '오늘의 웹툰',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: FutureBuilder(
          //future 기다려라
          future: webtoons,
          builder: (context, snapshot) {
            //snapshot : Future상태 감지
            if (snapshot.hasData) {
              // ListView.builder는 사용자가 보는 것만 로드하고
              //안보는 것들은 메모리에서 제외시킨다.
              return Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Expanded(child: makeList(snapshot)),
                ],
              );
            }
            return const Center(
              // 로딩 스피너
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  //전구표시 -> method 추출 -> 아래처럼 분리됨.
  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      itemBuilder: (context, index) {
        //print(index); // 스크롤해보면 해당 아이템의 index가 디버그 콘솔에 나타남.
        //index: 어떤 아이템이 빌드되는지 알 수 있는 요소
        var webtoon = snapshot.data![index];

        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ), // separatorBuilder는 리스트 사이에 추가해줄 위젯을 리턴.
      separatorBuilder: (context, index) {
        return const SizedBox(
          width: 40,
        );
      },
    );
  }
}
