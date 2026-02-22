import { Request, Response } from "express";
import { catch_async, error_lister } from "../middleware/middleware";
import admin from "firebase-admin"
import {db} from "../config/firbase"

enum status{
    pending,
    completed,
    missed
}

export const createTask = catch_async(async(req: Request, res:Response) => {
    const {title, userId} = req.body
    const guardianId = req.user?.uid

    const childDoc = await db.collection('users').doc(userId).get()
    if(!childDoc.exists || childDoc.data()?.guardianId !== guardianId){
        return res.status(403).json({message: "Child is not linked to its guardian"})
    }

    const taskRef = db.collection('tasks').doc()
    await taskRef.set({
        title,
        userId: req.body.childUid,
        createdBy: guardianId,
        status: status.pending,
        createdAt: new Date()
    })

    res.status(201).json({message: "The task was made", taskId: taskRef.id})

})

export const addSteps = catch_async(async(req: Request, res: Response) => {
    const {taskId} = req.params as any;
    const {description, order, emoji, imageUrl} = req.body
    const guardianId = req.user?.uid

    const taskDoc =await db.collection('tasks').doc(taskId).get()
    if(!taskDoc.exists){
        return res.status(404).json({message: "Task not found"})
    }

    const childUid = taskDoc.data()?.userId
    const childDoc = await db.collection('users').doc(childUid).get();
    if(childDoc.data()?.guardianId !== guardianId){
        return res.status(403).json({message: "Forbidden"})
    }

    const stepRef = db.collection('tasks').doc(taskId).collection('steps').doc()

    await stepRef.set({
        description,
        order,
        emoji: emoji || null,
        imageUrl: imageUrl || null
    })

    res.status(201).json({message: "step added", stepId: stepRef.id})
})

export const getTaskForChild = catch_async(
  async (req: Request, res: Response) => {
    const childUid = req.params.childUid;

    if (!childUid) {
      return res.status(400).json({ message: "childUid is required" });
    }

    // 🚧 DEV MODE: Skip authentication & role checks for now

    const tasksSnap = await db
      .collection("tasks")
      .where("userId", "==", childUid)
      .get();

    if (tasksSnap.empty) {
      return res.status(200).json([]); // no tasks yet
    }

    const tasks = [];

    for (const taskDoc of tasksSnap.docs) {
      const stepsSnap = await taskDoc.ref
        .collection("steps")
        .orderBy("order")
        .get();

      const steps = stepsSnap.docs.map((stepDoc) => ({
        id: stepDoc.id,
        ...stepDoc.data(),
      }));

      tasks.push({
        id: taskDoc.id,
        ...taskDoc.data(),
        steps,
      });
    }

    res.status(200).json(tasks);
  }
);