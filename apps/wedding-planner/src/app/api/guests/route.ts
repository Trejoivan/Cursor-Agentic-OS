import { NextResponse } from "next/server";
import { getPrisma } from "@/lib/prisma";
import { GuestCreateSchema } from "@/lib/validation";

export async function GET() {
  const prisma = getPrisma();
  const guests = await prisma.guest.findMany({
    orderBy: [{ rsvpStatus: "asc" }, { name: "asc" }],
  });
  return NextResponse.json(guests);
}

export async function POST(req: Request) {
  const prisma = getPrisma();
  const body = await req.json().catch(() => null);
  const parsed = GuestCreateSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json(
      { error: "Invalid input", details: parsed.error.flatten() },
      { status: 400 },
    );
  }

  const created = await prisma.guest.create({
    data: {
      name: parsed.data.name,
      partySize: parsed.data.partySize ?? 1,
      side: parsed.data.side ?? null,
      rsvpStatus: parsed.data.rsvpStatus ?? "invited",
      email: parsed.data.email ?? null,
      phone: parsed.data.phone ?? null,
      notes: parsed.data.notes ?? null,
    },
  });

  return NextResponse.json(created, { status: 201 });
}

