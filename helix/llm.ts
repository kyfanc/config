import { parseArgs } from "util";

const Prompts = {
  summarizeText: async (text: string) => {
    const messages = [
      {
        content: `
You are an personal assistant.
When asked for your name, you must respond with "Ollama".
Follow the user's requirements carefully & to the letter.
- Be concise.
- Answer in point form in markdown format.
      `,
        role: "system",
      },
      {
        content: `
I have the following text:
\`\`\`text
${text}
\`\`\`
          `,
        role: "user",
      },
      {
        content: `
- Summarize this text.
- Answer in concise point form in markdown format.
- Answer in the same language as in the original text.
            `,
        role: "user",
      },
    ];

    return messages;
  },

  summarizeCode: async (code: string) => {
    const messages = [
      {
        content: `
You are an AI Coding Assistant.
When asked for your name, you must respond with "Ollama".
Follow the user's requirements carefully & to the letter.
- Be concise.
- Answer in markdown format.
      `,
        role: "system",
      },
      {
        content: `
I have the following code:
\`\`\`
${code}
\`\`\`
          `,
        role: "user",
      },
      {
        content: `
- Summarize this code.
- Start by giving an overview of the code.
- Then give the high level structure and flow of the code.
            `,
        role: "user",
      },
    ];

    return messages;
  },
  diagnoseCode: async (code: string) => {
    const messages = [
      {
        content: `
You are an AI Coding Assistant.
When asked for your name, you must respond with "Ollama".
Follow the user's requirements carefully & to the letter.
- Be concise.
- Answer in markdown format.
      `,
        role: "system",
      },
      {
        content: `
I have the following code:
\`\`\`
${code}
\`\`\`
          `,
        role: "user",
      },
      {
        content: `
- review this code and provide suggestion for improvement.
- prioritize structural issues.
- ignore formatting issues.
- ignore missing imports and missing declarations.
            `,
        role: "user",
      },
    ];

    return messages;
  },
  document: async (text: string) => {
    const messages = [
      {
        content: `
You are an personal assistant.
When asked for your name, you must respond with "Ollama".
Follow the user's requirements carefully & to the letter.
- Be concise.
- Answer in point form in markdown format.
      `,
        role: "system",
      },
      {
        content: `
I have the following text:
\`\`\`text
${text}
\`\`\`
          `,
        role: "user",
      },
      {
        content: `
- Add documentation to the code.
            `,
        role: "user",
      },
    ];

    return messages;
  },

  improve: async (text: string) => {
    const messages = [
      {
        content: `
You are an personal assistant.
When asked for your name, you must respond with "Ollama".
Follow the user's requirements carefully & to the letter.
      `,
        role: "system",
      },

      {
        content: `
rewrite the text wrapped in \`\`\`
- improve gramma and writing of the text
- preserve the original structure and format style
- be as detailed as possible
            `,
        role: "user",
      },
      {
        content: `
\`\`\`
${text}
\`\`\`
          `,
        role: "user",
      },
    ];

    return messages;
  },
};

async function request(messages){
  const body = JSON.stringify({
    model: "mistral",
    stream: false,
    messages: messages,
  });
  const response = await fetch("http://127.0.0.1:11434/api/chat", {
    headers: {
      "Content-Type": "application/json",
    },
    method: "POST",
    body,
  });
  const json = await response.json();
  return json.message.content;
}

const { values, positionals } = parseArgs({
  args: Bun.argv,
  options: {
    prompt: {
      type: "string",
      default: "summarizeText",
    },
    stdin: {
      type: "boolean",
    },
    "prompt-only": {
      type: "boolean",
      default: false,
    },
  },
  strict: true,
  allowPositionals: true,
});

const files = positionals.splice(2);

(async () => {
  var text: string;
  if (files.length == 0) {
    text = await Bun.stdin.text();
  } else {
    // read and concat all files in positional args
    text = (
      await Promise.all(
        files.map(async (filePath) => {
          const file = Bun.file(filePath);
          const fileContent = await file.text();
          return `
// FILEPATH: ${filePath}
${fileContent}
      `;
        }),
      )
    ).join("\n");
  }

  const messages = await Prompts[values.prompt](text);

  if (values["prompt-only"] === true) {
    console.log(JSON.stringify(messages));
    return;
  }
  const response = await request(messages);
  console.log(response);
})();
