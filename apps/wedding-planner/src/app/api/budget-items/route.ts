import { NextResponse } from "next/server";
import { getPrisma } from "@/lib/prisma";
import { BudgetItemCreateSchema } from "@/lib/validation";

export async function GET() {
  const prisma = getPrisma();
  const items = await prisma.budgetItem.findMany({
    orderBy: [{ category: "asc" }, { updatedAt: "desc" }],
  });
  return NextResponse.json(items);
}

export async function POST(req: Request) {
  const prisma = getPrisma();
  const body = await req.json().catch(() => null);
  const parsed = BudgetItemCreateSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json(
      { error: "Invalid input", details: parsed.error.flatten() },
      { status: 400 },
    );
  }

  const created = await prisma.budgetItem.create({
    data: {
      category: parsed.data.category,
      name: parsed.data.name,
      targetCents: parsed.data.targetCents ?? null,
      actualCents: parsed.data.actualCents ?? null,
      notes: parsed.data.notes ?? null,
    },
  });

  return NextResponse.json(created, { status: 201 });
}

