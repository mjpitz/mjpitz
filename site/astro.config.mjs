import { defineConfig } from "astro/config";
import mdx from "@astrojs/mdx";
import sitemap from "@astrojs/sitemap";
import tailwind from "@astrojs/tailwind";
import preact from "@astrojs/preact";
import { SITE_BASE_URL } from "./src/consts";
import mermaid from "astro-mermaid";

// https://astro.build/config
export default defineConfig({
    site: SITE_BASE_URL,
    integrations: [
        mermaid({
            autoTheme: true,
            iconPacks: [
                {
                    name: "logos",
                    loader: () => fetch("https://unpkg.com/@iconify-json/logos@1/icons.json").then((res) => res.json()),
                },
                {
                    name: "iconoir",
                    loader: () =>
                        fetch("https://unpkg.com/@iconify-json/iconoir@1/icons.json").then((res) => res.json()),
                },
            ],
        }),
        mdx(),
        sitemap(),
        tailwind({
            applyBaseStyles: false, // We'll keep our custom base styles
        }),
        preact(),
    ],
    markdown: {
        syntaxHighlight: "shiki",
        gfm: true,
    },
    image: {
        domains: ["i.ytimg.com"], // Allow YouTube thumbnails
    },
});
