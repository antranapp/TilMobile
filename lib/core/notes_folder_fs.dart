import 'dart:io';

import 'package:til/utils/logger.dart';

import 'package:path/path.dart' as p;
import 'package:path/path.dart';
import 'package:synchronized/synchronized.dart';

import 'note.dart';
import 'notes_folder.dart';
import 'notes_folder_notifier.dart';

class NotesFolderFS with NotesFolderNotifier implements NotesFolder {
    final NotesFolderFS _parent;
    String _folderPath;
    var _lock = Lock();

    List<Note> _notes = [];
    List<NotesFolderFS> _folders = [];

    Map<String, dynamic> _entityMap = {};

    NotesFolderFS(this._parent, this._folderPath);

    @override
    void dispose() {
        _folders.forEach((f) => f.removeListener(_entityChanged));
        _notes.forEach((f) => f.removeListener(_entityChanged));

        super.dispose();
    }

    @override
    NotesFolder get parent => _parent;

    NotesFolderFS get parentFS => _parent;

    void _entityChanged() {
        notifyListeners();
    }

    String get folderPath => _folderPath;

    @override
    bool get isEmpty {
        return _notes.isEmpty && _folders.isEmpty;
    }

    @override
    String get name => basename(folderPath);

    bool get hasSubFolders {
        return _folders.isNotEmpty;
    }

    @override
    bool get hasNotes {
        return _notes.isNotEmpty;
    }

    bool get hasNotesRecursive {
        if (_notes.isNotEmpty) {
            return true;
        }

        for (var folder in _folders) {
            if (folder.hasNotesRecursive) {
                return true;
            }
        }
        return false;
    }

    int get numberOfNotes {
        return _notes.length;
    }

    @override
    List<Note> get notes {
        return _notes;
    }

    @override
    List<NotesFolder> get subFolders => subFoldersFS;

    List<NotesFolderFS> get subFoldersFS {
        // FIXME: This is really not ideal
        _folders.sort((NotesFolderFS a, NotesFolderFS b) =>
            a.folderPath.compareTo(b.folderPath));
        return _folders;
    }

    // FIXME: This asynchronously loads everything. Maybe it should just list them, and the individual _entities
    //        should be loaded as required?
    Future<void> loadRecursively() async {
        const maxParallel = 10;
        var futures = <Future>[];

        await load();

        for (var note in _notes) {
            // FIXME: Collected all the Errors, and report them back, along with "WHY", and the contents of the Note
            //        Each of these needs to be reported to crashlytics, as Note loading should never fail
            var f = note.load();
            futures.add(f);

            if (futures.length >= maxParallel) {
                await Future.wait(futures);
                futures = <Future>[];
            }
        }

        await Future.wait(futures);
        futures = <Future>[];

        for (var folder in _folders) {
            var f = folder.loadRecursively();
            futures.add(f);
        }

        return Future.wait(futures);
    }

    Future<void> load() async {
        return _lock.synchronized(() async {
            return _load();
        });
    }

    // FIXME: This should not reconstruct the Notes or NotesFolders once constructed.
    Future<void> _load() async {
        Set<String> pathsFound = {};

        final dir = Directory(folderPath);
        var lister = dir.list(recursive: false, followLinks: false);
        await for (var fsEntity in lister) {
            if (fsEntity is Link) {
                continue;
            }

            // If already seen before
            var existingNoteFSEntity = _entityMap[fsEntity.path];
            if (existingNoteFSEntity != null) {
                pathsFound.add(fsEntity.path);
                continue;
            }

            if (fsEntity is Directory) {
                //Log.d("Found directory ${fsEntity.path}");
                var subFolder = NotesFolderFS(this, fsEntity.path);
                if (subFolder.name.startsWith('.')) {
                    continue;
                }
                //Log.d("Found folder ${fsEntity.path}");

                _folders.add(subFolder);
                _entityMap[fsEntity.path] = subFolder;

                pathsFound.add(fsEntity.path);
                notifyFolderAdded(_folders.length - 1, subFolder);
                continue;
            }

            var note = Note(this, fsEntity.path);
            if (!note.filePath.toLowerCase().endsWith('.md')) {
                //Log.d("Ignoring file ${fsEntity.path}");
                continue;
            }
            //Log.d("Found file ${fsEntity.path}");

            _notes.add(note);
            _entityMap[fsEntity.path] = note;

            pathsFound.add(fsEntity.path);
            notifyNoteAdded(_notes.length - 1, note);
        }

        Set<String> pathsRemoved = _entityMap.keys.toSet().difference(pathsFound);
        pathsRemoved.forEach((path) {
            var e = _entityMap[path];
            assert(e != null);

            assert(e is NotesFolder || e is Note);
            _entityMap.remove(path);

            if (e is Note) {
                Log.d("File $path was no longer found");

                var i = _notes.indexWhere((n) => n.filePath == path);
                assert(i != -1);
                var note = _notes[i];
                _notes.removeAt(i);
                notifyNoteRemoved(i, note);
            } else {
                Log.d("Folder $path was no longer found");

                var i = _folders.indexWhere((f) => f.folderPath == path);
                assert(i != -1);
                var folder = _folders[i];
                _folders.removeAt(i);
                notifyFolderRemoved(i, folder);
            }
        });
    }

    @override
    String pathSpec() {
        if (parent == null) {
            return "";
        }
        return p.join(parent.pathSpec(), name);
    }

    Iterable<Note> getAllNotes() sync* {
        for (var note in _notes) {
            yield note;
        }

        for (var folder in _folders) {
            var notes = folder.getAllNotes();
            for (var note in notes) {
                yield note;
            }
        }
    }

    @override
    NotesFolder get fsFolder {
        return this;
    }

    NotesFolderFS getFolderWithSpec(String spec) {
        if (pathSpec() == spec) {
            return this;
        }
        for (var f in _folders) {
            var res = f.getFolderWithSpec(spec);
            if (res != null) {
                return res;
            }
        }

        return null;
    }

    Note getNoteWithSpec(String spec) {
        var parts = spec.split(p.separator);
        var folder = this;
        while (parts.length != 1) {
            var folderName = parts[0];

            bool foundFolder = false;
            for (var f in _folders) {
                if (f.name == folderName) {
                    folder = f;
                    foundFolder = true;
                    break;
                }
            }

            if (!foundFolder) {
                return null;
            }
            parts.removeAt(0);
        }

        var fileName = parts[0];
        for (var note in folder.notes) {
            if (note.fileName == fileName) {
                return note;
            }
        }

        return null;
    }
}
