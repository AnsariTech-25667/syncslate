import { prisma } from "./db";
export async function log(kind: string, meta?: Record<string, any>) {
  await prisma.eventLog.create({ data: { kind, meta } });
}
