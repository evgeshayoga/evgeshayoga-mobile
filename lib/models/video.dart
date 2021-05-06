class VideoModel {
  String content;
  String hls;
  String iframe;
  String picture;
  String subtitle;
  String title;
  String thumbnail;

  VideoModel.fromObject(dynamic value)
      : content = value["content"],
        hls = value["hls"],
        iframe = value["iframe"],
        picture = value["picture"],
        subtitle = value["subtitle"],
        title = value["title"],
        thumbnail = value["thumbnail"] ?? '';
}
