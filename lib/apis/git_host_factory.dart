import 'git_host.dart';
import 'github.dart';
import 'gitlab.dart';

export 'git_host.dart';

enum GitHostType {
    Unknown,
    GitHub,
    GitLab,
    Custom,
}

GitHost createGitHost(GitHostType type) {
    switch (type) {
        case GitHostType.GitHub:
            return GitHub();

        case GitHostType.GitLab:
            return GitLab();

        default:
            return null;
    }
}
