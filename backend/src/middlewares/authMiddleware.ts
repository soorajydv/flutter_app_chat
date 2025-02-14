import { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
dotenv.config()

export const verifyToken = (req: Request, res: Response, next: NextFunction): void => {
    // bearer {token}
    console.log(req.headers);
    const token = req.headers.authorization?.split(' ')[1];
    console.log(token);


    if (!token) {
        res.status(403).json({ error: 'no token provided' });
        return;
    }
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET || "NILASSECRETKEY");
        req.user = decoded as { id: string };
        next();
    } catch (error) {
        res.status(401).json({ error: "Invalid token" });
    }

} 