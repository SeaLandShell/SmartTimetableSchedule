class TextRichInfo {
  String? message;
  Map<String, dynamic>? richTexts;
  String? color;
  int? textSize;
  String? insert;
  
  TextRichInfo(
     {this.message, this.richTexts, this.color, this.textSize, this.insert});
  
  TextRichInfo.fromJson(Map<String, dynamic> json) {
   message = json["message"];
   richTexts = json["richTexts"];
   color = richTexts!['color'];
   textSize = richTexts!['textSize'];
   insert = json['insert'] ?? null;
  }
}
