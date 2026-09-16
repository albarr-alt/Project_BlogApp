import { Router } from "express";
import AuthController from "../../controllers/auth/auth.controller";

const router = Router();

/**
 * @route   POST /auth/register
 * @desc    Register a new user account
 * @access  Public
 */
router.post("/register", AuthController.register);

/**
 * @route   POST /auth/login
 * @desc    Authenticate user and return JWT token
 * @access  Public
 */
router.post("/login", AuthController.login);

export default router;
