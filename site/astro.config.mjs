import { defineConfig } from "astro/config";
import mdx from "@astrojs/mdx";
import sitemap from "@astrojs/sitemap";
import tailwind from "@astrojs/tailwind";
import preact from "@astrojs/preact";
import { SITE_BASE_URL } from "./src/consts";

// https://astro.build/config
export default defineConfig({
    site: SITE_BASE_URL,
    integrations: [
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
