import 'dart:async';
import 'dart:convert' as convert;
// 文件相关
import 'dart:io';

class EncryptUtils {

  /*
  * Base64加密
  */
  static String base64Encode(String data){
    var content = convert.utf8.encode(data);
    var digest = convert.base64Encode(content);
    return digest;
  }
  /*
  * Base64解密
  */
  static String base64Decode(String data){
    List<int> bytes = convert.base64Decode(data);
    // 网上找的很多都是String.fromCharCodes，这个中文会乱码
    //String txt1 = String.fromCharCodes(bytes);
    String result = convert.utf8.decode(bytes);
    return result;
  }

 /*
  * 通过图片路径将图片转换成Base64字符串
  */
  static Future image2Base64(String path) async {
    File file = new File(path);
    List<int> imageBytes = await file.readAsBytes();
    return convert.base64Encode(imageBytes);
  }
  
  /*
  * 将图片文件转换成Base64字符串
  */
  static Future imageFile2Base64(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    return convert.base64Encode(imageBytes);
  }

}