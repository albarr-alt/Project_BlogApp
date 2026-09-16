import { Router } from "express";
import PostController from "../../controllers/posts/posts.controller";
import { uploadSingleImage } from "../../middleware/upload.middleware";
import { authenticate } from "../../middleware/auth.middleware";

const router = Router();

router.post("/", authenticate,uploadSingleImage, PostController.createPost);

router.get("/", PostController.getPosts);
router.get("/:id", PostController.getPostById);

// update
router.patch("/:id", authenticate, uploadSingleImage, PostController.updatePost);

// delete
router.delete("/:id", authenticate, PostController.deletePost);

export default router;