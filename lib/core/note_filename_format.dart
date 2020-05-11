class NoteFileNameFormat {
    static const Iso8601WithTimeZone =
    NoteFileNameFormat("Iso8601WithTimeZone", "ISO8601 With TimeZone");
    static const Iso8601 = NoteFileNameFormat("Iso8601", "Iso8601");
    static const Iso8601WithTimeZoneWithoutColon = NoteFileNameFormat("Iso8601WithTimeZoneWithoutColon", "ISO8601 without Colons");
    static const FromTitle = NoteFileNameFormat("FromTitle", "Title");
    static const SimpleDate =
    NoteFileNameFormat("SimpleDate", "yyyy-mm-dd-hh-mm-ss");

    static const Default = FromTitle;

    static const options = <NoteFileNameFormat>[
        SimpleDate,
        FromTitle,
        Iso8601,
        Iso8601WithTimeZone,
        Iso8601WithTimeZoneWithoutColon,
    ];

    static NoteFileNameFormat fromInternalString(String str) {
        for (var opt in options) {
            if (opt.toInternalString() == str) {
                return opt;
            }
        }
        return Default;
    }

    static NoteFileNameFormat fromPublicString(String str) {
        for (var opt in options) {
            if (opt.toPublicString() == str) {
                return opt;
            }
        }
        return Default;
    }

    final String _str;
    final String _publicStr;

    const NoteFileNameFormat(this._str, this._publicStr);

    String toInternalString() {
        return _str;
    }

    String toPublicString() {
        return _publicStr;
    }

    @override
    String toString() {
        assert(false, "NoteFileNameFormat toString should never be called");
        return "";
    }
}