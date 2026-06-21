import Image from "next/image";

export function SectionHero(props: {
  title: string;
  subtitle?: string;
  rightMark?: "rings" | "none";
}) {
  const mark = props.rightMark ?? "rings";
  return (
    <header className="relative overflow-hidden rounded-3xl card px-6 py-6 sm:px-8">
      <div className="pointer-events-none absolute right-[-150px] top-[-190px] opacity-55 sm:opacity-65">
        <Image src="/floral-corner.svg" alt="" width={420} height={420} />
      </div>
      <div className="flex items-start justify-between gap-6">
        <div>
          <h1 className="text-2xl font-semibold tracking-tight sm:text-3xl">
            {props.title}
          </h1>
          {props.subtitle ? (
            <p className="mt-2 max-w-2xl text-sm text-[color:var(--muted)] sm:text-base">
              {props.subtitle}
            </p>
          ) : null}
        </div>
        {mark === "rings" ? (
          <div className="hidden sm:block">
            <Image src="/rings-mark.svg" alt="" width={64} height={64} />
          </div>
        ) : null}
      </div>
    </header>
  );
}

