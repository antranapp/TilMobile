import 'package:til/utils/datetime.dart';
import 'package:til/settings//settings.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

import 'md_yaml_doc.dart';
import 'note.dart';

abstract class NoteSerializerInterface {
    void encode(Note note, MdYamlDoc data);
    void decode(MdYamlDoc data, Note note);
}

var emojiParser = EmojiParser();

class NoteSerializationSettings {
    String updatedAtKey = Settings.instance.yamlUpdatedAtKey;
    String createdAtKey = Settings.instance.yamlCreatedAtKey;
    String titleKey = "title";
}

class NoteSerializer implements NoteSerializerInterface {
    var settings = NoteSerializationSettings();

    @override
    void encode(Note note, MdYamlDoc data) {
        if (note.created != null) {
            data.props[settings.createdAtKey] = toIso8601WithTimezone(note.created);
        } else {
            data.props.remove(settings.createdAtKey);
        }

        if (note.modified != null) {
            data.props[settings.updatedAtKey] = toIso8601WithTimezone(note.modified);
        } else {
            data.props.remove(settings.updatedAtKey);
        }

        if (note.title != null) {
            var title = note.title.trim();
            if (title.isNotEmpty) {
                data.props[settings.titleKey] = emojiParser.unemojify(note.title);
            } else {
                data.props.remove(settings.titleKey);
            }
        } else {
            data.props.remove(settings.titleKey);
        }

        data.body = emojiParser.unemojify(note.body);
    }

    @override
    void decode(MdYamlDoc data, Note note) {
        var modifiedKeyOptions = [
            "modified",
            "mod",
            "lastModified",
            "lastMod",
            "lastmodified",
            "lastmod",
        ];
        for (var i = 0; i < modifiedKeyOptions.length; i++) {
            var possibleKey = modifiedKeyOptions[i];
            var modifiedVal = data.props[possibleKey];
            if (modifiedVal != null) {
                note.modified = parseDateTime(modifiedVal.toString());
                settings.updatedAtKey = possibleKey;
                break;
            }
        }

        note.body = emojiParser.emojify(data.body);
        note.created = parseDateTime(data.props[settings.createdAtKey]?.toString());

        var title = data.props[settings.titleKey]?.toString() ?? "";
        note.title = emojiParser.emojify(title);
    }
}
