import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'home.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  List<Map<String, String>> datas = [];
  late int _currentPageIndex;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
    datas = [
      {
        "image": "assets/images/ara-1.jpg",
        "title": "네메시스 축구화275",
        "location": "제주 제주시 아라동",
        "price": "30000",
        "likes": "2",
      },
      {
        "image": "assets/images/ara-2.jpg",
        "title": "LA갈비 5Kg팔아요~",
        "location": "제주 제주시 아라동",
        "price": "10000",
        "likes": "6",
      },
      {
        "image": "assets/images/ara-4.jpg",
        "title": "[풀박스]맥북프로16인치 터치바 스페이스그레이",
        "location": "제주 제주시 아라동",
        "price": "2500000",
        "likes": "4",
      },
      {
        "image": "assets/images/ara-5.jpg",
        "title": "네메시스 축구화275",
        "location": "제주 제주시 아라동",
        "price": "30000",
        "likes": "10",
      },
      {
        "image": "assets/images/ara-6.jpg",
        "title": "갤럭시s10",
        "location": "제주 제주시 아라동",
        "price": "1890000",
        "likes": "2",
      },
      {
        "image": "assets/images/ara-7.jpg",
        "title": "선반",
        "location": "제주 제주시 아라동",
        "price": "14000",
        "likes": "1",
      },
      {
        "image": "assets/images/ara-8.jpg",
        "title": "냉장 쇼케이스",
        "location": "제주 제주시 아라동",
        "price": "60000",
        "likes": "4",
      },
      {
        "image": "assets/images/ara-9.jpg",
        "title": "대우미니냉장고",
        "location": "제주 제주시 아라동",
        "price": "30000",
        "likes": "7",
      },
      {
        "image": "assets/images/ara-10.jpg",
        "title": "멜킨스 풀업 운동기구",
        "location": "제주 제주시 아라동",
        "price": "56000",
        "likes": "9",
      },
    ];
  }

  AppBar _appbarWidget() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          print("click");
        },
        child: Row(
          children: [
            Text("수완동"),
            Icon(Icons.arrow_drop_down),
          ],
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


  Widget _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
            return Home();
        break;
      case 1:
        return Container();
        break;
      case 2:
        return Container();
        break;
      case 3:
        return Container();
        break;
      case 4:
        return Container();
        break;
    }

    final oCcy = new NumberFormat("#,###");
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (BuildContext context, int index) {
        final item = datas[index];
        final price = int.tryParse(item["price"] ?? "0") ?? 0;
        final formattedPrice = oCcy.format(price);
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              // 이미지
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  item["image"] ?? "assets/images/default.png", // 기본 이미지 경로
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
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
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),
                    ),
                    SizedBox(height: 7),
                    Text(item["location"] ?? "위치 없음",
                    style: TextStyle(fontSize: 15),),
                    Text(
                      "$formattedPrice 원",
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset("assets/svg/heart_off.svg",width: 13,height: 13,),
                        SizedBox(width: 3),
                        Text("${item["likes"] ?? "0"}",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(height: 1, color: Colors.black.withOpacity(0.4));
      },
      itemCount: datas.length, // 데이터 리스트의 길이로 설정
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(
      String iconName, String label) {
    return  BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset("assets/svg/${iconName}_off.svg",width: 23),
        ),
        activeIcon:  Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset("assets/svg/${iconName}_on.svg",width: 23),
        ),
        label: label,
    );
  }

  Widget _bottomNavigationBarwidget() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      currentIndex: _currentPageIndex,
      selectedItemColor: Colors.black,
      items: [
        _bottomNavigationBarItem("home","홈"),
        _bottomNavigationBarItem("notes","동네생활"),
        _bottomNavigationBarItem("location","내 근처"),
        _bottomNavigationBarItem("chat","채팅"),
        _bottomNavigationBarItem("user","나의 당근"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarwidget(),
    );
  }
}
