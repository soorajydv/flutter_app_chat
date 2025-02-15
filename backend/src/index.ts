import express, { Request, Response } from 'express';
import { json } from 'body-parser';
import authRoutes from './routes/authRoutes';
import conversationRoutes from './routes/conversationRoutes';
import messageRoutes from './routes/messageRoutes';


import connectDB from './utils/db';

const app = express();
connectDB();
app.use(json());
app.use("/auth", authRoutes);
app.use("/conversations", conversationRoutes);
app.use("/message", messageRoutes);


const PORT = process.env.POST || 4001;

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
