class VideoModel {
  final String content;
  final String hls;
  final  String iframe;
  final String picture;
  final String subtitle;
  final String title;
  final String thumbnail;

  VideoModel.fromObject(dynamic value)
      : content = value["content"],
        hls = value["hls"],
        iframe = value["iframe"],
        picture = value["picture"],
        subtitle = value["subtitle"],
        title = value["title"],
        thumbnail = value["thumbnail"] ?? '';
}
