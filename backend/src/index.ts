import express, { Request, Response } from 'express';
import { json } from 'body-parser';
import http from "http";
import { Server } from "socket.io";
import authRoutes from './routes/authRoutes';
import conversationRoutes from './routes/conversationRoutes';
import messageRoutes from './routes/messageRoutes';


import connectDB from './utils/db';

const app = express();

connectDB();
app.use(json());
//creating a locak server
const server = http.createServer(app);

const io = new Server(server, {
    cors: {
        origin: "*"
    }
})

app.use("/auth", authRoutes);
app.use("/conversations", conversationRoutes);
app.use("/message", messageRoutes);
io.on("connection", (socket) => {
    console.log("a user connected", socket.id);

    socket.on("joineConversation", (conversationId) => {
        socket.join(conversationId);
        console.log("User joined conversation:" + conversationId);
    });
    socket.on("sendMessage", (message) => {
        try {
            // const savedMessage = 
        } catch (error) {
            console.error('failed to save message:', error);
        }
        const { conversationId, senderId, content } = message;
    })

});

const PORT = process.env.POST || 4001;

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
