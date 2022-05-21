// Copyright (c) 2022 Mya Pitzeruse
// The MIT License (MIT)

package linkgroup

import (
	"github.com/mjpitz/mjpitz/apps/emc/internal/catalog/link"
)

func New(label string, options ...Option) Spec {
	spec := Spec{
		Label: label,
	}

	for _, opt := range options {
		opt(&spec)
	}

	return spec
}

// Option defines an optional component of the spec.
type Option func(spec *Spec)

// Spec defines the elements needed to render a link group.
type Spec struct {
	Label string
	Links []link.Spec
}

func Link(label, url string) Option {
	return func(spec *Spec) {
		spec.Links = append(spec.Links, link.New(label, url))
	}
}
