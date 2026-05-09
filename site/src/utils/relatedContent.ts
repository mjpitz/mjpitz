import type { CollectionEntry } from 'astro:content';

/**
 * Get all posts in the same series as the current post, sorted by publication date
 */
export function getSeriesPosts(
    allPosts: CollectionEntry<'blog'>[],
    currentPost: CollectionEntry<'blog'>
): CollectionEntry<'blog'>[] {
    const seriesTitle = currentPost?.data?.series?.title;
    
    if (!seriesTitle) {
        return [];
    }
    
    return allPosts
        .filter(post => post?.data?.series?.title === seriesTitle)
        .sort((a, b) => {
            const dateA = a?.data?.pubDate?.valueOf() || 0;
            const dateB = b?.data?.pubDate?.valueOf() || 0;
            return dateA - dateB;
        });
}

/**
 * Calculate similarity score between two posts based on tags, title, and description
 */
function calculateSimilarity(
    post1: CollectionEntry<'blog'>,
    post2: CollectionEntry<'blog'>
): number {
    // Ensure both posts have valid data
    if (!post1?.data || !post2?.data) {
        return 0;
    }
    
    let score = 0;
    
    // Tag matching (highest weight)
    const tags1 = post1.data.tags;
    const tags2 = post2.data.tags;
    if (tags1 && tags1.length > 0 && tags2 && tags2.length > 0) {
        const tags1Set = new Set(tags1.map(t => t.toLowerCase()));
        const tags2Set = new Set(tags2.map(t => t.toLowerCase()));
        const commonTags = [...tags1Set].filter(tag => tags2Set.has(tag));
        score += commonTags.length * 3;
    }
    
    // Title keyword matching
    if (post1.data.title && post2.data.title) {
        const title1Words = post1.data.title.toLowerCase().split(/\s+/);
        const title2Words = post2.data.title.toLowerCase().split(/\s+/);
        const commonTitleWords = title1Words.filter(word => 
            word.length > 3 && title2Words.includes(word)
        );
        score += commonTitleWords.length * 2;
    }
    
    // Description keyword matching (lower weight)
    if (post1.data.description && post2.data.description) {
        const desc1Words = post1.data.description.toLowerCase().split(/\s+/);
        const desc2Words = post2.data.description.toLowerCase().split(/\s+/);
        const commonDescWords = desc1Words.filter(word => 
            word.length > 4 && desc2Words.includes(word)
        );
        score += commonDescWords.length * 0.5;
    }
    
    return score;
}

/**
 * Get related posts based on content similarity
 */
export function getRelatedPosts(
    allPosts: CollectionEntry<'blog'>[],
    currentPost: CollectionEntry<'blog'>,
    limit: number = 5
): CollectionEntry<'blog'>[] {
    const postsWithScores = allPosts
        .filter(post => post.slug !== currentPost.slug)
        .map(post => ({
            post,
            score: calculateSimilarity(currentPost, post)
        }))
        .sort((a, b) => b.score - a.score);
    
    // If we have posts with similarity scores, use those
    const relatedWithScores = postsWithScores.filter(item => item.score > 0);
    if (relatedWithScores.length >= 3) {
        return relatedWithScores.slice(0, limit).map(item => item.post);
    }
    
    // Fallback: return most recent posts (excluding current post)
    return allPosts
        .filter(post => post.slug !== currentPost.slug)
        .sort((a, b) => {
            const dateA = b?.data?.pubDate?.valueOf() || 0;
            const dateB = a?.data?.pubDate?.valueOf() || 0;
            return dateA - dateB;
        })
        .slice(0, limit);
}
