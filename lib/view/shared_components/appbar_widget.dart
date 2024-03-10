import 'package:flutter/material.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:flutter/services.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    required this.content,
    this.leading,
  });

  final Widget content;
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(70);

  static const double leadingSize = 44;

  @override
  Widget build(context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      excludeHeaderSemantics: true,
      centerTitle: true,
      title: SizedBox(
        height: leadingSize,
        child: content,
      ),
      leading: Padding(
        padding: StyleConstants.edgeInsetsL8,
        child: leading ??
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: ClipRRect(
                borderRadius: StyleConstants.radius100,
                child: Image.asset("assets/images/dj_sona_icon_2.png"),
              ),
            ),
      ),
      leadingWidth: leadingSize + 8,
      titleSpacing: 8,
      toolbarHeight: preferredSize.height,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/overlay.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
