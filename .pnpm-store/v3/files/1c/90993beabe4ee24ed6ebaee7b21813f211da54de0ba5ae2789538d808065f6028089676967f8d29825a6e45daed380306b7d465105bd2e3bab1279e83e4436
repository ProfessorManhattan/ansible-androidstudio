const { concat, group, hardline, join } = require("prettier/doc").builders;

const nodes = {
  comment: (path, _opts, _print) => path.getValue().value,
  param: (path, opts, _print) => {
    const { key, value } = path.getValue();
    const delimiter = opts.iniSpaceAroundEquals ? " = " : "=";

    return group(concat([key, delimiter, value]));
  },
  root: (path, _opts, print) => {
    const lines = [];

    path.getValue().value.forEach((node, index) => {
      let printed = path.call(print, "value", index);
      if (index > 0 && node.type === "section") {
        printed = concat([hardline, printed]);
      }

      lines.push(printed);
    });

    return concat([join(hardline, lines), hardline]);
  },
  section: (path, opts, print) => {
    const { name } = path.getValue();
    const parts = [concat(["[", name, "]"])];

    return concat([join(hardline, parts.concat(path.map(print, "value")))]);
  }
};

const genericPrint = (path, opts, print) =>
  nodes[path.getValue().type](path, opts, print);

module.exports = genericPrint;
