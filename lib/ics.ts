import { createEvent } from "ics";

export function makeICS(opts: {
  title: string;
  description?: string;
  start: Date;
  end: Date;
  location?: string;
  organizer?: { name: string; email: string };
  attendee?: { name: string; email: string };
}) {
  const toArray = (d: Date) => [d.getFullYear(), d.getMonth()+1, d.getDate(), d.getHours(), d.getMinutes()];
  const { error, value } = createEvent({
    title: opts.title,
    description: opts.description,
    start: toArray(opts.start),
    end: toArray(opts.end),
    location: opts.location,
    organizer: opts.organizer,
    attendees: opts.attendee ? [{ name: opts.attendee.name, email: opts.attendee.email, rsvp: true }] : []
  });
  if (error) throw error;
  return Buffer.from(value, "utf8");
}
