import { SITE_BASE_URL } from "../consts";

const robots = `
User-agent: *
Allow: /

Sitemap: ${SITE_BASE_URL}/sitemap-index.xml
`;

export async function GET(context) {
    return new Response(robots);
}
