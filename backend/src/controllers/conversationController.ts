import { Request, Response } from "express";
import { getConversationByUser } from "../services/conversationService";

export const getUserconversations = async (req: Request, res: Response) => {
    try {
        const userId = req.params.userId;
        const conversation = await getConversationByUser(userId);
        res.json(conversation);
    } catch (error) {
        res.status(500).json({ message: "error fetching conversation", error });
    }
}