import { Router } from "express";
import PostController from "../../controllers/posts/posts.controller";
import { uploadSingleImage } from "../../middleware/upload.middleware";
import { authenticate } from "../../middleware/auth.middleware";

const router = Router();

/**
 * @route   POST /posts
 * @desc    Create a new post with optional image upload
 * @access  Private (Authenticated users only)
 */
router.post("/", authenticate, uploadSingleImage, PostController.createPost);

/**
 * @route   GET /posts
 * @desc    Get list of all posts
 * @access  Public
 */
router.get("/", PostController.getPosts);

/**
 * @route   GET /posts/:id
 * @desc    Get post details by ID
 * @access  Public
 */
router.get("/:id", PostController.getPostById);

/**
 * @route   PATCH /posts/:id
 * @desc    Update post by ID with optional image upload
 * @access  Private (Authenticated users only)
 */
router.patch("/:id", authenticate, uploadSingleImage, PostController.updatePost);

/**
 * @route   DELETE /posts/:id
 * @desc    Delete post by ID
 * @access  Private (Authenticated users only)
 */
router.delete("/:id", authenticate, PostController.deletePost);

export default router;