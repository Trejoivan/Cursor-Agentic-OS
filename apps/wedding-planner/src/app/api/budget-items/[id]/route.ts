import { NextResponse } from "next/server";
import { getPrisma } from "@/lib/prisma";
import { BudgetItemUpdateSchema } from "@/lib/validation";

export async function GET(
  _req: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const prisma = getPrisma();
  const { id } = await params;
  const item = await prisma.budgetItem.findUnique({ where: { id } });
  if (!item) return NextResponse.json({ error: "Not found" }, { status: 404 });
  return NextResponse.json(item);
}

export async function PATCH(
  req: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const prisma = getPrisma();
  const { id } = await params;
  const body = await req.json().catch(() => null);
  const parsed = BudgetItemUpdateSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json(
      { error: "Invalid input", details: parsed.error.flatten() },
      { status: 400 },
    );
  }

  const updated = await prisma.budgetItem.update({
    where: { id },
    data: {
      ...(parsed.data.category !== undefined
        ? { category: parsed.data.category }
        : {}),
      ...(parsed.data.name !== undefined ? { name: parsed.data.name } : {}),
      ...(parsed.data.targetCents !== undefined
        ? { targetCents: parsed.data.targetCents }
        : {}),
      ...(parsed.data.actualCents !== undefined
        ? { actualCents: parsed.data.actualCents }
        : {}),
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
  await prisma.budgetItem.delete({ where: { id } });
  return NextResponse.json({ ok: true });
}

