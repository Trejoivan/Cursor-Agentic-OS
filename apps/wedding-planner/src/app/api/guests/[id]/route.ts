import { NextResponse } from "next/server";
import { getPrisma } from "@/lib/prisma";
import { GuestUpdateSchema } from "@/lib/validation";

export async function GET(
  _req: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const prisma = getPrisma();
  const { id } = await params;
  const guest = await prisma.guest.findUnique({ where: { id } });
  if (!guest) return NextResponse.json({ error: "Not found" }, { status: 404 });
  return NextResponse.json(guest);
}

export async function PATCH(
  req: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const prisma = getPrisma();
  const { id } = await params;
  const body = await req.json().catch(() => null);
  const parsed = GuestUpdateSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json(
      { error: "Invalid input", details: parsed.error.flatten() },
      { status: 400 },
    );
  }

  const updated = await prisma.guest.update({
    where: { id },
    data: {
      ...(parsed.data.name !== undefined ? { name: parsed.data.name } : {}),
      ...(parsed.data.partySize !== undefined
        ? { partySize: parsed.data.partySize }
        : {}),
      ...(parsed.data.side !== undefined ? { side: parsed.data.side } : {}),
      ...(parsed.data.rsvpStatus !== undefined
        ? { rsvpStatus: parsed.data.rsvpStatus }
        : {}),
      ...(parsed.data.email !== undefined ? { email: parsed.data.email } : {}),
      ...(parsed.data.phone !== undefined ? { phone: parsed.data.phone } : {}),
      ...(parsed.data.notes !== undefined ? { notes: parsed.data.notes } : {}),
    },
  });

  return NextResponse.json(updated);
}

export async function DELETE(
  _req: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const prisma = getPrisma();
  const { id } = await params;
  await prisma.guest.delete({ where: { id } });
  return NextResponse.json({ ok: true });
}

