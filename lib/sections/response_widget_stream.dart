import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_assist/widgets/chat_input_box.dart';

class ResponseWidgetSection extends StatefulWidget {
  const ResponseWidgetSection({super.key});

  @override
  State<ResponseWidgetSection> createState() => _SectionTextInputStreamState();
}

class _SectionTextInputStreamState extends State<ResponseWidgetSection> {
  final controller = TextEditingController();
  final gemini = Gemini.instance;
  String? searchedText, result, _finishReason;
  bool _loading = false;

  String? get finishReason => _finishReason;
  bool get loading => _loading;

  set finishReason(String? set) {
    if (set != _finishReason) {
      setState(() => _finishReason = set);
    }
  }

  set loading(bool set) {
    if (set != loading) {
      setState(() => _loading = set);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (searchedText != null)
          MaterialButton(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.black,
              onPressed: () {
                setState(() {
                  searchedText = null;
                  result = null;
                });
              },
              child: Text('Recent search: $searchedText',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Quicksand",
                  ))),
        Expanded(
          child: loading
              ? Lottie.asset('assets/lottie/ai.json')
              : result != null
                  ? GeminiResponseTypeView(
                      builder: (context, child, response, loading) =>
                          Markdown(data: response ?? ''))
                  : const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Text(
                          "I'm all ears (though I only have circuits, no actual ears). What's going on?",
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: "Quicksand",
                          ),
                        ),
                      ),
                    ),
        ),
        if (finishReason != null)
          Text(
            finishReason!,
            style: const TextStyle(
              fontFamily: "Quicksand",
            ),
          ),
        ChatInputBox(
          controller: controller,
          onSend: () {
            if (controller.text.isNotEmpty) {
              searchedText = controller.text;
              controller.clear();
              loading = true;
              result = null;
              finishReason = null;

              gemini
                  .streamGenerateContent(searchedText!,
                      generationConfig: GenerationConfig(
                        maxOutputTokens: 2000,
                        temperature: 0.9,
                        topP: 0.1,
                        topK: 16,
                      ))
                  .listen((value) {
                result = (result ?? '') + (value.output ?? '');

                if (value.finishReason != 'STOP') {
                  finishReason = 'Finish reason is `RECITATION`';
                }
                loading = false;
              });
            }
          },
        ),
      ],
    );
  }
}
