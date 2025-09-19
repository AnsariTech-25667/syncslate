import { prisma } from "./db";

export async function pickHostForTeam(teamId: string): Promise<string | null> {
  const members = await prisma.user.findMany({ where: { teamId }});
  if (members.length === 0) return null;

  const since = new Date(Date.now() - 30 * 24 * 3600 * 1000);
  const loads = await Promise.all(members.map(async m => {
    const count = await prisma.booking.count({ where: { hostId: m.id, createdAt: { gte: since } }});
    return { id: m.id, count };
  }));
  loads.sort((a,b) => a.count - b.count);
  return loads[0].id;
}
