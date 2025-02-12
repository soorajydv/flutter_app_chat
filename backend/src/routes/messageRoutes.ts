import express from "express";
import { sendNewMessage, fetchConversationMessages } from "../controllers/messageController";

const router = express.Router();

router.post("/send", sendNewMessage); // Send a new message
router.get("/:user1/:user2", fetchConversationMessages); // Fetch messages between two users

export default router;
