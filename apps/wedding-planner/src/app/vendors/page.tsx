"use client";

import { useEffect, useMemo, useState } from "react";
import { dollarsToCents, formatUsd } from "@/lib/money";
import { SectionHero } from "@/components/SectionHero";

type Vendor = {
  id: string;
  name: string;
  category: string | null;
  status: string;
  website: string | null;
  contactName: string | null;
  contactEmail: string | null;
  contactPhone: string | null;
  quoteCents: number | null;
  notes: string | null;
  createdAt: string;
  updatedAt: string;
};

const statuses = ["researching", "contacted", "quoted", "booked", "declined"] as const;

export default function VendorsPage() {
  const [items, setItems] = useState<Vendor[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const [name, setName] = useState("");
  const [category, setCategory] = useState("");
  const [status, setStatus] = useState<(typeof statuses)[number]>("researching");
  const [website, setWebsite] = useState("");
  const [quote, setQuote] = useState("");

  const [editingId, setEditingId] = useState<string | null>(null);
  const [editStatus, setEditStatus] = useState<string>("researching");
  const [editQuote, setEditQuote] = useState("");
  const [editNotes, setEditNotes] = useState("");

  async function refresh() {
    setLoading(true);
    setError(null);
    try {
      const res = await fetch("/api/vendors", { cache: "no-store" });
      if (!res.ok) throw new Error(await res.text());
      const data = (await res.json()) as Vendor[];
      setItems(data);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load vendors");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    void refresh();
  }, []);

  const byStatus = useMemo(() => {
    const map = new Map<string, number>();
    for (const v of items) map.set(v.status, (map.get(v.status) ?? 0) + 1);
    return map;
  }, [items]);

  async function createVendor(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    const quoteCents = dollarsToCents(quote);
    const payload = {
      name,
      category: category.trim() ? category : null,
      status,
      website: website.trim() ? website : null,
      quoteCents,
    };

    const res = await fetch("/api/vendors", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    if (!res.ok) {
      setError(await res.text());
      return;
    }
    setName("");
    setCategory("");
    setStatus("researching");
    setWebsite("");
    setQuote("");
    await refresh();
  }

  function startEdit(v: Vendor) {
    setEditingId(v.id);
    setEditStatus(v.status);
    setEditQuote(v.quoteCents != null ? (v.quoteCents / 100).toFixed(2) : "");
    setEditNotes(v.notes ?? "");
  }

  function cancelEdit() {
    setEditingId(null);
    setEditStatus("researching");
    setEditQuote("");
    setEditNotes("");
  }

  async function saveEdit(id: string) {
    setError(null);
    const payload = {
      status: editStatus,
      quoteCents: dollarsToCents(editQuote),
      notes: editNotes.trim() ? editNotes : null,
    };

    const res = await fetch(`/api/vendors/${id}`, {
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
    if (!confirm("Delete this vendor?")) return;
    setError(null);
    const res = await fetch(`/api/vendors/${id}`, { method: "DELETE" });
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
          title="Vendors"
          subtitle="Track options, quotes, and booking status."
        />
        <div className="mt-4 flex flex-wrap gap-2 text-xs text-[color:var(--muted)]">
            {Array.from(byStatus.entries()).map(([k, v]) => (
              <span
                key={k}
              className="rounded-full soft-border bg-white/70 px-2 py-0.5 dark:bg-black/10"
              >
                {k}: {v}
              </span>
            ))}
        </div>

        <section className="mt-6 rounded-3xl card p-5">
          <div className="text-sm font-medium">Add a vendor</div>
          <form className="mt-3 grid gap-3 sm:grid-cols-2" onSubmit={createVendor}>
            <div>
              <label className="text-xs text-[color:var(--muted)]">Name</label>
              <input
                value={name}
                onChange={(e) => setName(e.target.value)}
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                placeholder="Evergreen Photo Co."
                required
              />
            </div>
            <div>
              <label className="text-xs text-[color:var(--muted)]">
                Category (optional)
              </label>
              <input
                value={category}
                onChange={(e) => setCategory(e.target.value)}
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                placeholder="Photography"
              />
            </div>
            <div>
              <label className="text-xs text-[color:var(--muted)]">Status</label>
              <select
                value={status}
                onChange={(e) =>
                  setStatus(e.target.value as (typeof statuses)[number])
                }
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
              >
                {statuses.map((s) => (
                  <option key={s} value={s}>
                    {s}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <label className="text-xs text-[color:var(--muted)]">
                Quote (optional)
              </label>
              <input
                value={quote}
                onChange={(e) => setQuote(e.target.value)}
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                placeholder="3200"
              />
            </div>
            <div className="sm:col-span-2">
              <label className="text-xs text-[color:var(--muted)]">
                Website (optional)
              </label>
              <input
                value={website}
                onChange={(e) => setWebsite(e.target.value)}
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                placeholder="https://..."
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
            <div className="text-sm font-medium">Your vendors</div>
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
              No vendors yet.
            </div>
          ) : (
            <div className="mt-4 space-y-3">
              {items.map((v) => (
                <div
                  key={v.id}
                  className="rounded-3xl soft-border bg-white/55 p-4 dark:bg-black/10"
                >
                  {editingId === v.id ? (
                    <div className="grid gap-3 sm:grid-cols-2">
                      <div className="sm:col-span-2">
                        <div className="font-medium">{v.name}</div>
                        <div className="text-xs text-[color:var(--muted)]">
                          {v.category ?? "—"}
                        </div>
                      </div>
                      <div>
                        <label className="text-xs text-[color:var(--muted)]">Status</label>
                        <input
                          value={editStatus}
                          onChange={(e) => setEditStatus(e.target.value)}
                          className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                        />
                      </div>
                      <div>
                        <label className="text-xs text-[color:var(--muted)]">Quote</label>
                        <input
                          value={editQuote}
                          onChange={(e) => setEditQuote(e.target.value)}
                          className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                          placeholder="3200"
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
                          onClick={() => void saveEdit(v.id)}
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
                          <div className="font-medium">{v.name}</div>
                          <span className="rounded-full soft-border bg-white/70 px-2 py-0.5 text-xs text-[color:var(--muted)] dark:bg-black/10">
                            {v.status}
                          </span>
                          {v.category ? (
                            <span className="text-xs text-[color:var(--muted)]">
                              {v.category}
                            </span>
                          ) : null}
                          <span className="text-xs text-[color:var(--muted)]">
                            {formatUsd(v.quoteCents)}
                          </span>
                        </div>
                        {v.website ? (
                          <a
                            href={v.website}
                            target="_blank"
                            rel="noreferrer"
                            className="mt-1 block text-sm underline decoration-[color:var(--border)] underline-offset-2 hover:decoration-[color:var(--accent)]"
                          >
                            {v.website}
                          </a>
                        ) : null}
                        {v.notes ? (
                          <div className="mt-2 whitespace-pre-wrap text-sm text-[color:var(--muted)]">
                            {v.notes}
                          </div>
                        ) : null}
                      </div>
                      <div className="flex items-center gap-2">
                        <button
                          onClick={() => startEdit(v)}
                          className="rounded-xl px-3 py-1.5 text-sm text-[color:var(--muted)] hover:bg-black/[0.04] dark:hover:bg-white/[0.06]"
                        >
                          Edit
                        </button>
                        <button
                          onClick={() => void remove(v.id)}
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

