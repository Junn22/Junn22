import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'list.dart';
import 'main.dart';
import 'models.dart';
import 'user_dialog.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({Key? key}) : super(key: key);

  @override
  _FolderPageState createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  final storage = GetStorage('City');
  final storageApt = GetStorage('AptList');

  List<City> cityList = []; //cityList 라는 dynamic타입의 변수를 만듬
  //List<City> resultList = []; // resultList라는 City 타입의 변수를 만듬

  @override
  void initState() {
    //초기화 할때 도시목록을 가져오는 로직
    //storage.erase();
    print('aptlist ${storageApt.read('Apt_1')}');
    print('cityList check JH: ${storage.toString()}, ${storage.read('cityList')}');

    if (storage.read('cityList') != null) {
      final tempCityList = jsonDecode(storage.read('cityList'));

      // 아래 코드의 정확한 뜻을 모르겠다.
      // cityList 와 resultList 의 차이
      tempCityList.forEach((element) {
        cityList.add(City.fromJson(element));
      });
    }
    super.initState();
  }



  // 아래는 addCityData라는 반환형이 없는 함수를 선언해 준 것?
  void addCityData(City city) {
    //도시 목록이 있을 경우에 자동으로 목록을 세팅해주는 부분
    setState(() {
      cityList.add(city);
      //storage.write(key, value)
    });
  }


  // 아래는 showCitydialog라는 반환하지 않는 함수를 선언해준 것?
  void showCityDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: AddCityDialog(addCityData),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(54, 77, 236, 1),
        onPressed: showCityDialog,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("지역명 폴더",
            style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(54, 77, 236, 1),
                fontFamily: 'jalnan')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Text("+ 버튼을 사용해 임장 지역 추가",
                style: TextStyle(
                    color: Color.fromRGBO(54, 77, 236, 1), fontSize: 18)),
            SizedBox(height: 10),
            Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  physics: ScrollPhysics(parent: null),
                  itemBuilder: (context, index) {
                    //String key = settings.keys.elementAt(index);
                    return Card(
                        margin: EdgeInsets.all(4),
                        elevation: 4,
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              //Get.to(MyHomePage(title: '아파트 단지 체크리스트'));
                              //Get.to(ListPage());
                              Get.to(() => ListPage(
                                //addApt: (Apt ) {  }, 은 무엇인가???
                                    cityId: cityList[index].cityId,
                                  ));
                            });
                          },
                          leading: Icon(Icons.apartment),
                          title: Text(
                            cityList[index].cityName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    //contentPadding: EdgeInsets.all(2),
                                    actions: [
                                      Row(
                                        children: [
                                          Spacer(),
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            height: MediaQuery.of(context).size.height * 0.05,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Color.fromRGBO(
                                                        114, 114, 114, 1)),
                                                onPressed: () {
                                                  print(
                                                      'before resultList length: ${cityList.length}');
                                                  setState(() {
                                                    Navigator.of(context).pop();
                                                    //setState를 써야 UI 상에 그려줄 수 있다.
                                                    cityList.removeAt(index);
                                                    storage.write('cityList', jsonEncode(cityList));
                                                  });
                                                  print('after resultList length: ${cityList.length}');
                                                },
                                                child: Text("예, 삭제할게요", style: TextStyle(fontSize: 12),)),
                                          ),
                                          Spacer(),
                                          //SizedBox(width: 10),
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            height: MediaQuery.of(context).size.height * 0.05,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Color.fromRGBO(
                                                        54, 77, 236, 1)),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("아니요",style: TextStyle(fontSize: 12), )),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ],
                                    title: const Text(
                                      '삭제하시겠습니까?',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    //contentPadding: const EdgeInsets.all(20),
                                    content: const Text('삭제한 폴더는 복구할 수 없습니다.'),
                                  ),
                                );
                              });
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ));
                  },
                  itemCount: cityList.length,
                )),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
