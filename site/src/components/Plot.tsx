import { useEffect, useRef, useState } from "preact/hooks";
import type * as PlotNS from "@observablehq/plot";

type PlotOptions = Parameters<typeof PlotNS.plot>[0];

// A JSON-serializable mark descriptor. Resolved to an actual Plot mark inside
// the client-side effect — passing pre-built marks as props does not survive
// Astro's client:only prop serialization (their internal functions become null).
interface MarkSpec {
    type: keyof typeof PlotNS;
    data?: unknown;
    options?: Record<string, unknown>;
}

interface PlotProps {
    // Standard Plot options minus marks (scales, axes, dimensions, color, etc.).
    options?: Omit<PlotOptions, "marks">;
    // Mark descriptors resolved at render time via Plot[type](data, options).
    marks: MarkSpec[];
    className?: string;
    ariaLabel?: string;
}

export default function Plot({ options, marks, className, ariaLabel }: PlotProps) {
    const containerRef = useRef<HTMLDivElement>(null);
    const [width, setWidth] = useState<number>(640);

    useEffect(() => {
        if (!containerRef.current) return;
        const el = containerRef.current;
        const ro = new ResizeObserver((entries) => {
            const w = Math.floor(entries[0].contentRect.width);
            if (w > 0) setWidth(w);
        });
        ro.observe(el);
        return () => ro.disconnect();
    }, []);

    useEffect(() => {
        let cancelled = false;
        const el = containerRef.current;
        if (!el) return;

        (async () => {
            const Plot = await import("@observablehq/plot");
            if (cancelled || !containerRef.current) return;

            const resolvedMarks = marks.map((m) => {
                const fn = (Plot as any)[m.type];
                if (typeof fn !== "function") {
                    throw new Error(`Plot: unknown mark type "${String(m.type)}"`);
                }
                return fn(m.data, m.options);
            });

            const spec: PlotOptions = {
                width,
                ...(options ?? {}),
                marks: resolvedMarks,
            };
            const node = Plot.plot(spec);
            el.replaceChildren(node);
        })();

        return () => {
            cancelled = true;
            if (el) el.replaceChildren();
        };
    }, [options, marks, width]);

    return (
        <div ref={containerRef} className={`plot-figure ${className ?? ""}`.trim()} role="img" aria-label={ariaLabel} />
    );
}
