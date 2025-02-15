import 'package:audibrain/utils/colors.dart';
import 'package:flutter/material.dart';

class ProfileInfoPage extends StatefulWidget {
  final String label;
  final String? initialValue;
  final String? hintText;
  final Function(String) onChange;

  const ProfileInfoPage({
    super.key,
    required this.label,
    this.initialValue,
    this.hintText,
    required this.onChange,
  });

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              floatingLabelStyle: const TextStyle(color: AColors.primary),
              labelText: widget.label,
              hintText: widget.hintText,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: AColors.primary),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
            readOnly: true,
          ),
          Positioned(
            right: 10,
            top: 4,
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Change ${widget.label}'),
                    content: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          labelText: 'Enter new ${widget.label.toLowerCase()}'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.onChange(_controller.text);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Change'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'CHANGE',
                style: TextStyle(color: AColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
