import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_assist/widgets/chat_input_box.dart';

class SectionEmbedContent extends StatefulWidget {
  const SectionEmbedContent({super.key});

  @override
  State<SectionEmbedContent> createState() => _SectionEmbedContentState();
}

class _SectionEmbedContentState extends State<SectionEmbedContent> {
  final controller = TextEditingController();
  final gemini = Gemini.instance;
  String? searchedText;
  List<num>? result;
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool set) => setState(() => _loading = set);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (searchedText != null)
          MaterialButton(
              elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
              color: Colors.black,
              onPressed: () {
                setState(() {
                  searchedText = null;
                  result = null;
                });
              },
              child: Text('Recent search: $searchedText',style: const TextStyle(color: Colors.white))),
        Expanded(
            child: loading
                ? Lottie.asset('assets/lottie/ai.json')
                : result != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                            child: Text(result?.toString() ?? '')),
                      )
                    : const Center(
                              child: Text("I'm all ears (though I only have circuits, no actual ears). What's going on?"),
                            ),),
        ChatInputBox(
          controller: controller,
          onSend: () {
            if (controller.text.isNotEmpty) {
              searchedText = controller.text;
              controller.clear();
              loading = true;

              gemini.embedContent(searchedText!).then((value) {
                result = value;
                loading = false;
              });
            }
          },
        ),
      ],
    );
  }
}
