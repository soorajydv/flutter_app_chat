import express, {Request, Response} from 'express';
import { json } from 'body-parser';
import authRoutes from './routes/authRoutes';
import connectDB from './utils/db';

const app = express();
connectDB();
app.use (json());
app.use("/auth", authRoutes);

app.get('/', (req: Request, res: Response) => {
    console.log('Hello World');
    res.send('Hello World');
})


const PORT = process.env.POST || 3000;

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
