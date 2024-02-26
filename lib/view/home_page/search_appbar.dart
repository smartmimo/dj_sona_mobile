import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/utils/string_utils.dart';
import 'package:djsona_mobile/view/shared_components/loading_widget.dart';
import 'package:djsona_mobile/view/shared_components/txt_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppbar({
    super.key,
    required this.onChanged,
    required this.isLoading,
  });

  final Function(String?) onChanged;
  final bool isLoading;
  @override
  Size get preferredSize => const Size.fromHeight(70);

  static const double _searchBarHeight = 44;
  static const double _textFieldIconsSize = 20;
  static final TextEditingController textController = TextEditingController();

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
      title: TxtFormField(
        controller: textController,
        labeltext: "Search for a song",
        prefixIcon: const Icon(IconConstants.search, size: _textFieldIconsSize),
        suffixIcon: _getPrefixIcon(context),
        borderRadius: StyleConstants.radius100,
        borderColor: Colors.transparent,
        textFieldHeight: _searchBarHeight,
        onChanged: onChanged,
      ),
      leading: Padding(
        padding: StyleConstants.edgeInsetsL8,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: ClipRRect(
            borderRadius: StyleConstants.radius100,
            child: Image.asset("assets/images/dj_sona_icon_2.png"),
          ),
        ),
      ),
      leadingWidth: _searchBarHeight + 8,
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

  Widget? _getPrefixIcon(context) {
    if (isLoading) {
      return const SizedBox(
        width: _textFieldIconsSize,
        height: _textFieldIconsSize,
        child: LoadingWidget(),
      );
    } else if (StringUtils.isNotEmpty(textController.text)) {
      return Material(
        type: MaterialType.transparency,
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: _textFieldIconsSize,
          height: _textFieldIconsSize,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              textController.clear();
              onChanged(null);
            },
            icon: const Icon(IconConstants.close, size: _textFieldIconsSize),
            splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
          ),
        ),
      );
    } else {
      return null;
    }
  }
}
