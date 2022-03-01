import 'package:xml/src/xml/nodes/document.dart';

import '../file_updater.dart';

class XmlAttribute implements UpdateRule {
  XmlAttribute(this.key, this.value);

  final String key;
  final String value;
  bool previousLineMatchedKey = false;
  bool changed = false;

  @override
  bool update(List<String> _data, XmlDocument xml) {
    for (int x = 0; x < _data.length; x++) {
      String line = _data[x];
      if (line.contains('<key>$key</key>')) {
        previousLineMatchedKey = true;
        changed = true;
        _data[x] = line;
        break;
      }
      if (!previousLineMatchedKey) {
        _data[x] = line;
        break;
      } else {
        previousLineMatchedKey = false;
        _data[x] = line.replaceAll(
            RegExp(r'<string>[^<]*</string>'), '<string>$value</string>');
        break;
      }
    }
    return true;
    // return line.replaceAllMapped(RegExp('($key[ ]*=[ ]*)"[a-zA-Z-_0-9.]*"'),
    //     (Match match) => '${match[1]}"$value"');
    return true;
  }

  @override
  bool addXml(XmlDocument document) {
    return true;
  }

  @override
  String getKey() {
    return key;
  }

  @override
  String getValue() {
    return value;
  }

  @override
  bool hasChanged() {
    return changed;
  }

  @override
  bool isXmlFile() {
    return true;
  }


  @override
  bool xmlHasKey(XmlDocument document) {
    return true;
  }
}
