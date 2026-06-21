import { NextResponse } from "next/server";
import { getPrisma } from "@/lib/prisma";
import { VendorCreateSchema } from "@/lib/validation";

export async function GET() {
  const prisma = getPrisma();
  const vendors = await prisma.vendor.findMany({
    orderBy: [{ status: "asc" }, { updatedAt: "desc" }],
  });
  return NextResponse.json(vendors);
}

export async function POST(req: Request) {
  const prisma = getPrisma();
  const body = await req.json().catch(() => null);
  const parsed = VendorCreateSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json(
      { error: "Invalid input", details: parsed.error.flatten() },
      { status: 400 },
    );
  }

  const created = await prisma.vendor.create({
    data: {
      name: parsed.data.name,
      category: parsed.data.category ?? null,
      status: parsed.data.status ?? "researching",
      website: parsed.data.website ?? null,
      contactName: parsed.data.contactName ?? null,
      contactEmail: parsed.data.contactEmail ?? null,
      contactPhone: parsed.data.contactPhone ?? null,
      quoteCents: parsed.data.quoteCents ?? null,
      notes: parsed.data.notes ?? null,
    },
  });

  return NextResponse.json(created, { status: 201 });
}

