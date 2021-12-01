"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
const prettier_1 = __importDefault(require("prettier"));
const parser_1 = __importDefault(require("./parser"));
const printer_1 = __importDefault(require("./printer"));
// These are the extra options defined by this plugin.
const options = {
    xmlSelfClosingSpace: {
        type: "boolean",
        category: "XML",
        default: true,
        description: "Adds a space before self-closing tags.",
        since: "1.1.0"
    },
    xmlWhitespaceSensitivity: {
        type: "choice",
        category: "XML",
        default: "strict",
        description: "How to handle whitespaces in XML.",
        choices: [
            {
                value: "strict",
                description: "Whitespaces are considered sensitive in all elements."
            },
            {
                value: "ignore",
                description: "Whitespaces are considered insensitive in all elements."
            }
        ],
        since: "0.6.0"
    }
};
// We're going to be using the bracketSameLine option, but since it wasn't
// introduced until prettier 2.4.0, we need to add it to our list of options if
// it's not present so that it gets respected.
if (!prettier_1.default
    .getSupportInfo()
    .options.some((opt) => opt.name === "bracketSameLine")) {
    options.bracketSameLine = {
        type: "boolean",
        category: "Global",
        default: false,
        description: "Put > of opening tags on the last line instead of on a new line.",
        since: "1.0.0"
    };
}
const plugin = {
    languages: [
        {
            name: "XML",
            parsers: ["xml"],
            aliases: ["rss", "xsd", "wsdl"],
            extensions: [
                ".xml",
                ".adml",
                ".admx",
                ".ant",
                ".axml",
                ".builds",
                ".ccproj",
                ".ccxml",
                ".clixml",
                ".cproject",
                ".cscfg",
                ".csdef",
                ".csl",
                ".csproj",
                ".ct",
                ".depproj",
                ".dita",
                ".ditamap",
                ".ditaval",
                ".dll.config",
                ".dotsettings",
                ".filters",
                ".fsproj",
                ".fxml",
                ".glade",
                ".gml",
                ".gmx",
                ".grxml",
                ".iml",
                ".inx",
                ".ivy",
                ".jelly",
                ".jsproj",
                ".kml",
                ".launch",
                ".mdpolicy",
                ".mjml",
                ".mm",
                ".mod",
                ".mxml",
                ".natvis",
                ".ncl",
                ".ndproj",
                ".nproj",
                ".nuspec",
                ".odd",
                ".osm",
                ".pkgproj",
                ".pluginspec",
                ".proj",
                ".props",
                ".ps1xml",
                ".psc1",
                ".pt",
                ".rdf",
                ".resx",
                ".rss",
                ".sch",
                ".scxml",
                ".sfproj",
                ".shproj",
                ".srdf",
                ".storyboard",
                ".sublime-snippet",
                ".targets",
                ".tml",
                ".ts",
                ".tsx",
                ".ui",
                ".urdf",
                ".ux",
                ".vbproj",
                ".vcxproj",
                ".vsixmanifest",
                ".vssettings",
                ".vstemplate",
                ".vxml",
                ".wixproj",
                ".workflow",
                ".wsdl",
                ".wsf",
                ".wxi",
                ".wxl",
                ".wxs",
                ".x3d",
                ".xacro",
                ".xaml",
                ".xib",
                ".xlf",
                ".xliff",
                ".xmi",
                ".xml.dist",
                ".xproj",
                ".xsd",
                ".xspec",
                ".xul",
                ".zcml"
            ],
            filenames: [
                ".classpath",
                ".cproject",
                ".project",
                "App.config",
                "NuGet.config",
                "Settings.StyleCop",
                "Web.Debug.config",
                "Web.Release.config",
                "Web.config",
                "packages.config"
            ],
            vscodeLanguageIds: ["xml", "forcesourcemanifest"],
            linguistLanguageId: 399
        },
        {
            name: "SVG",
            parsers: ["xml"],
            extensions: [".svg"],
            vscodeLanguageIds: ["svg"],
            linguistLanguageId: 337
        }
    ],
    parsers: {
        xml: parser_1.default
    },
    printers: {
        xml: printer_1.default
    },
    options,
    defaultOptions: {
        printWidth: 80,
        tabWidth: 2
    }
};
module.exports = plugin;
