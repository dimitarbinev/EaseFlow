import { Request, Response } from "express";
import { catch_async, error_lister } from "../middleware/middleware";
import { GoogleGenAI, Type } from "@google/genai";

const ai = new GoogleGenAI({apiKey: "AIzaSyBPrTiYE6uVLPL8lSi4Jgwv8EQ6wh33rjM"});
const SYSTEM_INSTRUCTION = `
  You are a specialized assistant for children with autism. 
  Your goal is to turn task titles into clear, step-by-step guides.
  
  CRITICAL RULES:
  1. MICRO-STEPS: Break the task into the smallest possible physical actions. 
  2. LITERAL LANGUAGE: Use simple, concrete words and emojis if possible. Never use idioms, metaphors, or sarcasm.
  3. STRUCTURE: Use a numbered list. One action per step.
  4. SOCIAL SCRIPTS: If the task involves a person, provide exactly what the child should say in quotes.
  5. SENSORY AWARENESS: Mention potential sounds or feelings so they aren't surprises (e.g., "The water might feel cold").
  6. TONE: Calm, encouraging, and predictable. 
  7. COMPLETION: Always end by telling the child they did a good job.
`;

export const getAiResponse = catch_async(async(req: Request, res: Response) => {
    const {task} = req.body;
    
    if(!task){
        return res.status(400).json({message: "Task not provided"});
    }

    const response = await ai.models.generateContent({
      model: "gemini-2.5-flash",
      contents: [
        {role: "user", parts: [{text: task}]}
      ],
      config: {
        temperature: 1.0,
        maxOutputTokens: 1000,
        systemInstruction: SYSTEM_INSTRUCTION
      }
    });

    console.log("TASK ACIVE: ", task);
    console.log("AI RESPONSE: ", response.text);
    return res.status(200).json({response: response.text});
})