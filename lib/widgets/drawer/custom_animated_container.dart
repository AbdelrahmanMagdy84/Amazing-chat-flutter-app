import 'package:flutter/material.dart';

class AnimatedContainerBuilder extends StatefulWidget {
  final AnimationController? _animController;

  final Future<void> Function(
      Function(TextEditingController usernameController) validate,
      TextEditingController usernameController) saveUsername;
  const AnimatedContainerBuilder(this._animController, this.saveUsername,
      {Key? key})
      : super(key: key);

  @override
  State<AnimatedContainerBuilder> createState() =>
      _AnimatedContainerBuilderState();
}

class _AnimatedContainerBuilderState extends State<AnimatedContainerBuilder> {
  String? error;
  late AnimationController _animationController;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _opacityAnimation;
  final usernameController = TextEditingController();
  bool showInputWidget = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = widget._animController!;
    _positionAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0))
            .animate(CurvedAnimation(
                parent: _animationController, curve: Curves.easeInOutBack));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutBack));
  }

  bool validate(TextEditingController usernameController) {
    if (usernameController.text.isEmpty) {
      setState(() {
        error = "can't be empty";
      });
      return false;
    }
    if (usernameController.text.length < 5) {
      setState(() {
        error = "At least 5 characters";
      });
      return false;
    }

    error = null;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(
            position: _positionAnimation,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 70,
                      child: TextField(
                        controller: usernameController,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.text,
                        maxLength: 18,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          errorText: error,
                          label: Container(
                            alignment: Alignment.center,
                            child: const Text("New Username"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      child: FittedBox(
                        child: !isLoading
                            ? Text(
                                "Save",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              )
                            : Padding(
                              padding:const EdgeInsets.all(5),
                              child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.secondary,
                                                          ),
                            ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await widget.saveUsername(validate, usernameController);
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
