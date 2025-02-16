import { Request, Response } from "express";
import { getConversationByUser } from "../services/conversationService";
import getUniqueConversationsWithLastMessage from "../services/chatOverview";

export const getUserconversations = async (req: Request, res: Response) => {
    try {
        const userId = req.params.userId;
        const conversation = await getConversationByUser(userId);
        res.json(conversation);
    } catch (error) {
        res.status(500).json({ message: "error fetching conversation", error });
    }
}



export const getConversations = async (req: Request, res: Response) => {
    try {
        const page = parseInt(req.query.page as string) || 1; // Default to page 1
        const limit = parseInt(req.query.limit as string) || 10; // Default to 10 items per page

        const result = await getUniqueConversationsWithLastMessage(req.user!.id, page, limit);

        res.status(200).json({
            success: true,
            data: result.conversations,
            pagination: {
                totalPages: result.totalPages,
                currentPage: result.currentPage
            }
        });
    } catch (error: any) {
        res.status(500).json({ success: false, message: "Server Error", error: error.message });
    }
};
