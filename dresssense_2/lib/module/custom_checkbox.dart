import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const CustomCheckbox(
      {super.key, this.initialValue = false, this.onChanged});

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  void _toggleCheckbox() {
    setState(() {
      isChecked = !isChecked;
    });

    if (widget.onChanged != null) {
      widget.onChanged!(isChecked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: GestureDetector(
        onTap: _toggleCheckbox,
        child: Container(
          width: 25.0,
          height: 25.0,
          decoration: BoxDecoration(
            color: isChecked ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0), // Border-radius untuk checkbox
            border: Border.all(
              color: Colors.black, // Warna garis border menjadi hitam
              width: 1.5,
            ),
          ),
          child: isChecked
              ? Icon(
            Icons.check,
            color: Colors.white,
            size: 20.0,
          )
              : null,
        ),
      ),
    );
  }
}
