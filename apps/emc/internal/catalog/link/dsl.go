// Copyright (c) 2022 Mya Pitzeruse
// The MIT License (MIT)

package link

// New constructs a link from the given label and url.
func New(label, url string) Spec {
	return Spec{
		Label: label,
		URL:   url,
	}
}

// Spec defines the elements needed to render a link.
type Spec struct {
	Label string
	URL   string
}
