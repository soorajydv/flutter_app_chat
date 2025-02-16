
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
            $project: {
                conversationId: "$_id",
                lastMessage: {
                    text: "$lastMessage.text",
                    senderId: "$lastMessage.sender",
                    createdAt: "$lastMessage.createdAt",
                },
                participants: "$conversationInfo.participants",
            },
        },
        {
            $addFields: {
                otherParticipantId: {
                    $arrayElemAt: [
                        {
                            $filter: {
                                input: "$participants",
                                as: "participant",
                                cond: { $ne: ["$$participant", userObjectId] }, // Exclude the current user
                            },
                        },
                        0,
                    ],
                },
            },
        },
        {
            $lookup: {
                from: "users",
                localField: "otherParticipantId",
                foreignField: "_id",
                as: "otherParticipant",
            },
        },
        {
            $unwind: "$otherParticipant",
        },
        {
            $project: {
                _id: 0,
                conversationId: 1,
                lastMessage: 1,
                otherParticipant: {
                    _id: "$otherParticipant._id",
                    name: "$otherParticipant.name",
                    email: "$otherParticipant.email",
                    profilePic: "$otherParticipant.profilePic", // Include only relevant details
                },
            },
        },
        { $skip: skip }, // Pagination: Skip for the current page
        { $limit: limit }, // Pagination: Limit results per page
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
