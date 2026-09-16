import express from "express";

import authRoutes from "./routes/auth/auth.route";
import postsRouter from "./routes/posts/post.route";
import usersRouter from "./routes/users/users.route";

const app = express();
const port = 3000; // Server Port

app.use(express.json());

// CORS Middleware agar bisa diakses dari Flutter Web/Browser
app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, PATCH, OPTIONS");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization");
  if (req.method === "OPTIONS") {
    res.sendStatus(200);
    return;
  }
  next();
});

app.use("/api/v1/auth", authRoutes);
app.use("/api/v1/posts", postsRouter);
app.use("/api/v1/users", usersRouter);

app.get("/", (req, res) => {
  res.send("hello world");
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
