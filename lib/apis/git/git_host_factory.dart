import 'git_host.dart';
import 'github.dart';

export 'git_host.dart';

enum GitHostType {
    Unknown,
    GitHub,
}

GitHost createGitHost(GitHostType type) {
    switch (type) {
        case GitHostType.GitHub:
            return GitHub();

        default:
            return null;
    }
}
