import qbs
import "qbs/imports/QbsUtl/qbsutl.js" as QbsUtl

Project {
    minimumQbsVersion: "1.23.0"
    qbsSearchPaths: ["qbs"]

    readonly property var projectVersion: projectProbe.projectVersion
    readonly property string projectGitRevision: projectProbe.projectGitRevision

    Probe {
        id: projectProbe
        property var projectVersion;
        property string projectGitRevision;

        readonly property string projectBuildDirectory:  project.buildDirectory
        readonly property string projectSourceDirectory: project.sourceDirectory

        configure: {
            projectVersion = QbsUtl.getVersions(projectSourceDirectory + "/VERSION");
            projectGitRevision = QbsUtl.gitRevision(projectSourceDirectory);
        }
    }

    property var cppDefines: {
        var def = [
            "APPLICATION_NAME=\"DLNA lite\"",
            "VERSION_PROJECT=\"" + projectVersion[0] + "\"",
            "VERSION_PROJECT_MAJOR=" + projectVersion[1],
            "VERSION_PROJECT_MINOR=" + projectVersion[2],
            "VERSION_PROJECT_PATCH=" + projectVersion[3],
            "GIT_REVISION=\"" + projectGitRevision + "\"",
            "CONFIG_DIR=\"/etc/dlnalite\"",
            "VAROPT_DIR=\"/var/opt/dlnalite\"",
        ];
        return def;
    }

    property var cxxFlags: [
        "-ggdb3",
        "-Wall",
        "-Wextra",
        "-Wswitch-enum",
        "-Wdangling-else",
        "-Wno-unused-parameter",
        "-Wno-variadic-macros",
        "-Wno-vla",
    ]
    property string cxxLanguageVersion: "c++17"

    references: [
        "src/shared/shared.qbs",
        "src/yaml/yaml.qbs",
        //"setup/package_build.qbs",
    ]
}
