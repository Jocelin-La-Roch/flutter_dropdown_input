library dropdown_input;

import 'package:flutter/material.dart';


class DropdownInput extends StatefulWidget {
  const DropdownInput({super.key});

  @override
  State<DropdownInput> createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput>{

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          ExpansionWidget(
            title: const Text("OK"),
            listOptionsHeight: 100.0,
            onItemSelected: (item) {
              print(item);
            },
            children: const [
              ListTile(title: Text("ok 1"),),
              ListTile(title: Text("ok 2"),),
              ListTile(title: Text("ok 3"),)
            ],
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
          )
        ],
      ),
    );
  }
}

const Duration _kExpand = Duration(milliseconds: 200);

class ExpansionWidget extends StatefulWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final ValueChanged<bool>? onExpansionChanged;
  final List<Widget> children;
  final Color? backgroundColor;
  final Color? collapsedBackgroundColor;
  final Widget? trailing;
  final bool initiallyExpanded;
  final bool maintainState;
  final EdgeInsetsGeometry? tilePadding;
  final Alignment? expandedAlignment;
  final CrossAxisAlignment? expandedCrossAxisAlignment;
  final EdgeInsetsGeometry? childrenPadding;
  final Color? iconColor;
  final Color? collapsedIconColor;
  final Color? textColor;
  final Color? collapsedTextColor;
  final ShapeBorder? shape;
  final ShapeBorder? collapsedShape;
  final Clip? clipBehavior;
  final ListTileControlAffinity? controlAffinity;
  final double listOptionsHeight;
  final ValueChanged<Map<String, dynamic>>? onItemSelected;
  // final bool isExpanded;

  const ExpansionWidget({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.tilePadding,
    this.expandedCrossAxisAlignment,
    this.expandedAlignment,
    this.childrenPadding,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.textColor,
    this.collapsedTextColor,
    this.iconColor,
    this.collapsedIconColor,
    this.shape,
    this.collapsedShape,
    this.clipBehavior,
    this.controlAffinity,
    // required this.isExpanded,
    required this.listOptionsHeight,
    this.onItemSelected
  }) : assert (
  expandedCrossAxisAlignment != CrossAxisAlignment.baseline,
  'CrossAxisAlignment.baseline is not supported since the expanded children '
      'are aligned in a column, not a row. Try to use another constant.',
  );

  @override
  State<ExpansionWidget> createState() => _ExpansionWidgetState();
}

class _ExpansionWidgetState extends State<ExpansionWidget> with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween = CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);

  final ShapeBorderTween _borderTween = ShapeBorderTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<ShapeBorder?> _border;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  TextEditingController textEditingController = TextEditingController();

  List<Map<String, dynamic>> optionsList = [
    {
      "name": "jojo",
      "id": "1"
    },
    {
      "name": "jocelin",
      "id": "2"
    },
    {
      "name": "laroch",
      "id": "3"
    },
    {
      "name": "linda",
      "id": "4"
    }
  ];

  List<Map<String, dynamic>> optionsListFiltered = [
    {
      "name": "jojo",
      "id": "1"
    },
    {
      "name": "jocelin",
      "id": "2"
    },
    {
      "name": "laroch",
      "id": "3"
    },
    {
      "name": "linda",
      "id": "4"
    }
  ];

  List<Widget> optionListWidget() {
    if(textEditingController.text != "") {
      return optionsListFiltered.map((e) => ListTile(title: Text(e["name"]),)).toList();
    } else {
      return [
        const ListTile(title: Text("No result"),)
      ];
    }
  }

  void setOptionListWidget () {
    if (textEditingController.text != "") {
      setState(() {
        _isExpanded = true;
        _controller.forward();
      });
      List<Map<String, dynamic>> temp = [];
      for (var element in optionsList) {
        if(element["name"].toString().contains(textEditingController.text)) {
          temp.add(element);
        }
      }
      setState(() {
        optionsListFiltered = temp;
      });
    } else {
      setState(() {
        _isExpanded = false;
        _controller.reverse().then<void>((void value) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Rebuild without widget.children.
          });
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _border = _controller.drive(_borderTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor = _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    if (_isExpanded) {
      _controller.value = 1.0;
    }

    textEditingController.addListener(setOptionListWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      // PageStorage.maybeOf(context)?.writeState(context, _isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  // Platform or null affinity defaults to trailing.
  ListTileControlAffinity _effectiveAffinity(ListTileControlAffinity? affinity) {
    switch (affinity ?? ListTileControlAffinity.trailing) {
      case ListTileControlAffinity.leading:
        return ListTileControlAffinity.leading;
      case ListTileControlAffinity.trailing:
      case ListTileControlAffinity.platform:
        return ListTileControlAffinity.trailing;
    }
  }

  Widget? _buildIcon(BuildContext context) {
    return RotationTransition(
      turns: _iconTurns,
      child: IconButton(
        onPressed: () {
          setState(() {
            optionsListFiltered = optionsList;
          });
          _handleTap();
        },
        icon: const Icon(Icons.expand_more),
      ),
    );
  }

  Widget? _buildLeadingIcon(BuildContext context) {
    if (_effectiveAffinity(widget.controlAffinity) != ListTileControlAffinity.leading) {
      return null;
    }
    return _buildIcon(context);
  }

  Widget? _buildTrailingIcon(BuildContext context) {
    if (_effectiveAffinity(widget.controlAffinity) != ListTileControlAffinity.trailing) {
      return null;
    }
    return _buildIcon(context);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final ExpansionTileThemeData expansionTileTheme = ExpansionTileTheme.of(context);
    final ShapeBorder expansionTileBorder = _border.value ?? const Border(
      top: BorderSide(color: Colors.transparent),
      bottom: BorderSide(color: Colors.transparent),
    );
    final Clip clipBehavior = widget.clipBehavior ?? Clip.none;

    return Container(
      clipBehavior: clipBehavior,
      decoration: ShapeDecoration(
        color: _backgroundColor.value ?? expansionTileTheme.backgroundColor ?? Colors.transparent,
        shape: expansionTileBorder,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTileTheme.merge(
            iconColor: _iconColor.value ?? expansionTileTheme.iconColor,
            textColor: _headerColor.value,
            child: ListTile(
              // onTap: _handleTap,
              contentPadding: widget.tilePadding ?? expansionTileTheme.tilePadding,
              leading: widget.leading ?? _buildLeadingIcon(context),
              // title: widget.title,
              title: TextFormField(
                controller: textEditingController,
                decoration: InputDecoration(
                    hintText: "Search",
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: (){
                          textEditingController.text = "";
                        }
                    )
                ),
              ),
              subtitle: widget.subtitle,
              trailing: widget.trailing ?? _buildTrailingIcon(context),
            ),
          ),
          ClipRect(
            child: Align(
              alignment: widget.expandedAlignment
                  ?? expansionTileTheme.expandedAlignment
                  ?? Alignment.center,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme = ExpansionTileTheme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    _borderTween
      ..begin = widget.collapsedShape
          ?? const Border(
            top: BorderSide(color: Colors.transparent),
            bottom: BorderSide(color: Colors.transparent),
          )
      ..end = widget.shape
          ?? Border(
            top: BorderSide(color: theme.dividerColor),
            bottom: BorderSide(color: theme.dividerColor),
          );
    _headerColorTween
      ..begin = widget.collapsedTextColor
          ?? expansionTileTheme.collapsedTextColor
          ?? theme.textTheme.titleMedium!.color
      ..end = widget.textColor ?? expansionTileTheme.textColor ?? colorScheme.primary;
    _iconColorTween
      ..begin = widget.collapsedIconColor
          ?? expansionTileTheme.collapsedIconColor
          ?? theme.unselectedWidgetColor
      ..end = widget.iconColor ?? expansionTileTheme.iconColor ?? colorScheme.primary;
    _backgroundColorTween
      ..begin = widget.collapsedBackgroundColor ?? expansionTileTheme.collapsedBackgroundColor
      ..end = widget.backgroundColor ?? expansionTileTheme.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ExpansionTileThemeData expansionTileTheme = ExpansionTileTheme.of(context);
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: widget.childrenPadding ?? expansionTileTheme.childrenPadding ?? EdgeInsets.zero,
          child: SizedBox(
            height: 100.0,
            child: optionsListFiltered.isNotEmpty ?
            ListView.builder(
              itemCount: optionsListFiltered.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(optionsListFiltered[index]["name"]),
                  onTap: () {
                    textEditingController.text = optionsListFiltered[index]["name"];
                    _handleTap();
                    widget.onItemSelected?.call(optionsListFiltered[index]);
                  },
                );
              },
              // children: widget.children,
              //children: optionsListFiltered.map((e) => ListTile(title: Text(e["name"]),)).toList(),
            ) :
            const ListTile(title: Text("No result"),),
          ),
          /*child: Column(
            crossAxisAlignment: widget.expandedCrossAxisAlignment ?? CrossAxisAlignment.center,
            children: widget.children,
          ),*/
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}

