
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:smart_assist/sections/stream.dart';
import 'package:smart_assist/sections/text_and_image.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  Gemini.init(apiKey: dotenv.env["GEMINI_KEY"]!, enableDebugging: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Assist',
    
      debugShowCheckedModeBanner: false,
     
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
          
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          cardTheme: CardTheme(color: Colors.blue.shade900)),
      home: const MyHomePage(),
    );
  }
}

class SectionItem {
  final int index;
  final String title;
  final Widget widget;

  SectionItem(this.index, this.title, this.widget);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedItem = 0;

  final _sections = <SectionItem>[
    SectionItem(0, 'Flow Chat', const SectionTextStreamInput()),
    SectionItem(1, 'Image-Enriched Chat', const SectionTextAndImageInput()),
    // SectionItem(2, 'Chat', const SectionChat()),
    // SectionItem(3, 'Chat', const SectionTextInput()),
    // SectionItem(4, 'Embed Content Chat', const SectionEmbedContent()),
    // SectionItem(5, 'Batch Embed Contents Chat', const SectionBatchEmbedContents()),
    // SectionItem(
    //     6, 'response without setState()', const ResponseWidgetSection()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(_selectedItem == 0
            ? 'Smart Assist'
            : _sections[_selectedItem].title,style: const TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w600,
            ),),
        actions: [
          PopupMenuButton<int>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            splashRadius: 12,
            surfaceTintColor: const Color.fromARGB(255, 60, 59, 59),
            initialValue: _selectedItem,
            onSelected: (value) => setState(() => _selectedItem = value),
            itemBuilder: (context) => _sections.map((e) {
              return PopupMenuItem<int>(value: e.index, child: Text(e.title));
            }).toList(),
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.menu_rounded),
            ),
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedItem,
        children: _sections.map((e) => e.widget).toList(),
      ),
    );
  }
}
