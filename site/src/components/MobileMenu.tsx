import { useState } from "preact/hooks";

interface MobileMenuProps {
    currentPath: string;
}

export default function MobileMenu({ currentPath }: MobileMenuProps) {
    const [isOpen, setIsOpen] = useState(false);

    const links = [
        { href: "/", label: "About" },
        { href: "/blog", label: "Blog" },
        { href: "/charts", label: "Charts" },
        { href: "/media", label: "Media" },
        { href: "/collab", label: "Collaborate" },
        { href: "/ai", label: "AI" },
    ];

    return (
        <div className="mobile-menu">
            <button
                className="hamburger"
                onClick={() => setIsOpen(!isOpen)}
                aria-label="Toggle menu"
                aria-expanded={isOpen}
            >
                <span className={isOpen ? "open" : ""}></span>
                <span className={isOpen ? "open" : ""}></span>
                <span className={isOpen ? "open" : ""}></span>
            </button>

            {isOpen && (
                <div className="menu-overlay" onClick={() => setIsOpen(false)}>
                    <nav className="menu-content" onClick={(e: any) => e.stopPropagation()}>
                        {links.map((link) => (
                            <a
                                key={link.href}
                                href={link.href}
                                className={currentPath === link.href ? "active" : ""}
                                onClick={() => setIsOpen(false)}
                            >
                                {link.label}
                            </a>
                        ))}
                    </nav>
                </div>
            )}
        </div>
    );
}
