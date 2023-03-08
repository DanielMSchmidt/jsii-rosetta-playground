import * as path from "path";
import * as fs from "fs/promises";
import { CSharpVisitor, translateTypeScript } from "jsii-rosetta";

async function makeFileSource(fileName: string) {
  return {
    contents: await fs.readFile(fileName, "utf-8"),
    fileName: fileName,
  };
}

async function run() {
  const result = translateTypeScript(
    await makeFileSource(
      path.join(
        __dirname,
        "..",
        "1-convert-to-typescript",
        "manually-converted.ts"
      )
    ),
    new CSharpVisitor(),
    {
      includeCompilerDiagnostics: true,
    }
  );

  console.log(result.translation);
  console.log(result.diagnostics);
}

run();
