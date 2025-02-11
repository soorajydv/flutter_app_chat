import mongoose, { Schema, Document } from "mongoose";

// Define the interface for User
export interface IUser extends Document {
  username: string;
  email: string;
  password: string;
}

// Create User Schema
const UserSchema: Schema = new Schema(
  {
    username: { type: String, required: true, unique: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
  },
  { timestamps: true }
);

// Export User Model
export default mongoose.model<IUser>("User", UserSchema);
