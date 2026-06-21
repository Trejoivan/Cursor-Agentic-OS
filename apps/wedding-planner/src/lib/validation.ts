import { z } from "zod";

export function isValidDateInput(value: string) {
  const t = Date.parse(value);
  return Number.isFinite(t);
}

export const TaskStatusSchema = z.enum(["todo", "inProgress", "done"]);

export const TaskCreateSchema = z.object({
  title: z.string().min(1).max(200),
  notes: z.string().max(5000).optional().nullable(),
  status: TaskStatusSchema.optional(),
  dueDate: z
    .string()
    .refine(isValidDateInput, "Invalid date")
    .optional()
    .nullable(),
});

export const TaskUpdateSchema = TaskCreateSchema.partial();

export const VendorCreateSchema = z.object({
  name: z.string().min(1).max(200),
  category: z.string().max(120).optional().nullable(),
  status: z.string().max(80).optional(),
  website: z.string().url().optional().nullable(),
  contactName: z.string().max(120).optional().nullable(),
  contactEmail: z.string().email().optional().nullable(),
  contactPhone: z.string().max(80).optional().nullable(),
  quoteCents: z.number().int().nonnegative().optional().nullable(),
  notes: z.string().max(5000).optional().nullable(),
});

export const VendorUpdateSchema = VendorCreateSchema.partial();

export const BudgetItemCreateSchema = z.object({
  category: z.string().min(1).max(120),
  name: z.string().min(1).max(200),
  targetCents: z.number().int().nonnegative().optional().nullable(),
  actualCents: z.number().int().nonnegative().optional().nullable(),
  notes: z.string().max(5000).optional().nullable(),
});

export const BudgetItemUpdateSchema = BudgetItemCreateSchema.partial();

export const RsvpStatusSchema = z.enum([
  "notInvited",
  "invited",
  "yes",
  "no",
  "maybe",
]);

export const GuestCreateSchema = z.object({
  name: z.string().min(1).max(200),
  partySize: z.number().int().min(1).max(20).optional(),
  side: z.string().max(80).optional().nullable(),
  rsvpStatus: RsvpStatusSchema.optional(),
  email: z.string().email().optional().nullable(),
  phone: z.string().max(80).optional().nullable(),
  notes: z.string().max(5000).optional().nullable(),
});

export const GuestUpdateSchema = GuestCreateSchema.partial();

