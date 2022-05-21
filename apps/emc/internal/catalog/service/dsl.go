// Copyright (C) 2022 Mya Pitzeruse
// The MIT License (MIT)

package service

import (
	"github.com/mjpitz/mjpitz/apps/emc/internal/catalog/linkgroup"
)

// New constructs a spec given a label and set of options.
func New(label string, options ...Option) Spec {
	spec := Spec{
		Label:    label,
		Metadata: make(map[string]string),
	}

	for _, opt := range options {
		opt(&spec)
	}

	return spec
}

// Option defines an optional component of the spec.
type Option func(spec *Spec)

// Spec defines the elements needed to render a service.
type Spec struct {
	Label       string
	LogoURL     string
	Description string
	URL         string
	Metadata    map[string]string
	LinkGroups  []linkgroup.Spec
}

// LogoURL configures the icon for the service.
func LogoURL(url string) Option {
	return func(spec *Spec) {
		spec.LogoURL = url
	}
}

// Description specifies a short, brief description about the service.
func Description(description string) Option {
	return func(spec *Spec) {
		spec.Description = description
	}
}

// URL configures the services public facing URL that's presented to end users.
func URL(url string) Option {
	return func(spec *Spec) {
		spec.URL = url
	}
}

// Metadata allows additional metadata to be attached to a service.
func Metadata(key, value string) Option {
	return func(spec *Spec) {
		spec.Metadata[key] = value
	}
}

// LinkGroup appends a group of links to the provided service.
func LinkGroup(label string, options ...linkgroup.Option) Option {
	return func(spec *Spec) {
		spec.LinkGroups = append(spec.LinkGroups, linkgroup.New(label, options...))
	}
}
