import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';
import {SITE_BASE_URL} from "./src/consts";

// https://astro.build/config
export default defineConfig({
	site: SITE_BASE_URL,
	integrations: [
		mdx(),
		sitemap(),
	],
	markdown: {
		syntaxHighlight: 'shiki',
	},
});
