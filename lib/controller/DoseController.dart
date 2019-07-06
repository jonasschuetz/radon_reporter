import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:radon_reporter/model/Room.dart' as Room;
import 'package:radon_reporter/controller/QRController.dart' as QRController;
import 'package:radon_reporter/controller/StayController.dart' as StayController;




Future<StayController.StayParse> getLastStay (int id) async {
  var stay = await StayController.fetchAndParseStay(id);
  return stay.first;
}