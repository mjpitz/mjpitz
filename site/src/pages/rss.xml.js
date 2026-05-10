import rss from "@astrojs/rss";
import { getCollection } from "astro:content";
import { SITE_TITLE, SITE_DESCRIPTION } from "../consts";

const ASCENDING_PUBDATE = (a, b) => a.pubDate.valueOf() - b.pubDate.valueOf();

export async function GET(context) {
    const [blog, papers] = await Promise.all([
        getCollection("blog"),
        getCollection("papers"),
    ]);

    let all = [].concat(
        blog.map((p) => ({ ...p.data, link: `/blog/${p.slug}/` })),
        papers.map((p) => ({ ...p.data, link: `/papers/${p.slug}/` }))
    );

    return rss({
        title: SITE_TITLE,
        description: SITE_DESCRIPTION,
        site: context.site,
        items: all.sort(ASCENDING_PUBDATE),
    });
}
