"use client";

import { useEffect, useMemo, useState } from "react";
import { SectionHero } from "@/components/SectionHero";

type TaskStatus = "todo" | "inProgress" | "done";

type Task = {
  id: string;
  title: string;
  notes: string | null;
  status: TaskStatus;
  dueDate: string | null;
  createdAt: string;
  updatedAt: string;
};

function toDateInputValue(iso: string | null) {
  if (!iso) return "";
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return "";
  return d.toISOString().slice(0, 10);
}

export default function TasksPage() {
  const [items, setItems] = useState<Task[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const [title, setTitle] = useState("");
  const [notes, setNotes] = useState("");
  const [status, setStatus] = useState<TaskStatus>("todo");
  const [dueDate, setDueDate] = useState("");

  const [editingId, setEditingId] = useState<string | null>(null);
  const [editTitle, setEditTitle] = useState("");
  const [editNotes, setEditNotes] = useState("");
  const [editStatus, setEditStatus] = useState<TaskStatus>("todo");
  const [editDueDate, setEditDueDate] = useState("");

  async function refresh() {
    setLoading(true);
    setError(null);
    try {
      const res = await fetch("/api/tasks", { cache: "no-store" });
      if (!res.ok) throw new Error(await res.text());
      const data = (await res.json()) as Task[];
      setItems(data);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load tasks");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    void refresh();
  }, []);

  const counts = useMemo(() => {
    const c: { todo: number; inProgress: number; done: number } = {
      todo: 0,
      inProgress: 0,
      done: 0,
    };
    for (const t of items) {
      if (t.status === "todo") c.todo++;
      if (t.status === "inProgress") c.inProgress++;
      if (t.status === "done") c.done++;
    }
    return c;
  }, [items]);

  async function createTask(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    const payload = {
      title,
      notes: notes.trim() ? notes : null,
      status,
      dueDate: dueDate ? new Date(dueDate).toISOString() : null,
    };

    const res = await fetch("/api/tasks", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    if (!res.ok) {
      setError(await res.text());
      return;
    }
    setTitle("");
    setNotes("");
    setStatus("todo");
    setDueDate("");
    await refresh();
  }

  function startEdit(t: Task) {
    setEditingId(t.id);
    setEditTitle(t.title);
    setEditNotes(t.notes ?? "");
    setEditStatus(t.status);
    setEditDueDate(toDateInputValue(t.dueDate));
  }

  function cancelEdit() {
    setEditingId(null);
    setEditTitle("");
    setEditNotes("");
    setEditStatus("todo");
    setEditDueDate("");
  }

  async function saveEdit(id: string) {
    setError(null);
    const payload = {
      title: editTitle,
      notes: editNotes.trim() ? editNotes : null,
      status: editStatus,
      dueDate: editDueDate ? new Date(editDueDate).toISOString() : null,
    };

    const res = await fetch(`/api/tasks/${id}`, {
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
    if (!confirm("Delete this task?")) return;
    setError(null);
    const res = await fetch(`/api/tasks/${id}`, { method: "DELETE" });
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
          title="Tasks"
          subtitle={`${counts.todo} todo · ${counts.inProgress} in progress · ${counts.done} done`}
        />

        <section className="mt-6 rounded-3xl card p-5">
          <div className="text-sm font-medium">Add a task</div>
          <form className="mt-3 grid gap-3 sm:grid-cols-2" onSubmit={createTask}>
            <div className="sm:col-span-2">
              <label className="text-xs text-[color:var(--muted)]">Title</label>
              <input
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                placeholder="Book venue tour"
                required
              />
            </div>

            <div>
              <label className="text-xs text-[color:var(--muted)]">Status</label>
              <select
                value={status}
                onChange={(e) => setStatus(e.target.value as TaskStatus)}
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
              >
                <option value="todo">Todo</option>
                <option value="inProgress">In progress</option>
                <option value="done">Done</option>
              </select>
            </div>

            <div>
              <label className="text-xs text-[color:var(--muted)]">
                Due date (optional)
              </label>
              <input
                type="date"
                value={dueDate}
                onChange={(e) => setDueDate(e.target.value)}
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
              />
            </div>

            <div className="sm:col-span-2">
              <label className="text-xs text-[color:var(--muted)]">
                Notes (optional)
              </label>
              <textarea
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
                rows={3}
                className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                placeholder="Questions to ask, price range, who to bring..."
              />
            </div>

            <div className="sm:col-span-2 flex items-center justify-between">
              <div className="text-xs text-[color:var(--muted)]">
                Stored locally in your Postgres DB.
              </div>
              <button
                className="rounded-2xl btn-primary px-4 py-2 text-sm font-medium"
                type="submit"
              >
                Add
              </button>
            </div>
          </form>

          {error ? (
            <div className="mt-3 rounded-2xl border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-800 dark:border-red-900/40 dark:bg-red-950/40 dark:text-red-200">
              {error}
            </div>
          ) : null}
        </section>

        <section className="mt-6 rounded-3xl card p-5">
          <div className="flex items-center justify-between">
            <div className="text-sm font-medium">Your tasks</div>
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
              No tasks yet.
            </div>
          ) : (
            <div className="mt-4 space-y-3">
              {items.map((t) => (
                <div
                  key={t.id}
                  className="rounded-3xl soft-border bg-white/55 p-4 dark:bg-black/10"
                >
                  {editingId === t.id ? (
                    <div className="grid gap-3 sm:grid-cols-2">
                      <div className="sm:col-span-2">
                        <label className="text-xs text-[color:var(--muted)]">Title</label>
                        <input
                          value={editTitle}
                          onChange={(e) => setEditTitle(e.target.value)}
                          className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                        />
                      </div>
                      <div>
                        <label className="text-xs text-[color:var(--muted)]">Status</label>
                        <select
                          value={editStatus}
                          onChange={(e) =>
                            setEditStatus(e.target.value as TaskStatus)
                          }
                          className="mt-1 w-full rounded-2xl soft-border bg-white/70 px-3 py-2 text-sm outline-none focus-ring dark:bg-black/10"
                        >
                          <option value="todo">Todo</option>
                          <option value="inProgress">In progress</option>
                          <option value="done">Done</option>
                        </select>
                      </div>
                      <div>
                        <label className="text-xs text-[color:var(--muted)]">Due date</label>
                        <input
                          type="date"
                          value={editDueDate}
                          onChange={(e) => setEditDueDate(e.target.value)}
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
                          className="rounded-2xl soft-border bg-white/70 px-4 py-2 text-sm font-medium text-[color:var(--foreground)] hover:bg-black/[0.04] dark:bg-black/10 dark:hover:bg-white/[0.06]"
                          type="button"
                        >
                          Cancel
                        </button>
                        <button
                          onClick={() => void saveEdit(t.id)}
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
                        <div className="flex items-center gap-2">
                          <div className="font-medium">{t.title}</div>
                          <span className="rounded-full soft-border bg-white/70 px-2 py-0.5 text-xs text-[color:var(--muted)] dark:bg-black/10">
                            {t.status}
                          </span>
                          {t.dueDate ? (
                            <span className="text-xs text-[color:var(--muted)]">
                              due {toDateInputValue(t.dueDate)}
                            </span>
                          ) : null}
                        </div>
                        {t.notes ? (
                          <div className="mt-1 whitespace-pre-wrap text-sm text-[color:var(--muted)]">
                            {t.notes}
                          </div>
                        ) : null}
                      </div>
                      <div className="flex items-center gap-2">
                        <button
                          onClick={() => startEdit(t)}
                          className="rounded-xl px-3 py-1.5 text-sm text-[color:var(--muted)] hover:bg-black/[0.04] dark:hover:bg-white/[0.06]"
                        >
                          Edit
                        </button>
                        <button
                          onClick={() => void remove(t.id)}
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

