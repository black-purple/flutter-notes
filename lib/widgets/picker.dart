import 'package:flutter/cupertino.dart';

class MyCupertinoDropdown extends StatefulWidget {
  const MyCupertinoDropdown({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyCupertinoDropdownState createState() => _MyCupertinoDropdownState();
}

class _MyCupertinoDropdownState extends State<MyCupertinoDropdown> {
  bool _isDropdownOpen = false;
  final List<String> _buttonTitles = ['Button 1', 'Button 2', 'Button 3'];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Dropdown Example'),
        trailing: CupertinoButton(
          onPressed: () {
            setState(() {
              _isDropdownOpen = !_isDropdownOpen;
            });
          },
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.ellipsis),
        ),
      ),
      child: Stack(
        children: [
          const Center(
            child: Text('Main Content'),
          ),
          if (_isDropdownOpen)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isDropdownOpen = false;
                });
              },
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.3),
              ),
            ),
          if (_isDropdownOpen)
            Positioned(
              top: 56.0,
              right: 8.0,
              child: SizedBox(
                width: 150.0,
                child: CupertinoPopupSurface(
                  child: Column(
                    children: _buttonTitles.map((title) {
                      return CupertinoButton(
                        onPressed: () {
                          setState(() {
                            _isDropdownOpen = false;
                          });
                          // Perform actions based on the button tap
                          print('Button tapped: $title');
                        },
                        child: Text(title),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
