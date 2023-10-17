import 'package:hive/hive.dart';

part 'article.g.dart';

@HiveType(typeId: 0)
class Article extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String date;
  @HiveField(2)
  String title;
  @HiveField(3)
  String desc;
  @HiveField(4)
  String content;
  @HiveField(5)
  String link;
  @HiveField(6)
  String imageUrl;

  Article({required this.id,
    required this.date,
    required this.title,
    required this.desc,
    required this.content,
    required this.link,
    required this.imageUrl});
}
