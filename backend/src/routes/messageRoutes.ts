import express from "express";
import { sendNewMessage, fetchConversationMessages } from "../controllers/messageController";
import { verifyToken } from "../middlewares/authMiddleware";

const router = express.Router();

router.post("/send", verifyToken, sendNewMessage); // Send a new message
router.get("/:user1/:user2", verifyToken, fetchConversationMessages); // Fetch messages between two users

export default router;
