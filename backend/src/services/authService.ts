import User, { IUser } from "../models/User";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
dotenv.config();

class AuthService {
  // Register a new user
  async register(username: string, email: string, password: string): Promise<IUser | null> {
    try {
      const existingUser = await User.findOne({ email });
      if (existingUser) {
        throw new Error("User already exists with this email.");
      }

      // Hash the password
      const hashedPassword = await bcrypt.hash(password, 10);

      // Create new user
      const newUser = new User({ username, email, password: hashedPassword });
      await newUser.save();

      return newUser;
    }  catch (error) {
      if (error instanceof Error) { // ✅ TypeScript now recognizes 'error' as an Error object
        console.log("Service Error:", error.message);
        throw new Error(error.message);
      } else {
        console.log("Unknown Error:", error);
        throw new Error("An unknown error occurred");
      }
  }
  }

  // Login user and generate JWT
  async login(email: string, password: string): Promise<{ user: IUser; token: string } | null> {
    try {
      const user = await User.findOne({ email });
      if (!user) {
        throw new Error("Invalid email or password.");
      }

      // Check if password matches
      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) {
        throw new Error("Invalid email or password.");
      }
   


      // Generate JWT Token
      const token = jwt.sign(
        { id: user._id, email: user.email },
        process.env.JWT_SECRET as string,
        { expiresIn: "1h" }
      );

      return { user, token };
    } catch (error) {
      if (error instanceof Error) { // ✅ TypeScript now recognizes 'error' as an Error object
        console.log("Service Error:", error.message);
        throw new Error(error.message);
      } else {
        console.log("Unknown Error:", error);
        throw new Error("An unknown error occurred");
      }
  }
}
}

export default new AuthService();
