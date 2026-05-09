/** @type {import('tailwindcss').Config} */
export default {
    content: ["./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}"],
    darkMode: ["class", '[data-theme="dark"]'],
    theme: {
        extend: {
            colors: {
                accent: {
                    DEFAULT: "#8758ff",
                    dark: "#8758ff",
                },
                heather: {
                    gray: "#373737",
                },
            },
            fontFamily: {
                atkinson: ["Atkinson", "sans-serif"],
            },
            typography: {
                DEFAULT: {
                    css: {
                        maxWidth: "800px",
                    },
                },
            },
        },
    },
    plugins: [],
};
