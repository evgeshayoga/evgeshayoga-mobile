class VideoModel {
  String content;
  String hls;
  String iframe;
  String picture;
  String subtitle;
  String title;
  String thumbnail;

  VideoModel(
      {this.content,
      this.hls,
      this.iframe,
      this.picture,
      this.subtitle,
      this.title,
      this.thumbnail});

  VideoModel.fromObject(dynamic value)
      : content = value["content"],
        hls = value["hls"],
        iframe = value["iframe"],
        picture = value["picture"],
        subtitle = value["subtitle"],
        title = value["title"],
        thumbnail = value["thumbnail"] != null ? value["thumbnail"] : '';
}
