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
 * Returns an object with the score and number of common tags
 */
function calculateSimilarity(
    post1: CollectionEntry<'blog'>,
    post2: CollectionEntry<'blog'>
): { score: number; commonTags: number } {
    // Ensure both posts have valid data
    if (!post1?.data || !post2?.data) {
        return { score: 0, commonTags: 0 };
    }
    
    let score = 0;
    let commonTagsCount = 0;
    
    // Tag matching (highest weight)
    const tags1 = post1.data.tags;
    const tags2 = post2.data.tags;
    if (tags1 && tags1.length > 0 && tags2 && tags2.length > 0) {
        const tags1Set = new Set(tags1.map(t => t.toLowerCase()));
        const tags2Set = new Set(tags2.map(t => t.toLowerCase()));
        const commonTags = [...tags1Set].filter(tag => tags2Set.has(tag));
        commonTagsCount = commonTags.length;
        score += commonTagsCount * 3;
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
    
    return { score, commonTags: commonTagsCount };
}

/**
 * Get related posts based on content similarity
 */
export function getRelatedPosts(
    allPosts: CollectionEntry<'blog'>[],
    currentPost: CollectionEntry<'blog'>,
    limit: number = 5
): CollectionEntry<'blog'>[] {
    // Safety check for undefined currentPost
    if (!currentPost || !currentPost.slug) {
        return [];
    }
    
    const postsWithScores = allPosts
        .filter(post => post && post.slug && post.slug !== currentPost.slug)
        .map(post => {
            const similarity = calculateSimilarity(currentPost, post);
            return {
                post,
                score: similarity.score,
                commonTags: similarity.commonTags
            };
        })
        .sort((a, b) => {
            // Primary sort: by similarity score (descending)
            if (b.score !== a.score) {
                return b.score - a.score;
            }
            // Secondary sort: by publication date (newer first)
            const dateA = a.post?.data?.pubDate?.valueOf() || 0;
            const dateB = b.post?.data?.pubDate?.valueOf() || 0;
            return dateB - dateA;
        });
    
    // Filter out posts with only 1 common tag (too weak of a relationship)
    // and posts with no similarity score
    const relatedWithScores = postsWithScores.filter(item => 
        item.score > 0 && (item.commonTags === 0 || item.commonTags >= 2)
    );
    
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
