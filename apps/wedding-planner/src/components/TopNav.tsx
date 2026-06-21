import Link from "next/link";

const nav = [
  { href: "/", label: "Home" },
  { href: "/tasks", label: "Tasks" },
  { href: "/vendors", label: "Vendors" },
  { href: "/budget", label: "Budget" },
  { href: "/guests", label: "Guests" },
] as const;

export function TopNav() {
  return (
    <nav className="soft-border border-x-0 border-t-0 bg-white/70 backdrop-blur dark:bg-black/20">
      <div className="mx-auto flex max-w-5xl items-center justify-between px-6 py-3">
        <Link href="/" className="flex items-baseline gap-2">
          <span className="text-sm font-semibold tracking-[0.2em] text-[color:var(--accent-2)]">
            WEDDING
          </span>
          <span className="font-semibold tracking-tight">Planner</span>
        </Link>
        <div className="flex items-center gap-1">
          {nav.map((i) => (
            <Link
              key={i.href}
              href={i.href}
              className="rounded-xl px-3 py-1.5 text-sm text-[color:var(--muted)] hover:bg-black/[0.04] dark:hover:bg-white/[0.06]"
            >
              {i.label}
            </Link>
          ))}
        </div>
      </div>
    </nav>
  );
}

