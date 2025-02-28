import { Request, Response } from "express";
import getMessagesBetweenUsers, { sendMessage, getMessageByConversation } from "../services/messageService";

export const sendNewMessage = async (req: Request, res: Response) => {
    try {
        const { receiverId, content } = req.body;
        const message = await sendMessage(req.user!.id, receiverId, content);
        res.json(message);
    } catch (error) {
        res.status(500).json({ message: "Error sending message", error });
    }
};

export const fetchConversationMessages = async (req: Request, res: Response) => {
    try {
        const { friend } = req.params;
        const result = await getMessagesBetweenUsers(req.user!.id, friend);
        if (!result.success) res.sendStatus(400);
        else res.json(result);
    } catch (error) {
        res.status(500).json({ message: "Error fetching messages", error });
    }
};
