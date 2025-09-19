import { prisma } from "./db";

export async function hasConflict(hostId: string, start: Date, end: Date, bufferBeforeMin = 0, bufferAfterMin = 0) {
  const bufferStart = new Date(start.getTime() - bufferBeforeMin * 60000);
  const bufferEnd   = new Date(end.getTime() + bufferAfterMin * 60000);

  const overlap = await prisma.booking.findFirst({
    where: {
      hostId,
      status: { in: ["PENDING", "CONFIRMED"] },
      NOT: [{ endTime: { lte: bufferStart } }, { startTime: { gte: bufferEnd } }]
    },
    select: { id: true }
  });

  return Boolean(overlap);
}
