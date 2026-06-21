import { NextResponse } from "next/server";
import { getPrisma } from "@/lib/prisma";
import { TaskCreateSchema } from "@/lib/validation";

export async function GET() {
  const prisma = getPrisma();
  const tasks = await prisma.task.findMany({
    orderBy: [{ status: "asc" }, { dueDate: "asc" }, { updatedAt: "desc" }],
  });
  return NextResponse.json(tasks);
}

export async function POST(req: Request) {
  const prisma = getPrisma();
  const body = await req.json().catch(() => null);
  const parsed = TaskCreateSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json(
      { error: "Invalid input", details: parsed.error.flatten() },
      { status: 400 },
    );
  }

  const created = await prisma.task.create({
    data: {
      title: parsed.data.title,
      notes: parsed.data.notes ?? null,
      status: parsed.data.status ?? "todo",
      dueDate: parsed.data.dueDate ? new Date(parsed.data.dueDate) : null,
    },
  });

  return NextResponse.json(created, { status: 201 });
}

