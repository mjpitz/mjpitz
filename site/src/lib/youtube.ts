interface YouTubeVideo {
    id: string;
    title: string;
    description: string;
    thumbnail: string;
    publishedAt: string;
}

interface PlaylistResponse {
    items: Array<{
        snippet: {
            title: string;
            description: string;
            thumbnails: {
                high: {
                    url: string;
                };
            };
            resourceId: {
                videoId: string;
            };
            publishedAt: string;
        };
    }>;
    nextPageToken?: string;
}

export async function getPlaylistVideos(
    playlistId: string,
    maxResults: number = 50
): Promise<YouTubeVideo[]> {
    const apiKey = import.meta.env.YOUTUBE_API_KEY;

    if (!apiKey) {
        console.warn("YouTube API key not found. Returning empty array.");
        return [];
    }

    try {
        const url = new URL(
            "https://www.googleapis.com/youtube/v3/playlistItems"
        );
        url.searchParams.set("part", "snippet");
        url.searchParams.set("playlistId", playlistId);
        url.searchParams.set("maxResults", maxResults.toString());
        url.searchParams.set("key", apiKey);

        const response = await fetch(url.toString());

        if (!response.ok) {
            throw new Error(
                `YouTube API error: ${response.status} ${response.statusText}`
            );
        }

        const data: PlaylistResponse = await response.json();

        return data.items.map((item) => ({
            id: item.snippet.resourceId.videoId,
            title: item.snippet.title,
            description: item.snippet.description,
            thumbnail: item.snippet.thumbnails.high.url,
            publishedAt: item.snippet.publishedAt,
        }));
    } catch (error) {
        console.error(`Failed to fetch playlist ${playlistId}:`, error);
        return [];
    }
}

export const PLAYLISTS = {
    algorithms: {
        id: "PLa04_J9h9AKxJfGH2Qgdw5JH8yhbiV4_h",
        title: "Algorithms",
    },
    arpeggios: {
        id: "PLa04_J9h9AKwk96XQ96rF1OkvRUH-u-jy",
        title: "Arpeggios",
    },
} as const;
