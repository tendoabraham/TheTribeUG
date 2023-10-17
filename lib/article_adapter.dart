import 'package:hive/hive.dart';
import 'article.dart'; // Replace 'your_article_class.dart' with the actual import for your 'Article' class

class ArticleAdapter extends TypeAdapter<Article> {
  @override
  final int typeId = 0; // Unique identifier for your Article class

  @override
  Article read(BinaryReader reader) {
    return Article(
      id: reader.readInt(),
      date: reader.readString(),
      title: reader.readString(),
      desc: reader.readString(),
      content: reader.readString(),
      link: reader.readString(),
      imageUrl: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Article obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.date);
    writer.writeString(obj.title);
    writer.writeString(obj.desc);
    writer.writeString(obj.content);
    writer.writeString(obj.link);
    writer.writeString(obj.imageUrl);
  }
}
