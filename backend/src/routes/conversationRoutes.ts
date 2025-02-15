import { Router, Request, Response } from "express";
import { verifyToken } from "../middlewares/authMiddleware";
import { getConversations, getUserconversations } from "../controllers/conversationController";
const router = Router();
router.get("/:userId", getUserconversations);


// Define the route to get unique conversations with pagination
router.get("", verifyToken, getConversations);



export default router;

