import { Request, Response } from "express";
import { sendMessage, getMessageByConversation } from "../services/messageService";

export const sendNewMessage = async (req: Request, res: Response) => {
    try {
        const { senderId, receiverId, text } = req.body;
        const message = await sendMessage(senderId, receiverId, text);
        res.json(message);
    } catch (error) {
        res.status(500).json({ message: "Error sending message", error });
    }
};

export const fetchConversationMessages = async (req: Request, res: Response) => {
    try {
        const { user1, user2 } = req.params;
        const messages = await getMessageByConversation(user1, user2);
        res.json(messages);
    } catch (error) {
        res.status(500).json({ message: "Error fetching messages", error });
    }
};
