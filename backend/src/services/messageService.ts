import { Message } from "../models/Message";
import { findOrCreateConversation } from "./conversationService"

export const sendMessage = async (senderId: string, receiverId: string, text: string) => {
    const conversation = await findOrCreateConversation(senderId, receiverId);
    const message = new Message({ conversation: conversation._id, sender: senderId, text });
    await message.save();
    return message;
};

export const getMessageByConversation = async (user1: string, user2: string) => {
    const conversation = await findOrCreateConversation(user1, user2);
    return await Message.find({ conversation: conversation._id })
        .populate("sender", "username")
        .sort({ createdAt: 1 });
};