import { Conversation } from "../models/Conversation"

export const findOrCreateConversation = async (user1: string, user2: string) => {
    let conversation = await Conversation.findOne({
        participants: { $all: [user1, user2] },
    });
    if (!conversation) {
        conversation = new Conversation({ participants: [user1, user2] });
        await conversation.save();
    }
    return conversation;
};

export const getConversationByUser = async (userId: string) => {
    return await Conversation.find({ participants: userId }).populate('participants', 'username');
};