"use client";

import { useEffect, useMemo, useState } from "react";
import { dollarsToCents, formatUsd } from "@/lib/money";
import { SectionHero } from "@/components/SectionHero";

type BudgetItem = {
  id: string;
  category: string;
  name: string;
  targetCents: number | null;
  actualCents: number | null;
  notes: string | null;
  createdAt: string;
  updatedAt: string;
};

export default function BudgetPage() {
  const [items, setItems] = useState<BudgetItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const [category, setCategory] = useState("");
  const [name, setName] = useState("");
  const [target, setTarget] = useState("");
  const [actual, setActual] = useState("");
  const [notes, setNotes] = useState("");

  const [editingId, setEditingId] = useState<string | null>(null);
  const [editTarget, setEditTarget] = useState("");
  const [editActual, setEditActual] = useState("");
  const [editNotes, setEditNotes] = useState("");

  async function refresh() {
    setLoading(true);
    setError(null);
    try {
      const res = await fetch("/api/budget-items", { cache: "no-store" });
      if (!res.ok) throw new Error(await res.text());
      const data = (await res.json()) as BudgetItem[];
      setItems(data);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load budget items");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    void refresh();
  }, []);

  const totals = useMemo(() => {
    let targetCents = 0;
    let actualCents = 0;
    for (const i of items) {
      if (i.targetCents != null) targetCents += i.targetCents;
      if (i.actualCents != null) actualCents += i.actualCents;
    }
    return { targetCents, actualCents };
  }, [items]);

  async function createItem(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    const payload = {
      category,
      name,
      targetCents: dollarsToCents(target),
      actualCents: dollarsToCents(actual),
      notes: notes.trim() ? notes : null,
    };

    const res = await fetch("/api/budget-items", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    if (!res.ok) {
      setError(await res.text());
      return;
    }
    setCategory("");
    setName("");
    setTarget("");
    setActual("");
    setNotes("");
    await refresh();
  }

  function startEdit(i: BudgetItem) {
    setEditingId(i.id);
    setEditTarget(i.targetCents != null ? (i.targetCents / 100).toFixed(2) : "");
    setEditActual(i.actualCents != null ? (i.actualCents / 100).toFixed(2) : "");
    setEditNotes(i.notes ?? "");
  }

  function cancelEdit() {
    setEditingId(null);
    setEditTarget("");
    setEditActual("");
    setEditNotes("");
  }

  async function saveEdit(id: string) {
    setError(null);
    const payload = {
      targetCents: dollarsToCents(editTarget),
      actualCents: dollarsToCents(editActual),
      notes: editNotes.trim() ? editNotes : null,
    };

    const res = await fetch(`/api/budget-items/${id}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    if (!res.ok) {
      setError(await res.text());
      return;
    }
    cancelEdit();
    await refresh();
  }

  async function remove(id: string) {
    if (!confirm("Delete this budget item?")) return;
    setError(null);
    const res = await fetch(`/api/budget-items/${id}`, { method: "DELETE" });
    if (!res.ok) {
      setError(await res.text());
      return;
    }
    await refresh();
  }

  return (
    <div className="flex flex-1 justify-center px-6 py-8">
      <main className="w-full max-w-5xl">
        <SectionHero
          title="Budget"
          subtitle={`Totals — target ${formatUsd(totals.targetCents)} · actual ${formatUsd(totals.actualCents)}`}
        />

        <section className="mt-6 rounded-3xl card p-5">
          <div className="text-sm font-medium">Add a budget item</div>
          <form className="mt-3 grid gap-3 sm:grid-cols-2" onSubmit={createItem}>
            <div>
              <label className="text-xs text-[color:var(--muted)]">Category</label>
              <input
                value={category}
                onChange={(e) => setCategory(e.target.value)}
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                placeholder="Venue"
                required
              />
            </div>
            <div>
              <label className="text-xs text-[color:var(--muted)]">Item name</label>
              <input
                value={name}
                onChange={(e) => setName(e.target.value)}
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                placeholder="Deposit"
                required
              />
            </div>
            <div>
              <label className="text-xs text-[color:var(--muted)]">Target (optional)</label>
              <input
                value={target}
                onChange={(e) => setTarget(e.target.value)}
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                placeholder="5000"
              />
            </div>
            <div>
              <label className="text-xs text-[color:var(--muted)]">Actual (optional)</label>
              <input
                value={actual}
                onChange={(e) => setActual(e.target.value)}
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                placeholder="4800"
              />
            </div>
            <div className="sm:col-span-2">
              <label className="text-xs text-[color:var(--muted)]">Notes (optional)</label>
              <textarea
                rows={3}
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
              />
            </div>
            <div className="sm:col-span-2 flex items-center justify-end">
              <button
                className="rounded-2xl btn-primary px-4 py-2 text-sm font-medium"
                type="submit"
              >
                Add
              </button>
            </div>
          </form>

          {error ? (
            <div className="mt-3 rounded-xl border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-800 dark:border-red-900/40 dark:bg-red-950/40 dark:text-red-200">
              {error}
            </div>
          ) : null}
        </section>

        <section className="mt-6 rounded-3xl card p-5">
          <div className="flex items-center justify-between">
            <div className="text-sm font-medium">Items</div>
            <button
              onClick={() => void refresh()}
              className="rounded-xl px-3 py-1.5 text-sm text-[color:var(--muted)] hover:bg-black/[0.04] dark:hover:bg-white/[0.06]"
            >
              Refresh
            </button>
          </div>

          {loading ? (
            <div className="mt-4 text-sm text-[color:var(--muted)]">
              Loading…
            </div>
          ) : items.length === 0 ? (
            <div className="mt-4 text-sm text-[color:var(--muted)]">
              No budget items yet.
            </div>
          ) : (
            <div className="mt-4 space-y-3">
              {items.map((i) => (
                <div
                  key={i.id}
                  className="rounded-3xl soft-border bg-white/55 p-4 dark:bg-black/10"
                >
                  {editingId === i.id ? (
                    <div className="grid gap-3 sm:grid-cols-2">
                      <div className="sm:col-span-2">
                        <div className="font-medium">
                          {i.category} · {i.name}
                        </div>
                      </div>
                      <div>
                        <label className="text-xs text-[color:var(--muted)]">Target</label>
                        <input
                          value={editTarget}
                          onChange={(e) => setEditTarget(e.target.value)}
                          className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                        />
                      </div>
                      <div>
                        <label className="text-xs text-[color:var(--muted)]">Actual</label>
                        <input
                          value={editActual}
                          onChange={(e) => setEditActual(e.target.value)}
                          className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                        />
                      </div>
                      <div className="sm:col-span-2">
                        <label className="text-xs text-[color:var(--muted)]">Notes</label>
                        <textarea
                          rows={3}
                          value={editNotes}
                          onChange={(e) => setEditNotes(e.target.value)}
                          className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                        />
                      </div>
                      <div className="sm:col-span-2 flex items-center justify-end gap-2">
                        <button
                          onClick={cancelEdit}
                          className="rounded-2xl soft-border bg-white/70 px-4 py-2 text-sm font-medium hover:bg-black/[0.04] dark:bg-black/10 dark:hover:bg-white/[0.06]"
                          type="button"
                        >
                          Cancel
                        </button>
                        <button
                          onClick={() => void saveEdit(i.id)}
                          className="rounded-2xl btn-primary px-4 py-2 text-sm font-medium"
                          type="button"
                        >
                          Save
                        </button>
                      </div>
                    </div>
                  ) : (
                    <div className="flex flex-col gap-2 sm:flex-row sm:items-start sm:justify-between">
                      <div>
                        <div className="flex flex-wrap items-center gap-2">
                          <div className="font-medium">
                            {i.category} · {i.name}
                          </div>
                          <span className="text-xs text-[color:var(--muted)]">
                            target {formatUsd(i.targetCents)} · actual{" "}
                            {formatUsd(i.actualCents)}
                          </span>
                        </div>
                        {i.notes ? (
                          <div className="mt-2 whitespace-pre-wrap text-sm text-[color:var(--muted)]">
                            {i.notes}
                          </div>
                        ) : null}
                      </div>
                      <div className="flex items-center gap-2">
                        <button
                          onClick={() => startEdit(i)}
                          className="rounded-xl px-3 py-1.5 text-sm text-[color:var(--muted)] hover:bg-black/[0.04] dark:hover:bg-white/[0.06]"
                        >
                          Edit
                        </button>
                        <button
                          onClick={() => void remove(i.id)}
                          className="rounded-lg px-3 py-1.5 text-sm text-red-700 hover:bg-red-50 dark:text-red-200 dark:hover:bg-red-950/40"
                        >
                          Delete
                        </button>
                      </div>
                    </div>
                  )}
                </div>
              ))}
            </div>
          )}
        </section>
      </main>
    </div>
  );
}

