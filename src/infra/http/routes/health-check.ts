import { getUploads } from "@/app/functions/get-uploads";
import { isRight, unwrapEither } from "@/shared/either";
import { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import z from "zod";

export const healthCheckRoute: FastifyPluginAsyncZod = async (server) => {
  server.get(
    "/health-check",
    {
      schema: {
        summary: "Health Check",
        tags: ["health-check"],
        response: {
          200: z.object({
            message: z.string(),
          }),
        },
      },
    },
    async (request, reply) => {
      return reply.status(200).send({ message: "OK!" });
    },
  );
};
