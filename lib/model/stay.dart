import 'dart:io';

import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;



class Stay {
  int id;
  DateTime startTime;
  DateTime endTime;
  int dose;
  //int roomID;
  Stay({this.id, this.startTime, this.endTime, this.dose});

  Map<String, dynamic> toJson(Stay instance) => <String, dynamic>{
    'id': instance.id.toString(),
    'startTime': instance.startTime.toString(),
    'endTime': instance.endTime.toString(),
    'dose': instance.dose.toString()
  };

}