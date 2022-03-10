import 'package:flutter/material.dart';
import 'dart:convert';


class Apt{
  int aptId;
  String aptName;

  Apt({required this.aptId, required this.aptName});
  // 기본형 컨스트럭터 생성
  // 외부에서 aptId랑 aptName을 가지고 와서 클래스의 aptId와 aptName에 넣겠다.


  factory Apt.fromJson(Map<String, dynamic> Json){
    return Apt(
      aptId: Json['aptId'],
      aptName: Json['aptName'],
    );
  } //formJson이라는 네임드 컨스트럭트


  Map<String, dynamic> toJson() => {
    'aptId': aptId,
    'aptName': aptName,
  };
}

//