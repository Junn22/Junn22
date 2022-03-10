import 'package:flutter/material.dart';
import 'dart:convert';


// City 라는 클래스(틀)을 만든다. 이 틀안에 컨스트럭터를 만들어서 외부에서 이 틀을 가져다가
// 인스턴스(객체)를 만들 수 있다.

class City{
  int cityId;
  String cityName;

  City({required this.cityId, required this.cityName});
  // 기본형 컨스트럭터 생성

  // factory는 왜 넣는것인지?
  // fromJson이라는 컨스트럭터를 만듬
  // 아래 두 코드의 정확한 뜻을 모르겠음.

  factory City.fromJson(Map<String, dynamic> Json){
    return City(
      cityId: Json['cityId'],
      cityName: Json['cityName'],
    );
  } //formJson이라는 네임드 컨스트럭트


  Map<String, dynamic> toJson() => {
    'cityId': cityId,
    'cityName': cityName,
  };
}
