import { Types } from "mongoose";
import { Message } from "../models/Message";
import { findOrCreateConversation } from "./conversationService"
import { Conversation } from "../models/Conversation";
import User from "../models/User";

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




const getMessagesBetweenUsers = async (userId: string, convId: string) => {
    try {
        const userObjectId = new Types.ObjectId(userId);
        const conversationObjectId = new Types.ObjectId(convId);

        // Find the conversation between the two users
        const conversation = await Conversation.findOne(conversationObjectId);


        if (!conversation) {
            return { success: false, message: "No conversation found between these users." };
        }
        const receiverId = conversation.participants[0] === userObjectId ? conversation!.participants[0]! : conversation?.participants[1]


        // Fetch all messages in the conversation, sorted by createdAt (descending)
        const messages = await Message.find({ conversation: conversation._id })
            .sort({ createdAt: -1 })
            .select("text sender createdAt")
            .lean(); // Use lean() for better performance

        // Fetch the friend's (receiverId) user details
        const friend = await User.findById(receiverId).select("username");

        if (!friend) {
            return { success: false, message: "Receiver user not found." };
        }

        // Transform messages to include isSent and isReceived flags
        const formattedMessages = messages.map((msg) => ({
            message: msg.text,
            isSent: msg.sender.toString() === userId,
            isReceived: msg.sender.toString() === receiverId.toString(),
        }));

        return {
            success: true,
            friendName: friend.username,
            friendId: receiverId,
            messages: formattedMessages,
        };
    } catch (error: any) {
        return { success: false, message: "Server error", error: error.message };
    }
};

export default getMessagesBetweenUsers;
