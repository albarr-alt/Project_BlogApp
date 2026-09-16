import { Router } from "express";
import UsersController from "../../controllers/users/users.controller";
import { authenticate } from "../../middleware/auth.middleware";

const router = Router();

/**
 * @route   GET /users/:userId
 * @desc    Get all posts and data for a specific user
 * @access  Private (Authenticated users only)
 */
router.get("/:userId", authenticate, UsersController.getPostsByUserId);

/**
 * @route   GET /users/:userId/posts/:postId
 * @desc    Get specific post detail by user ID & post ID
 * @access  Private (Authenticated users only)
 */
router.get("/:userId/posts/:postId", authenticate, UsersController.getPostsByUserId);

export default router;
