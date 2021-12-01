const sectionPattern = /^\s*\[\s*([^\]]*)\s*\]\s*$/;
const paramPattern = /^\s*([^=]+?)\s*=\s*(.*?)\s*$/;
const commentPattern = /^\s*[;#].*$/;

const parse = (text, _parsers, _opts) => {
  const root = { type: "root", value: [] };
  let section = null;

  text.split(/[\r\n]+/).forEach((line, index) => {
    const lineno = index + 1;

    if (commentPattern.test(line)) {
      const target = section ? section.value : root.value;

      target.push({ type: "comment", value: line.trim(), lineno });
    } else if (paramPattern.test(line)) {
      const [_match, key, value] = line.match(paramPattern);
      const target = section ? section.value : root.value;

      target.push({ type: "param", key, value, lineno });
    } else if (sectionPattern.test(line)) {
      const [_match, name] = line.match(sectionPattern);
      section = { type: "section", name, value: [], lineno };

      root.value.push(section);
    } else if (line.trim().length === 0) {
      section = null;
    } else {
      throw new Error(`Error parsing .ini on line ${lineno}:\n${line}`);
    }
  });

  return root;
};

module.exports = parse;
