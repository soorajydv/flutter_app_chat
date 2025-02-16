
import { Types } from "mongoose";
import { Message } from "../models/Message";
import { Conversation } from "../models/Conversation";

const getUniqueConversationsWithLastMessage = async (
    userId: string,
    page: number = 1,
    limit: number = 10
) => {
    const skip = (page - 1) * limit;
    const userObjectId = new Types.ObjectId(userId);

    const conversations = await Message.aggregate([
        {
            $sort: { createdAt: -1 }, // Sort messages by creation date (latest first)
        },
        {
            $group: {
                _id: "$conversation", // Group by conversation
                lastMessage: { $first: "$$ROOT" }, // Get the latest message per conversation
            },
        },
        {
            $lookup: {
                from: "conversations",
                localField: "_id",
                foreignField: "_id",
                as: "conversationInfo",
            },
        },
        {
            $unwind: "$conversationInfo",
        },
        {
            $match: {
                "conversationInfo.participants": userObjectId, // Ensure user is a participant
            },
        },
        {
            $lookup: {
                from: "users",
                localField: "lastMessage.sender",
                foreignField: "_id",
                as: "senderInfo",
            },
        },
        {
            $unwind: "$senderInfo",
        },
        {
            $project: {
                _id: 0,
                conversationId: "$_id",
                // receiverId:"$",

                text: "$lastMessage.text",
                sender: { _id: "$senderInfo._id", name: "$senderInfo.username", },
                createdAt: "$lastMessage.createdAt",

                // conversationInfo: 1,
            },
        },
        {
            $sort: { createdAt: -1 }, // Sort messages by creation date (latest first)
        },
        { $skip: skip }, // Skip for pagination
        { $limit: limit }, // Limit results per page
    ]);

    // Get total count of unique conversations for the user
    const totalConversations = await Conversation.countDocuments({
        participants: userObjectId,
    });

    return {
        conversations,
        totalPages: Math.ceil(totalConversations / limit),
        currentPage: page,
    };
};

export default getUniqueConversationsWithLastMessage;
