import { Request, Response } from "express";
import AuthService from "../services/authService";

class AuthController {
  async register(req: Request, res: Response): Promise<void> {
    try {
      const { username, email, password } = req.body;
      console.log(username, email, password);

      if (!username || !email || !password) {
        res.status(400).json({ message: "All fields are required." });
        return;
      }

      const user = await AuthService.register(username, email, password);
      res.status(201).json({ message: "User registered successfully!", user });
    } catch (error) {
      console.log("Controller Error:", error);
      res.status(500).json({ message: error instanceof Error ? error.message : "Internal Server Error" });
    }
  }

  async login(req: Request, res: Response): Promise<void> {
    try {
      const { email, password } = req.body;

      if (!email || !password) {
        res.status(400).json({ message: "Email and password are required." });
        return;
      }

      const result = await AuthService.login(email, password);
      if (result) {
        console.log(result)
        res.status(200).json({ message: "Login successful!", user: result.user, token: result.token });
      } else {
        res.status(401).json({ message: "Invalid credentials." });
      }
    } catch (error) {
      console.log("Controller Error:", error);
      res.status(500).json({ message: error instanceof Error ? error.message : "Internal Server Error" });
    }
  }
}

export default new AuthController();
