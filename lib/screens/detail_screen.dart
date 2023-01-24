import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webflix/models/webtoon_detail_model.dart';
import 'package:webflix/models/webtoon_episode_model.dart';
import 'package:webflix/services/api_service.dart';
import 'package:webflix/widgets/episode_widget.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;

  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    print(prefs.getStringList('isLiked'));
    // 복붙
    // 1. likedToons 배열을 가져오고
    final likedToons = prefs.getStringList('likedToons');

    //2. 처음 앱을 사용하는 경우 likedToons가 없을 것이기 때문에.
    if (likedToons != null) {
      //3. 있으면 해당 위젯 아이디가 있는지 확인해서
      if (likedToons.contains(widget.id) == true) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      //3. 없으면 create 배열
      await prefs.setStringList('likedToons', <String>[]);
    }
  }

// home_screen의 ApiService get 요청이 아래와 같은 절차 없이
//바로 이루어질 수 있었던 이유는 인자로 아무것도 넘길 필요가 없었기 때문.
  @override
  void initState() {
    super.initState();
    // state class에서 widget.id 처럼 참조하는 이유는
    // 별개의 클래스에서 작동하기 때문.
    // widget은 부모 클래스를 가리킴.
    // 얘네 Future들임. 따라서 FutureBuilder 통해 렌더링할거
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }

  onHeartTap() async {
    final likedToons = prefs.getStringList('likedToons');
    // likeToons 리스트를 가져와서 수정을 해준 다음
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }

      // 기존 likedToons 배열을 덮어버리기.
      await prefs.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
      });
      print(likedToons);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border_rounded,
            ),
          ),
        ],
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                      width: 150,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 15,
                              offset: const Offset(10, 10),
                              color: Colors.black.withOpacity(0.5),
                            )
                          ]),
                      child: Image.network(widget.thumb),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: webtoon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text(
                              '${snapshot.data!.genre} / ${snapshot.data!.age}',
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                          future: episodes,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              // list의 길이를 모르면 ListView가 낫지만
                              // 10개 정도면 ListView는 너무 과함. 그래서 Column씀.
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  for (var episode in snapshot.data!)
                                    Episode(
                                        episode: episode, webtoonId: widget.id)
                                ],
                              );
                            }
                            return Container();
                          },
                        )
                      ],
                    );
                  }
                  return const CircularProgressIndicator();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
