import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'main.dart';
import 'package:get/get.dart';
import 'models.dart';
import 'models2.dart';

class ListPage extends StatefulWidget {
  final int cityId;
  //final Function(City) addCity;
  //AddCityDialog(this.addCity);


  // ????
  const ListPage({Key? key, required this.cityId}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {


  //'AptList'라는 storageApt 저장 공간을 만듬.
  final storageApt = GetStorage('AptList');

  List<Apt> aptList = []; //aptList 라는 dynamic타입의 변수를 만듬
  //List<City> resultAptList = []; // resultAptList라는 City 타입의 변수를 만듬

  int aptLength = 1;

  //int number = 1;

  @override
  void initState() {
    super.initState();
    //storageApt.erase();

    //aptId 만드는것, widget은 어디에서 온 것? 왜 cityId를 준 것?
    String aptId = 'Apt_${widget.cityId}';

    // 아래 키 값(2쌍)은 왜 설정해준 것?
    // String aptName = '아파트 단지명';
    Map<String, String> aptName = {
      'aptId': '1번',
      'aptName': 'e편한세상',
    };

    if (storageApt.read('aptList') != null) {

      final tempAptList = jsonDecode(storageApt.read('aptList'));
      tempAptList.forEach((element) {

        aptList.add(Apt.fromJson(element));
      });


    }

    // 아래 코드는 왜 있는 것?
    //storageApt.write(aptId, aptName);
    //storageApt.write(aptList);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      appBar: AppBar(
        title: Text("아파트 단지 체크 목록", style: TextStyle(fontSize: 20,
            color: Color.fromRGBO(54, 77, 236, 1),
            fontFamily: 'jalnan')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              physics: ScrollPhysics(parent: null),
              // 스크롤 했을 때 움직이지 않게 하는 코드, 이게 없으면 내렸다가 다시 올라감
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    elevation: 4,
                    child: ListTile(
                    onTap: () {
                  setState(() {
                    Get.to(MyHomePage(title: '아파트 단지 체크리스트'));
                  });
                },
                title: Text(aptList[index].aptName),
                leading: Icon(Icons.apartment),
                trailing: IconButton(onPressed: () {
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
                                      setState(() {
                                        Navigator.of(context).pop();
                                        //setState를 써야 UI 상에 그려줄 수 있다.
                                        print('before apttList length: ${aptList.length}');
                                        aptList.removeAt(index);
                                        storageApt.write('aptList', jsonEncode(aptList));
                                        print('after aptList length: ${aptList.length}');
                                      });
                                    },
                                    child: Text('예, 삭제할게요', style: TextStyle(fontSize: 12),)),
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
                                    child: Text("아니요", style: TextStyle(fontSize: 12),)),
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

                    // print('before apttList length: ${aptList.length}');
                    // aptList.removeAt(index);
                    // storageApt.write('aptList', jsonEncode(aptList));
                    // print('after aptList length: ${aptList.length}');
                  });
                },
                icon: Icon(Icons.delete),


                )
                ,
                ));
              },
              itemCount: aptList.length,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(54, 77, 236, 1),
        onPressed: () {
          setState(() {

            // Apt 타입의 변수를 만듬.
            Apt apt = Apt(
              aptId : aptList.length,
              aptName : '아파트 단지명(${aptList.length})'
            );

            print(apt);

            //목록 추가하는 부분 ????
            Map<String,Apt> aptGroup={
              '${widget.cityId}':apt
            };

            //도시목록에 새로만든 모델(새로 입력한 데이터)을 추가한다.
            aptList.add(apt);


            storageApt.write('aptList', jsonEncode(aptList));
            print('storage write:${storageApt.toString()}');

          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}