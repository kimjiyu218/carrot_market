import 'package:carrot_market/repository/contents_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String currentLocation;
  late ContentsRepository contentsRepository;
  final Map<String, String> locationTypeToString = {
    "singa": "신가동",
    "unnam": "운남동",
    "sinchang": "신창동",
  };

  @override
  void initState() {
    super.initState();
    currentLocation = "singa";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contentsRepository = ContentsRepository();
  }

  AppBar _appbarWidget() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          print("click");
        },
        child: PopupMenuButton<String>(
          offset: Offset(0, 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onSelected: (String where) {
            setState(() {
              currentLocation = where;
            });
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(value: "singa", child: Text("신가동")),
              PopupMenuItem(value: "unnam", child: Text("운남동")),
              PopupMenuItem(value: "sinchang", child: Text("신창동")),
            ];
          },
          child: Row(
            children: [
              Text(locationTypeToString[currentLocation]!),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
      elevation: 1,
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: Icon(Icons.tune)),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset("assets/svg/bell.svg", width: 22),
        ),
      ],
    );
  }

  Future<List<Map<String, String>>> _loadContents() async {
    return contentsRepository.loadContentsFromLocation(currentLocation);
  }

  Widget _bodyWidget() {
    final oCcy = NumberFormat("#,###");

    String formatPrice(String priceString) {
      if (priceString == "무료나눔") {
        return priceString;
      }
      final price = int.tryParse(priceString) ?? 0;
      final formattedPrice = oCcy.format(price);
      return "$formattedPrice 원";
    }

    return FutureBuilder<List<Map<String, String>>>(
      future: _loadContents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("해당 지역에 데이터가 없습니다"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("해당 지역에 데이터가 없습니다"));
        } else {
          final datas = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (BuildContext context, int index) {
              final item = datas[index];
              final priceString = item["price"] ?? "무료나눔";
              final formattedPrice = formatPrice(priceString);

              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => DetailContentView(data: item)));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      // 이미지
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Hero(
                          tag: item["cid"] ?? "defaultTag",
                          child: Image.asset(
                            item["image"] ?? "assets/images/default.png", // 기본 이미지 경로
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 20), // 이미지와 텍스트 사이의 간격
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              overflow: TextOverflow.ellipsis,
                              item["title"] ?? "제목 없음",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(height: 7),
                            Text(
                              item["location"] ?? "위치 없음",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              formattedPrice,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SvgPicture.asset("assets/svg/heart_off.svg", width: 13, height: 13),
                                SizedBox(width: 3),
                                Text("${item["likes"] ?? "0"}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(height: 1, color: Colors.black.withOpacity(0.4));
            },
            itemCount: datas.length, // 데이터 리스트의 길이로 설정
          );
        }
      },
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(String iconName, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: SvgPicture.asset("assets/svg/${iconName}_off.svg", width: 23),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: SvgPicture.asset("assets/svg/${iconName}_on.svg", width: 23),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}
