import express, { Express, Request, Response } from "express";

const app: Express = express();

app.get("/", (req: Request, res: Response) => {
 res.status(200).json("Hello from the server!!!");
});

app.get("/api/health", (req: Request, res: Response) => {
  res.status(200).json({
    message: "Server is running",
    timestamp: new Date().toISOString(),
    hrtime: process.hrtime(),
    cpuUsage: process.cpuUsage(),
    memoryUsage: process.memoryUsage(),
  });
});

app.listen(4000, () => {
 console.log(`App is listening on port 4000`);
});