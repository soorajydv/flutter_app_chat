import express from "express";
import { fetchConversationMessages, sendNewMessage } from "../controllers/messageController";
import { verifyToken } from "../middlewares/authMiddleware";

const router = express.Router();

router.post("/send", verifyToken, sendNewMessage); // Send a new message
router.get("/:friend", verifyToken, fetchConversationMessages); // Fetch messages between two users

export default router;
