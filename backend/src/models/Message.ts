import mongoose, { Schema, Document, Types } from "mongoose";
import { IConversation } from "./Conversation";
import { IUser } from "./User";

export interface IMessage extends Document {
  conversation: Types.ObjectId | IConversation;
  sender: Types.ObjectId | IUser;
  text: string;
  createdAt: Date;
}

const MessageSchema = new Schema<IMessage>(
  {
    conversation: { type: Schema.Types.ObjectId, ref: "Conversation", required: true },
    sender: { type: Schema.Types.ObjectId, ref: "User", required: true }, // Stores who sent the message
    text: { type: String, required: true },
  },
  { timestamps: true } // Automatically adds `createdAt` field
);

export const Message = mongoose.model<IMessage>("Message", MessageSchema);
