"use client";

import { useEffect, useMemo, useState } from "react";
import { SectionHero } from "@/components/SectionHero";

type RsvpStatus = "notInvited" | "invited" | "yes" | "no" | "maybe";

type Guest = {
  id: string;
  name: string;
  partySize: number;
  side: string | null;
  rsvpStatus: RsvpStatus;
  email: string | null;
  phone: string | null;
  notes: string | null;
  createdAt: string;
  updatedAt: string;
};

const rsvpOptions: { value: RsvpStatus; label: string }[] = [
  { value: "notInvited", label: "Not invited" },
  { value: "invited", label: "Invited" },
  { value: "yes", label: "Yes" },
  { value: "no", label: "No" },
  { value: "maybe", label: "Maybe" },
];

function displayRsvp(v: RsvpStatus) {
  return rsvpOptions.find((o) => o.value === v)?.label ?? v;
}

export default function GuestsPage() {
  const [items, setItems] = useState<Guest[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const [name, setName] = useState("");
  const [partySize, setPartySize] = useState("1");
  const [side, setSide] = useState("");
  const [rsvpStatus, setRsvpStatus] = useState<RsvpStatus>("invited");
  const [notes, setNotes] = useState("");

  const [editingId, setEditingId] = useState<string | null>(null);
  const [editPartySize, setEditPartySize] = useState("1");
  const [editSide, setEditSide] = useState("");
  const [editRsvp, setEditRsvp] = useState<RsvpStatus>("invited");
  const [editNotes, setEditNotes] = useState("");

  async function refresh() {
    setLoading(true);
    setError(null);
    try {
      const res = await fetch("/api/guests", { cache: "no-store" });
      if (!res.ok) throw new Error(await res.text());
      const data = (await res.json()) as Guest[];
      setItems(data);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load guests");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    void refresh();
  }, []);

  const totals = useMemo(() => {
    const byRsvp: Record<RsvpStatus, number> = {
      notInvited: 0,
      invited: 0,
      yes: 0,
      no: 0,
      maybe: 0,
    };
    let peopleTotal = 0;
    let yesPeople = 0;
    for (const g of items) {
      byRsvp[g.rsvpStatus] += 1;
      peopleTotal += g.partySize ?? 1;
      if (g.rsvpStatus === "yes") yesPeople += g.partySize ?? 1;
    }
    return { byRsvp, peopleTotal, yesPeople };
  }, [items]);

  async function createGuest(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    const payload = {
      name,
      partySize: Number(partySize) || 1,
      side: side.trim() ? side : null,
      rsvpStatus,
      notes: notes.trim() ? notes : null,
    };

    const res = await fetch("/api/guests", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    if (!res.ok) {
      setError(await res.text());
      return;
    }
    setName("");
    setPartySize("1");
    setSide("");
    setRsvpStatus("invited");
    setNotes("");
    await refresh();
  }

  function startEdit(g: Guest) {
    setEditingId(g.id);
    setEditPartySize(String(g.partySize ?? 1));
    setEditSide(g.side ?? "");
    setEditRsvp(g.rsvpStatus);
    setEditNotes(g.notes ?? "");
  }

  function cancelEdit() {
    setEditingId(null);
    setEditPartySize("1");
    setEditSide("");
    setEditRsvp("invited");
    setEditNotes("");
  }

  async function saveEdit(id: string) {
    setError(null);
    const payload = {
      partySize: Number(editPartySize) || 1,
      side: editSide.trim() ? editSide : null,
      rsvpStatus: editRsvp,
      notes: editNotes.trim() ? editNotes : null,
    };

    const res = await fetch(`/api/guests/${id}`, {
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
    if (!confirm("Delete this guest?")) return;
    setError(null);
    const res = await fetch(`/api/guests/${id}`, { method: "DELETE" });
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
          title="Guests"
          subtitle={`People total: ${totals.peopleTotal} · “Yes” total: ${totals.yesPeople}`}
        />
        <div className="mt-4 flex flex-wrap gap-2 text-xs text-[color:var(--muted)]">
          {rsvpOptions.map((o) => (
            <span
              key={o.value}
              className="rounded-full soft-border bg-white/70 px-2 py-0.5 dark:bg-black/10"
            >
              {o.label}: {totals.byRsvp[o.value]}
            </span>
          ))}
        </div>

        <section className="mt-6 rounded-3xl card p-5">
          <div className="text-sm font-medium">Add a guest</div>
          <form className="mt-3 grid gap-3 sm:grid-cols-2" onSubmit={createGuest}>
            <div>
              <label className="text-xs text-[color:var(--muted)]">Name</label>
              <input
                value={name}
                onChange={(e) => setName(e.target.value)}
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                placeholder="Alex Johnson"
                required
              />
            </div>
            <div>
              <label className="text-xs text-[color:var(--muted)]">Party size</label>
              <input
                value={partySize}
                onChange={(e) => setPartySize(e.target.value)}
                inputMode="numeric"
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                placeholder="1"
              />
            </div>
            <div>
              <label className="text-xs text-[color:var(--muted)]">Side (optional)</label>
              <input
                value={side}
                onChange={(e) => setSide(e.target.value)}
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                placeholder="Bride"
              />
            </div>
            <div>
              <label className="text-xs text-[color:var(--muted)]">RSVP</label>
              <select
                value={rsvpStatus}
                onChange={(e) => setRsvpStatus(e.target.value as RsvpStatus)}
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
              >
                {rsvpOptions.map((o) => (
                  <option key={o.value} value={o.value}>
                    {o.label}
                  </option>
                ))}
              </select>
            </div>
            <div className="sm:col-span-2">
              <label className="text-xs text-[color:var(--muted)]">Notes (optional)</label>
              <textarea
                rows={3}
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                placeholder="Dietary needs, plus-one name, etc."
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
            <div className="text-sm font-medium">Guest list</div>
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
              No guests yet.
            </div>
          ) : (
            <div className="mt-4 space-y-3">
              {items.map((g) => (
                <div
                  key={g.id}
                  className="rounded-3xl soft-border bg-white/55 p-4 dark:bg-black/10"
                >
                  {editingId === g.id ? (
                    <div className="grid gap-3 sm:grid-cols-2">
                      <div className="sm:col-span-2">
                        <div className="font-medium">{g.name}</div>
                        <div className="text-xs text-[color:var(--muted)]">
                          RSVP: {displayRsvp(g.rsvpStatus)}
                        </div>
                      </div>
                      <div>
                        <label className="text-xs text-[color:var(--muted)]">Party size</label>
                        <input
                          value={editPartySize}
                          onChange={(e) => setEditPartySize(e.target.value)}
                          inputMode="numeric"
                          className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                        />
                      </div>
                      <div>
                        <label className="text-xs text-[color:var(--muted)]">Side</label>
                        <input
                          value={editSide}
                          onChange={(e) => setEditSide(e.target.value)}
                          className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                        />
                      </div>
                      <div>
                        <label className="text-xs text-[color:var(--muted)]">RSVP</label>
                        <select
                          value={editRsvp}
                          onChange={(e) => setEditRsvp(e.target.value as RsvpStatus)}
                          className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                        >
                          {rsvpOptions.map((o) => (
                            <option key={o.value} value={o.value}>
                              {o.label}
                            </option>
                          ))}
                        </select>
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
                          onClick={() => void saveEdit(g.id)}
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
                          <div className="font-medium">{g.name}</div>
                          <span className="rounded-full soft-border bg-white/70 px-2 py-0.5 text-xs text-[color:var(--muted)] dark:bg-black/10">
                            {displayRsvp(g.rsvpStatus)}
                          </span>
                          <span className="text-xs text-[color:var(--muted)]">
                            party {g.partySize ?? 1}
                          </span>
                          {g.side ? (
                            <span className="text-xs text-[color:var(--muted)]">
                              {g.side}
                            </span>
                          ) : null}
                        </div>
                        {g.notes ? (
                          <div className="mt-2 whitespace-pre-wrap text-sm text-[color:var(--muted)]">
                            {g.notes}
                          </div>
                        ) : null}
                      </div>
                      <div className="flex items-center gap-2">
                        <button
                          onClick={() => startEdit(g)}
                          className="rounded-xl px-3 py-1.5 text-sm text-[color:var(--muted)] hover:bg-black/[0.04] dark:hover:bg-white/[0.06]"
                        >
                          Edit
                        </button>
                        <button
                          onClick={() => void remove(g.id)}
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

