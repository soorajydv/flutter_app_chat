import { Router, Request, Response } from "express";
import { verifyToken } from "../middlewares/authMiddleware";
import { getUserconversations } from "../controllers/conversationController";
const router = Router();
router.get("/:userId", getUserconversations);

export default router;

