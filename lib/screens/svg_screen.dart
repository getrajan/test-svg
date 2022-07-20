import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

class SvgScreen extends StatefulWidget {
  const SvgScreen({Key? key}) : super(key: key);

  @override
  State<SvgScreen> createState() => _SvgScreenState();
}

class _SvgScreenState extends State<SvgScreen> {
  void loadSvg() async {}

  String svgRawString = "";

  @override
  void initState() {
    super.initState();
    // dowloadSVG();
    readSVGFromFileStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Column(
          children: [
            // SvgPicture.string(Constants.rawSvg),
            if (svgRawString.isEmpty)
              const SizedBox.shrink()
            else
              Expanded(child: SvgPicture.string(svgRawString)),

            // SvgPicture.svgStringDecoderBuilder
          ],
        ),
      ),
    );
  }

  tryReplaceXml(String data) async {
    print('xmlDocument');

// final document = XmlDocument.parse(data);

    final document = XmlDocument.parse(data);

    var elements = document.getElement('svg')!.findAllElements('text');

    for (var i in elements) {
      var pri = i.findAllElements('tspan');

      if (pri.isEmpty) {
        log(pri.toString());
      } else {
        for (var list in pri) {
          var baseDetonating = list.getAttribute('class');

          if (baseDetonating == "base_detonating") {
            list.setAttribute('font-size', '200');

            list.innerText = 'new value';
          }
        }
      }
    }

    log(document.toXmlString());
    setState(() {
      svgRawString = document.toXmlString();
    });
    return document.toXmlString();
  }

  void dowloadSVG() async {
    final dio = Dio();
    try {
      String url =
          "https://api.hi-eo.pegotec.dev/storage/eo/images/7_20220714083815.svg";
      var dir = await getApplicationDocumentsDirectory();
      if (!await dir.exists()) {
        dir.create();
      }
      final response = await dio.download(url, '${dir.path}/test.svg');
      print(response.data);
      print(response.statusCode);
    } catch (e) {
      print(e.toString());
    }
  }

  void readSVGFromFileStorage() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      log("*****$contents");
     await  tryReplaceXml(contents);
    } catch (e) {
      // If encountering an error, return 0
      print(e.toString());
    }
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/test.svg');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
