import { Router } from "express";
import { generateWithFlan } from "../src/services/flan.services";

const router = Router();

router.post("/generate", async (req, res) => {
  const { prompt } = req.body;

  if (!prompt) {
    return res.status(400).json({ error: "Prompt is required" });
  }

  try {
    const result = await generateWithFlan(prompt);
    res.json({ response: result });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "AI failed" });
  }
});

export default router;