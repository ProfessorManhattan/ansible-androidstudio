const parse = require("./parse");
const print = require("./print");

const locStart = () => 0;
const locEnd = () => 0;

const plugin = {
  languages: [
    {
      name: "INI",
      parsers: ["ini"],
      extensions: [".ini"],
      vscodeLanguageIds: ["ini"]
    }
  ],
  parsers: {
    ini: {
      parse,
      astFormat: "ini",
      locStart,
      locEnd
    }
  },
  printers: {
    ini: {
      print
    }
  },
  options: {
    iniSpaceAroundEquals: {
      type: "boolean",
      category: "INI",
      default: false,
      description: "Adds a space around the equals sign when specifying params."
    }
  },
  defaultOptions: {
    printWidth: 80,
    tabWidth: 2
  }
};

module.exports = plugin;
