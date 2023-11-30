// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appbar_tab_explore": MessageLookupByLibrary.simpleMessage("Explore"),
        "appbar_tab_home": MessageLookupByLibrary.simpleMessage("Home"),
        "appbar_tab_library": MessageLookupByLibrary.simpleMessage("Library"),
        "drawer_tile_setting": MessageLookupByLibrary.simpleMessage("Settings"),
        "drawer_tile_user": MessageLookupByLibrary.simpleMessage("Profile"),
        "loginWithEmail":
            MessageLookupByLibrary.simpleMessage("Login with Email"),
        "loginWithPhone":
            MessageLookupByLibrary.simpleMessage("Login with Phone"),
        "login_loginText":
            MessageLookupByLibrary.simpleMessage("Login to Netease"),
        "login_qr_tip": MessageLookupByLibrary.simpleMessage(
            "Open the Netease APP and scan the code to log in")
      };
}
