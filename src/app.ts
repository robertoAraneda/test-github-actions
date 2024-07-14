import express, { Express, NextFunction, Request, Response } from "express";
import cors from "cors";
import helmet from "helmet";


const app: Express = express();

app.get("/", (req: Request, res: Response) => {
 res.status(200).json("Hello from the server!!!");
});

app.get("/api/health", (req: Request, res: Response, next: NextFunction) => {
  //create log
  console.log("Health check request received");
  console.log("Request URL: ", req.url);
  next();
},   

(req: Request, res: Response) => {
  res.status(200).json({
    message: "Server is running",
    timestamp: new Date().toISOString(),
    hrtime: process.hrtime(),
    cpuUsage: process.cpuUsage(),
    memoryUsage: process.memoryUsage(),
  });
});

app.use(cors({
  origin: "*",
}));

app.use(helmet());


app.listen(3000, () => {
 console.log(`App is listening on port 3000`);
});