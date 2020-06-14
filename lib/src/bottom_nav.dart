import 'package:flutter/material.dart';

final Color defaultColor = Colors.grey[700];

final Color defaultOnSelectColor = Colors.blue;

class BottomNav extends StatefulWidget {
  final int index;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;
  final Duration animationDuration;
  final bool showElevation;
  final Color backgroundColor;
  final double navBarHeight;
  final double radius;

  BottomNav(
      {@required this.index,
      this.navBarHeight = 100.0,
      this.showElevation = true,
      @required this.onTap,
      @required this.items,
      this.animationDuration = const Duration(milliseconds: 200),
      this.backgroundColor = Colors.white,
      this.radius = 16.0})
      : assert(items != null),
        assert(items.length >= 2);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  int currentIndex;
  List<AnimationController> _controllers = [];

  @override
  void initState() {
    currentIndex = widget.index ?? 0;
    super.initState();
    for (int i = 0; i < widget.items.length; i++) {
      _controllers.add(
        AnimationController(
          vsync: this,
          duration: widget.animationDuration,
        ),
      );
    }
    // Start animation for initially selected controller.
    _controllers[widget.index].forward();
  }

  onItemClick(int i) {
    setState(() {
      currentIndex = i;
    });
    if (widget.onTap != null) widget.onTap(i);
  }

  @override
  Widget build(BuildContext context) {
    _changeValue();
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        boxShadow: [
          if (widget.showElevation)
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
            ),
        ],
      ),
      child: SafeArea(
        bottom: true,
        left: false,
        right: false,
        top: false,
        child: Container(
          height: widget.navBarHeight,
          color: widget.backgroundColor,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.items.map((element) {
                int item = widget.items.indexOf(element);
                return BottomBarItem(
                    element.icon, widget.navBarHeight, element.label, () {
                  widget.onTap(item);
                }, element.selectedColor, _controllers[item], widget.radius);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _changeValue() {
    _controllers.forEach((controller) => controller.reverse());
    _controllers[widget.index].forward();
  }

  parseLabel(String label, bool selected) {}
}

class BottomNavItem {
  final IconData icon;
  final String label;
  Color selectedColor;

  BottomNavItem(
      {@required this.icon,
      @required this.label,
      @required this.selectedColor});
}

class BottomBarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final double height;
  final VoidCallback onTap;
  final Color color;
  final AnimationController controller;
  final double radius;

  BottomBarItem(this.icon, this.height, this.label, this.onTap, this.color,
      this.controller, this.radius);

  @override
  _BottomBarItemState createState() => _BottomBarItemState();
}

class _BottomBarItemState extends State<BottomBarItem>
    with TickerProviderStateMixin {
  Animation animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      controller = AnimationController(
          vsync: this, duration: Duration(milliseconds: 200));
    } else {
      controller = widget.controller;
    }
    animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.linear),
    );

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(
            widget.color.red,
            widget.color.green,
            widget.color.blue,
            animation.value / 2.5,
          ),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(widget.icon,
                  color: widget.color, size: widget.height / 3.5),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: animation.value != 0.0
                  ? Text(
                      widget.label,
                      style: TextStyle(
                        color: widget.color,
                        fontWeight: FontWeight.bold,
                        fontSize: (widget.height / 5.5) * animation.value,
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
