import { useState, useEffect, useRef } from "preact/hooks";
import type { h } from "preact";

interface Video {
    id: string;
    title: string;
    description: string;
    thumbnail: string;
    publishedAt: string;
}

interface VideoGalleryProps {
    algorithmsVideos: Video[];
    arpeggiosVideos: Video[];
}

export default function VideoGallery({
    algorithmsVideos,
    arpeggiosVideos,
}: VideoGalleryProps) {
    const [activeTab, setActiveTab] = useState<"algorithms" | "arpeggios">(
        "algorithms"
    );
    const [selectedVideo, setSelectedVideo] = useState<string | null>(null);
    const [currentPage, setCurrentPage] = useState(0);
    const videoPlayerRef = useRef<HTMLDivElement>(null);

    const VIDEOS_PER_PAGE = 4;
    const currentVideos =
        activeTab === "algorithms" ? algorithmsVideos : arpeggiosVideos;
    
    const totalPages = Math.ceil(currentVideos.length / VIDEOS_PER_PAGE);
    const startIndex = currentPage * VIDEOS_PER_PAGE;
    const displayedVideos = currentVideos.slice(startIndex, startIndex + VIDEOS_PER_PAGE);

    // Reset to first page when switching tabs
    useEffect(() => {
        setCurrentPage(0);
    }, [activeTab]);

    // Scroll to video player when a video is selected
    useEffect(() => {
        if (selectedVideo && videoPlayerRef.current) {
            setTimeout(() => {
                videoPlayerRef.current?.scrollIntoView({
                    behavior: "smooth",
                    block: "start",
                });
            }, 100);
        }
    }, [selectedVideo]);

    const goToNextPage = () => {
        if (currentPage < totalPages - 1) {
            setCurrentPage(currentPage + 1);
        }
    };

    const goToPrevPage = () => {
        if (currentPage > 0) {
            setCurrentPage(currentPage - 1);
        }
    };

    return (
        <div className="video-gallery">
            {/* Tab Navigation */}
            <div className="tabs">
                <button
                    className={`tab ${activeTab === "algorithms" ? "active" : ""}`}
                    onClick={() => {
                        setActiveTab("algorithms");
                        setSelectedVideo(null);
                    }}
                    aria-label="View Algorithms playlist"
                >
                    <span className="tab-icon">💻</span>
                    <span className="tab-text">Algorithms</span>
                    <span className="tab-count">{algorithmsVideos.length}</span>
                </button>
                <button
                    className={`tab ${activeTab === "arpeggios" ? "active" : ""}`}
                    onClick={() => {
                        setActiveTab("arpeggios");
                        setSelectedVideo(null);
                    }}
                    aria-label="View Arpeggios playlist"
                >
                    <span className="tab-icon">🎹</span>
                    <span className="tab-text">Arpeggios</span>
                    <span className="tab-count">{arpeggiosVideos.length}</span>
                </button>
            </div>

            {/* Selected Video Player */}
            {selectedVideo && (
                <div className="video-player-container" ref={videoPlayerRef}>
                    <div className="video-player">
                        <iframe
                            src={`https://www.youtube.com/embed/${selectedVideo}?autoplay=1`}
                            title="YouTube video player"
                            frameBorder="0"
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                            allowFullscreen
                        ></iframe>
                    </div>
                    <button
                        className="close-video"
                        onClick={() => setSelectedVideo(null)}
                        aria-label="Close video"
                    >
                        ✕ Close Video
                    </button>
                </div>
            )}

            {/* Video Grid */}
            <div className="video-grid">
                {currentVideos.length === 0 ? (
                    <p className="no-videos">No videos found in this playlist.</p>
                ) : (
                    displayedVideos.map((video) => (
                        <div
                            key={video.id}
                            className="video-card"
                            onClick={() => setSelectedVideo(video.id)}
                            onKeyPress={(e: any) => {
                                if (e.key === "Enter" || e.key === " ") {
                                    setSelectedVideo(video.id);
                                }
                            }}
                            role="button"
                            tabIndex={0}
                            aria-label={`Play ${video.title}`}
                        >
                            <div className="video-thumbnail">
                                <img
                                    src={video.thumbnail}
                                    alt={video.title}
                                    loading="lazy"
                                />
                                <div className="play-overlay">
                                    <svg
                                        className="play-icon"
                                        viewBox="0 0 24 24"
                                        fill="currentColor"
                                    >
                                        <path d="M8 5v14l11-7z" />
                                    </svg>
                                </div>
                            </div>
                            <div className="video-info">
                                <h3 className="video-title">{video.title}</h3>
                                {video.description && (
                                    <p className="video-description">
                                        {video.description.slice(0, 120)}
                                        {video.description.length > 120 ? "..." : ""}
                                    </p>
                                )}
                            </div>
                        </div>
                    ))
                )}
            </div>

            {/* Navigation Buttons */}
            {currentVideos.length > VIDEOS_PER_PAGE && (
                <div>
                    <div className="carousel-nav">
                        <button
                            className="nav-button"
                            onClick={goToPrevPage}
                            disabled={currentPage === 0}
                            aria-label="Previous page"
                        >
                            ← Previous
                        </button>
                        <button
                            className="nav-button"
                            onClick={goToNextPage}
                            disabled={currentPage === totalPages - 1}
                            aria-label="Next page"
                        >
                            Next →
                        </button>
                    </div>


                    {/* Carousel Info */}
                    <div className="carousel-info">
                        <span className="page-indicator">
                            Page {currentPage + 1} of {totalPages} ({currentVideos.length} videos total)
                        </span>
                    </div>
                </div>
            )}
        </div>
    );
}
