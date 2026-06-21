import Link from "next/link";
import Image from "next/image";

const cards = [
  {
    title: "Tasks",
    description: "Your planning checklist (add, complete, edit).",
    href: "/tasks",
  },
  {
    title: "Vendors",
    description: "Shortlist, quotes, and booking status.",
    href: "/vendors",
  },
  {
    title: "Budget",
    description: "Targets vs actuals and pending quotes.",
    href: "/budget",
  },
  {
    title: "Guests",
    description: "Guest list with RSVP tracking.",
    href: "/guests",
  },
] as const;

export default function Home() {
  return (
    <div className="flex flex-1 justify-center px-6 py-10">
      <main className="w-full max-w-5xl">
        <header className="relative overflow-hidden rounded-3xl card px-6 py-7 sm:px-8">
          <div className="pointer-events-none absolute right-[-140px] top-[-180px] opacity-60 sm:opacity-70">
            <Image
              src="/floral-corner.svg"
              alt=""
              width={420}
              height={420}
              priority
            />
          </div>
          <div className="flex items-start justify-between gap-6">
            <div>
              <div className="text-xs font-semibold tracking-[0.35em] text-[color:var(--accent-2)]">
                YOUR DAY, YOUR WAY
              </div>
              <h1 className="mt-2 text-3xl font-semibold tracking-tight sm:text-4xl">
                Wedding planner
              </h1>
              <p className="mt-2 max-w-2xl text-sm text-[color:var(--muted)] sm:text-base">
                A calm, local-first dashboard for tasks, vendors, budget, and guests.
              </p>
            </div>
            <div className="hidden sm:block">
              <Image src="/rings-mark.svg" alt="" width={72} height={72} />
            </div>
          </div>
        </header>

        <section className="mt-6 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {cards.map((c) => (
            <Link
              key={c.href}
              href={c.href}
              className="group rounded-3xl card p-5 transition hover:-translate-y-0.5 hover:shadow-xl"
            >
              <div className="flex items-start justify-between gap-4">
                <div>
                  <div className="text-lg font-semibold">{c.title}</div>
                  <div className="mt-1 text-sm text-[color:var(--muted)]">
                    {c.description}
                  </div>
                </div>
                <div className="text-[color:var(--muted)]/60 transition group-hover:text-[color:var(--accent)]">
                  →
                </div>
              </div>
            </Link>
          ))}
        </section>

        <section className="mt-6 rounded-3xl card p-5 text-sm">
          <div className="font-medium">Tip</div>
          <div className="mt-1 text-[color:var(--muted)]">
            When you run this on your PC, open it on your phone at{" "}
            <span className="font-mono">http://&lt;PC_LAN_IP&gt;:3000</span>.
          </div>
        </section>
      </main>
    </div>
  );
}
