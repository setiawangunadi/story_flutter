// To parse this JSON data, do
//
//     final addStoryResponseModel = addStoryResponseModelFromJson(jsonString);

import 'dart:convert';

AddStoryResponseModel addStoryResponseModelFromJson(String str) => AddStoryResponseModel.fromJson(json.decode(str));

String addStoryResponseModelToJson(AddStoryResponseModel data) => json.encode(data.toJson());

class AddStoryResponseModel {
  final bool? error;
  final String? message;

  AddStoryResponseModel({
    this.error,
    this.message,
  });

  factory AddStoryResponseModel.fromJson(Map<String, dynamic> json) => AddStoryResponseModel(
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
  };
}
