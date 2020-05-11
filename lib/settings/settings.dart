import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:til/base/note_filename_format.dart';

class Settings {
    static List<Function> changeObservers = [];

    // singleton
    static final Settings _singleton = Settings._internal();
    factory Settings() => _singleton;
    Settings._internal();
    static Settings get instance => _singleton;

    // Properties
    String gitAuthor = "Til";
    String gitAuthorEmail = "email@example.com";

    NoteFileNameFormat noteFileNameFormat;

    String yamlUpdatedAtKey = "updatedAt";
    String yamlCreatedAtKey = "createdAt";

    RemoteSyncFrequency remoteSyncFrequency = RemoteSyncFrequency.Default;
    int version = 0;

    SettingsMarkdownDefaultView markdownDefaultView = SettingsMarkdownDefaultView.Default;


    String _pseudoId;
    String get pseudoId => _pseudoId;

    void load(SharedPreferences pref) {
        gitAuthor = pref.getString("gitAuthor") ?? gitAuthor;
        gitAuthorEmail = pref.getString("gitAuthorEmail") ?? gitAuthorEmail;

        remoteSyncFrequency = RemoteSyncFrequency.fromInternalString(pref.getString("remoteSyncFrequency"));

        version = pref.getInt("settingsVersion") ?? version;

        _pseudoId = pref.getString("pseudoId");
        if (_pseudoId == null) {
            _pseudoId = Uuid().v4();
            pref.setString("pseudoId", _pseudoId);
        }
    }

    Future save() async {
        var pref = await SharedPreferences.getInstance();
        pref.setString("gitAuthor", gitAuthor);
        pref.setString("gitAuthorEmail", gitAuthorEmail);
        pref.setString("remoteSyncFrequency", remoteSyncFrequency.toInternalString());
        pref.setInt("settingsVersion", version);

        // Shouldn't we check if something has actually changed?
        for (var f in changeObservers) {
            f();
        }
    }

    Map<String, String> toMap() {
        return <String, String>{
            "gitAuthor": gitAuthor,
            "gitAuthorEmail": gitAuthorEmail,
            "remoteSyncFrequency": remoteSyncFrequency.toInternalString(),
            "version": version.toString(),
            'pseudoId': pseudoId,
        };
    }

    Map<String, String> toLoggableMap() {
        var m = toMap();
        m.remove("gitAuthor");
        m.remove("gitAuthorEmail");
        m.remove("defaultNewNoteFolderSpec");
        return m;
    }
}

class RemoteSyncFrequency {
    static const Automatic = RemoteSyncFrequency("Automatic");
    static const Manual = RemoteSyncFrequency("Manual");
    static const Default = Automatic;

    final String _str;
    const RemoteSyncFrequency(this._str);

    String toInternalString() {
        return _str;
    }

    String toPublicString() {
        return _str;
    }

    static const options = <RemoteSyncFrequency>[
        Automatic,
        Manual,
    ];

    static RemoteSyncFrequency fromInternalString(String str) {
        for (var opt in options) {
            if (opt.toInternalString() == str) {
                return opt;
            }
        }
        return Default;
    }

    static RemoteSyncFrequency fromPublicString(String str) {
        for (var opt in options) {
            if (opt.toPublicString() == str) {
                return opt;
            }
        }
        return Default;
    }

    @override
    String toString() {
        assert(false, "RemoteSyncFrequency toString should never be called");
        return "";
    }
}

class SettingsMarkdownDefaultView {
    static const Edit = SettingsMarkdownDefaultView("Edit");
    static const View = SettingsMarkdownDefaultView("View");
    static const Default = View;

    final String _str;
    const SettingsMarkdownDefaultView(this._str);

    String toInternalString() {
        return _str;
    }

    String toPublicString() {
        return _str;
    }

    static const options = <SettingsMarkdownDefaultView>[
        Edit,
        View,
    ];

    static SettingsMarkdownDefaultView fromInternalString(String str) {
        for (var opt in options) {
            if (opt.toInternalString() == str) {
                return opt;
            }
        }
        return Default;
    }

    static SettingsMarkdownDefaultView fromPublicString(String str) {
        for (var opt in options) {
            if (opt.toPublicString() == str) {
                return opt;
            }
        }
        return Default;
    }

    @override
    String toString() {
        assert(
        false, "SettingsMarkdownDefaultView toString should never be called");
        return "";
    }
}