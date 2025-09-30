import 'package:Kootumb/models/video_format.dart';

class OBVideoFormatsList {
  final List<OBVideoFormat>? videoFormats;

  OBVideoFormatsList({
    this.videoFormats,
  });

  factory OBVideoFormatsList.fromJson(List<dynamic> parsedJson) {
    List<OBVideoFormat> videoFormats = parsedJson
        .map((videoFormatJson) => OBVideoFormat.fromJSON(videoFormatJson))
        .toList();

    return OBVideoFormatsList(
      videoFormats: videoFormats,
    );
  }
}
