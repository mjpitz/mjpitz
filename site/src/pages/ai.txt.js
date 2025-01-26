const robots = `
User-agent: *
Disallow: /
Disallow: *
`;

export async function GET(context) {
    return new Response(robots);
}
