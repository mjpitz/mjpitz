const robots = `
User-agent: *
Allow: /
`

export async function GET(context) {
    return new Response(robots);
}
