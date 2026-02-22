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
    const {title, childUid} = req.body
    const guardianId = req.user?.uid

    const childDoc = await db.collection('users').doc(childUid).get()
    if(!childDoc.exists || childDoc.data()?.guardianId !== guardianId){
        return res.status(403).json({message: "Child is not linked to its guardian"})
    }

    const taskRef = db.collection('tasks').doc()
    await taskRef.set({
        title,
        userId: childUid,
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

export const getTasks = catch_async(async (req: Request, res: Response) => {

  const userUid = req.user?.uid;
  if (!userUid) 
    return res.status(401).json({ message: "Not authenticated" });

  const userDoc = await db.collection("users").doc(userUid).get();
  const userData = userDoc.data();
  if (!userData) 
    return res.status(404).json({ message: "User not found" });

  let childUid: string;

  if (userData.role === "child") {

    // child fetches their own tasks
    childUid = userUid;

  } else if (userData.role === "guardian") {

    childUid = req.params.childUid as string;

    if (!childUid)
      return res
        .status(400)
        .json({ message: "childUid is required for guardian" });


    console.log("Guardian UID:", userUid);
    console.log("Linked children:", userData.linkedChildren);
    console.log("Requested childUid:", childUid);
    if (!userData.linkedChildren.includes(childUid))
      return res.status(403).json({ message: "Child not linked to guardian" });

  } else {
    return res.status(403).json({ message: "Unknown role" });
  }

  const tasksSnap = await db
    .collection("tasks")
    .where("userId", "==", childUid)
    .orderBy("createdAt", "asc")
    .get();

  const tasks = await Promise.all(
    tasksSnap.docs.map(async (taskDoc) => {
      const stepsSnap = await taskDoc.ref
        .collection("steps")
        .orderBy("order")
        .get();
      const steps = stepsSnap.docs.map((s) => ({ id: s.id, ...s.data() }));
      return { id: taskDoc.id, ...taskDoc.data(), steps };
    })
  );

  res.status(200).json(tasks);
});