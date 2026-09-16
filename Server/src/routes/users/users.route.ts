import { Router } from "express";
import UsersController from "../../controllers/users/users.controller";
import { authenticate } from "../../middleware/auth.middleware";

const router = Router();

// user : Get all data
router.get("/:userId", authenticate, UsersController.getPostsByUserId);

// user : Get post detail by user ID & post ID
router.get("/:userId/posts/:postId", authenticate, UsersController.getPostsByUserId);

export default router;
