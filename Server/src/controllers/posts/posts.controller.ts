import { Request, Response } from "express";
import { createPostSchema, postIdSchema, updatePostParamsSchema, updatePostSchema } from "../../validations/post.validation";
import { db } from "../../config/db";
import { postsTable } from "../../config/schema";
import { and, desc, eq } from "drizzle-orm";
import { deleteFromCloudinary, uploadToCloudinary } from "../../services/cloudinary.service";

export class PostController {
  createPost = async (req: Request, res: Response) => {
    try {
      const validatedData = createPostSchema.parse(req.body);
      const { userId, title, content, imageUrl: bodyImageUrl } = validatedData;

      let imageUrl: string | undefined = bodyImageUrl;
      let imagePublicId: string | undefined;

      const file = (req as any).file;
      if (file) {
        const uploadResult = await uploadToCloudinary(file.buffer);

        imageUrl = uploadResult.secure_url;
        imagePublicId = uploadResult.public_id;
      }

      const [insertedPost] = await db
        .insert(postsTable)
        .values({
          userId,
          title,
          content,
          imageUrl,
          imagePublicId,
        })
        .$returningId();

      const newPost = await db.query.postsTable.findFirst({
        where: eq(postsTable.id, insertedPost.id),
      });

      return res.status(201).json({
        success: true,
        message: "Post created successfully",
        data: {
          post: newPost,
        },
      });
    } catch (error) {
      console.error("Create post error:", error);

      return res.status(500).json({
        success: false,
        message: "terjadi kesalahan pada server",
        error: error instanceof Error ? error.message : error,
      });
    }
  };

  //READ
  // GUEST

  getPosts = async (_req: Request, res: Response) => {
    try {
      const posts = await db
        .select()
        .from(postsTable)
        .where(eq(postsTable.status, "published"))
        .orderBy(desc(postsTable.createdAt));

      return res.status(200).json({
        success: true,
        message: "Get Posts Successfully",
        data: {
          posts: posts,
        },
      });
    } catch (error) {
      console.error("Create post error:", error);
      return res.status(500).json({
        success: false,
        message: "Terjadi kesalahan pada server",
        error: error instanceof Error ? error.message : error,
      });
    }
  };

   //GUEST : BY ID 
    // GUEST : Get Post By ID
    getPostById = async (req: Request, res: Response) => {
    try {
        const validatedParams = postIdSchema.parse(req.params);
        const { id } = validatedParams;

        const [post] = await db.select().from(postsTable).where(
        and(
            eq(postsTable.id, id),
            eq(postsTable.status, "published")
        )
        );

        if (!post) {
        return res.status(404).json({
            success: false,
            message: "Post not found"
        });
        }

        return res.status(200).json({
        success: true,
        message: "Post retrieved successfully",
        data: {
            post
        }
        });
    } catch (error) {
        console.error("Get post error:", error);
        return res.status(500).json({
        success: false,
        message: "Terjadi kesalahan pada server",
        error: error instanceof Error ? error.message : error
        });
    }
    };

     updatePost = async (req: Request, res: Response) => {
  try {
    const { id } = updatePostParamsSchema.parse(req.params);
    const body = updatePostSchema.parse(req.body);

    const existingPost = await db
      .select()
      .from(postsTable)
      .where(eq(postsTable.id, id));

    if (!existingPost[0]) {
      return res.status(404).json({
        success: false,
        message: "Post not found",
      });
    }

    if (existingPost[0].userId !== (req as any).user?.id) {
      return res.status(403).json({
        success: false,
        message: "Unauthorized to update this post",
      });
    }

    let imageUrl = body.imageUrl !== undefined ? body.imageUrl : existingPost[0].imageUrl;
    let imagePublicId = existingPost[0].imagePublicId;

    if (req.file) {
      if (imagePublicId) {
        await deleteFromCloudinary(imagePublicId);
      }
      const uploadResult = await uploadToCloudinary(req.file.buffer);
      imageUrl = uploadResult.secure_url;
      imagePublicId = uploadResult.public_id;
    }

    await db
      .update(postsTable)
      .set({
        ...body,
        imageUrl,
        imagePublicId,
        updatedAt: new Date(),
      })
      .where(eq(postsTable.id, id));

    const updatedPost = await db
      .select()
      .from(postsTable)
      .where(eq(postsTable.id, id));

    // 8. RESPONSE
    return res.status(200).json({
      success: true,
      message: "Post updated successfully",
      data: {
        post: updatedPost,
      },
    });
  } catch (error: any) {
    console.error("Update post error:", error);
    return res.status(500).json({
      success: false,
      message: "Internal server error",
      error: error.message,
    });
  }
};

// DELETE
deletePost = async (req: Request, res: Response) => {
  try {
    // 1. VALIDATE POST ID
    const validatedParams = postIdSchema.parse(req.params);
    const { id } = validatedParams;

    // 2. CEK POST
    const existingPost = await db.query.postsTable.findFirst({
      where: eq(postsTable.id, id),
    });

    if (!existingPost) {
      return res.status(404).json({
        success: false,
        message: "Post not found",
      });
    }

    // 3. SOFT DELETE
    await db
      .update(postsTable)
      .set({
        status: "delete",
        updatedAt: new Date(),
      })
      .where(eq(postsTable.id, id));

    return res.status(200).json({
      success: true,
      message: "Post deleted successfully",
    });
  } catch (error: any) {
    console.error("Delete post error:", error);
    return res.status(500).json({
      success: false,
      message: "Internal server error",
      error: error.message,
    });
  }
};

}

export default new PostController();
