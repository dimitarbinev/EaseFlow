import { pipeline } from "@xenova/transformers";

let generator: any = null;

async function getModel() {
  if (!generator) {
    generator = await pipeline("text2text-generation", "Xenova/flan-t5-base");
  }
  return generator;
}

export async function generateWithFlan(prompt: string) {
  const model = await getModel();
  const result = await model(prompt, { max_new_tokens: 100 });
  return result[0].generated_text;
}