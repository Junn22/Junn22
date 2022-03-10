import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'models.dart';
import 'dart:convert';

class AddCityDialog extends StatefulWidget {
  //const AddUserDialog({Key? key}) : super(key: key);
  //const AddUserDialog({Key? key, required this.addUser}) : super(key: key);

  final Function(City) addCity;
  AddCityDialog(this.addCity);

  @override
  _AddCityDialogState createState() => _AddCityDialogState();
}

class _AddCityDialogState extends State<AddCityDialog> {

  final storage = GetStorage('City');
  var cityNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //스토리지에서 데이터를 가져온다.

    //도시목록을 일단 빈 배열로 선언한다.
    List<dynamic> cityList = [];
    //도시목록의 갯수를 0으로 세팅한다.
    int cityLength = 0;
    //도시목록이 없으면(cityList라는 스토리지에 도시 목록이 없으면) 빈배열로 세팅하고
    if(storage.read('cityList') == null){
      cityList = [];
    }else{
      // 목록이 있으면(cityList라는 스토리지에 도시 목록이 있으면)
      // 도시목록 데이터와 갯수를 변수에 넣는다.
      cityList = jsonDecode(storage.read('cityList'));
      cityLength = cityList.length;
    }

    // 텍스트 필드 위젯(String + Controller)
    Widget buildTextField(String hint, TextEditingController controller) {
      return Container(
        height: 50,
        width: double.infinity,
        child: TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color.fromRGBO(54, 77, 236, 1)),
            ),
          ),
          controller: controller,
        ),
      );
    }

    return Container(
      height: 180,
      padding: EdgeInsets.all(8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "지역 폴더를 만들어 주세요",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black),
            ),
            SizedBox(height: 7),
            buildTextField('예) 강남구 역삼동', cityNameController),
            SizedBox(height: 5),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(54, 77, 236, 1)),
                onPressed: () {

                  //버튼을 눌렀을 때, 목록의 갯수를 cityId로 지정하고
                  //입력한 데이터를 City라는 모델에 넣어서 추가한다.

                  // 아래 코드는 왜 onPressed에 넣는 것인가?
                  // City 모델(클래스)에서 city라는 변수를 하나 만듬.
                  City city = City(
                    cityId : cityLength,
                    cityName : cityNameController.text,
                  );

                  print(city);

                  //목록 추가하는 부분 ????
                  widget.addCity(city);

                  //도시목록에 새로만든 모델(새로 입력한 데이터)을 추가한다.
                  cityList.add(city);

                  //'cityList'라는 스토리지에 도시목록을 저장한다.
                  //'cityList'스토리지는 제이슨 형식으로 데이터를 저장하기 때문에
                  // cityList를 jsonEncode 해야한다.
                  storage.write('cityList', jsonEncode(cityList));
                  print('storage write:${storage.toString()}');
                  //json.decode(cityList.toString());
                  //storage.write('cityList', json.decode(cityList.toString()));
                  Navigator.of(context).pop();
                },
                child: Text("장소 추가"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
