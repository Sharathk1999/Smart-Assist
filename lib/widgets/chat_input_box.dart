import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class ChatInputBox extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onSend, onClickCamera;

  const ChatInputBox({
    super.key,
    this.controller,
    this.onSend,
    this.onClickCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      surfaceTintColor: Colors.black.withOpacity(0.4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (onClickCamera != null)
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                  onPressed: onClickCamera,
                  color: Theme.of(context).colorScheme.onSecondary,
                  icon: const Icon(Icons.folder_rounded,color: Colors.black,),),
            ),
          Expanded(
              child: TextField(
            controller: controller,
            minLines: 1,
            maxLines: 6,
            cursorColor: Theme.of(context).colorScheme.inversePrimary,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              hintText: '   Talk to Smart Assist',
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              border: InputBorder.none,
            ),
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
          )),
          Padding(
            padding: const EdgeInsets.all(4),
            child: FloatingActionButton.small(
              backgroundColor: Colors.black,
              onPressed: onSend,
              child: FadeInLeft(child: const Icon(Icons.screen_search_desktop_rounded,color: Colors.white,)),
            ),
          )
        ],
      ),
    );
  }
}
