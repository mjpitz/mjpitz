import type { Meta, StoryObj } from "@storybook/preact";
import Plot from "./Plot";

const meta: Meta<typeof Plot> = {
    title: "Components/Plot",
    component: Plot,
    parameters: {
        docs: {
            description: {
                component:
                    "Preact wrapper around Observable Plot. Renders a chart into a resizable container, dynamic-imports `@observablehq/plot` so the D3 chunk is only fetched on pages that use it. Marks are passed as JSON-serializable descriptors (`{ type, data, options }`) rather than pre-built Plot mark instances — this is required because Astro's `client:only` prop serialization strips functions.",
            },
        },
    },
    argTypes: {
        options: {
            control: "object",
            description: "Standard Plot options minus marks (scales, axes, dimensions, color).",
        },
        marks: {
            control: "object",
            description: "Array of mark descriptors. Resolved at render time via `Plot[type](data, options)`.",
        },
        ariaLabel: { control: "text" },
        className: { control: "text" },
    },
};

export default meta;
type Story = StoryObj<typeof Plot>;

const latency = [
    { endpoint: "/api/search", metric: "median", ms: 42 },
    { endpoint: "/api/search", metric: "p95", ms: 180 },
    { endpoint: "/api/search", metric: "p99", ms: 410 },
    { endpoint: "/api/checkout", metric: "median", ms: 88 },
    { endpoint: "/api/checkout", metric: "p95", ms: 240 },
    { endpoint: "/api/checkout", metric: "p99", ms: 620 },
    { endpoint: "/api/user", metric: "median", ms: 18 },
    { endpoint: "/api/user", metric: "p95", ms: 95 },
    { endpoint: "/api/user", metric: "p99", ms: 210 },
];

/**
 * Canonical reference — matches the chart embedded in
 * `src/content/blog/2026-07-03-latency-post.mdx`. Grouped bar chart with
 * value labels above each bar, using `fx` for outer grouping (endpoint)
 * and `x` for inner category (percentile).
 */
export const LatencyPercentiles: Story = {
    args: {
        ariaLabel: "Latency percentiles by endpoint",
        options: {
            height: 340,
            marginLeft: 60,
            subtitle: "API Latency",
            x: { axis: null, padding: 0.1 },
            fx: { label: "Endpoint" },
            y: { label: "ms", grid: true },
            color: { legend: true, domain: ["median", "p95", "p99"] },
        },
        marks: [
            {
                type: "barY",
                data: latency,
                options: { fx: "endpoint", x: "metric", y: "ms", fill: "metric" },
            },
            {
                type: "text",
                data: latency,
                options: {
                    fx: "endpoint",
                    x: "metric",
                    y: "ms",
                    text: "ms",
                    textAnchor: "middle",
                    dy: -6,
                    fontSize: 11,
                },
            },
            { type: "ruleY", data: [0] },
        ],
    },
};

/**
 * Simple single-series bar chart. The minimum viable configuration —
 * one mark, one data field for x, one for y.
 */
export const SimpleBar: Story = {
    args: {
        ariaLabel: "Requests per endpoint",
        options: {
            height: 280,
            y: { label: "requests", grid: true },
        },
        marks: [
            {
                type: "barY",
                data: [
                    { endpoint: "/api/search", requests: 12400 },
                    { endpoint: "/api/checkout", requests: 3800 },
                    { endpoint: "/api/user", requests: 9200 },
                ],
                options: { x: "endpoint", y: "requests", fill: "#8758ff" },
            },
            { type: "ruleY", data: [0] },
        ],
    },
};

/**
 * Time-series line chart. Uses `lineY` with a date-valued x channel.
 * Plot infers the scale type (utc) from the JS `Date` values in the data.
 */
export const TimeSeriesLine: Story = {
    args: {
        ariaLabel: "Daily p95 latency",
        options: {
            height: 280,
            y: { label: "p95 (ms)", grid: true },
            x: { label: "date" },
        },
        marks: [
            {
                type: "lineY",
                data: Array.from({ length: 30 }, (_, i) => ({
                    date: new Date(2026, 5, 1 + i),
                    ms: 180 + Math.round(40 * Math.sin(i / 3) + i * 2),
                })),
                options: { x: "date", y: "ms", stroke: "#8758ff", strokeWidth: 2 },
            },
            { type: "ruleY", data: [0] },
        ],
    },
};

/**
 * Scatter plot with a categorical color channel. Points sized by a third
 * numeric field via the `r` (radius) channel.
 */
export const Scatter: Story = {
    args: {
        ariaLabel: "Response size vs. latency",
        options: {
            height: 320,
            grid: true,
            x: { label: "response size (kb)" },
            y: { label: "latency (ms)" },
            color: { legend: true },
        },
        marks: [
            {
                type: "dot",
                data: [
                    { kb: 2, ms: 42, kind: "cached" },
                    { kb: 8, ms: 88, kind: "cached" },
                    { kb: 12, ms: 60, kind: "cached" },
                    { kb: 4, ms: 210, kind: "cold" },
                    { kb: 22, ms: 410, kind: "cold" },
                    { kb: 40, ms: 620, kind: "cold" },
                    { kb: 60, ms: 780, kind: "cold" },
                ],
                options: { x: "kb", y: "ms", stroke: "kind", r: 6 },
            },
        ],
    },
};

/**
 * Stacked area chart. Multiple series stacked via a `fill` channel keyed
 * on a categorical field. Plot's `areaY` mark stacks by default when a
 * `fill` channel is present.
 */
export const StackedArea: Story = {
    args: {
        ariaLabel: "Request mix over time",
        options: {
            height: 300,
            y: { label: "requests/s", grid: true },
            color: { legend: true },
        },
        marks: [
            {
                type: "areaY",
                data: Array.from({ length: 20 }, (_, i) => [
                    { t: i, kind: "read", n: 40 + i },
                    { t: i, kind: "write", n: 12 + Math.round(6 * Math.sin(i / 2)) },
                    { t: i, kind: "admin", n: 3 },
                ]).flat(),
                options: { x: "t", y: "n", fill: "kind" },
            },
            { type: "ruleY", data: [0] },
        ],
    },
};
