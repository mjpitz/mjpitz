// Copyright (C) 2022 Mya Pitzeruse
// The MIT License (MIT)

package catalog

import (
	_ "embed"
	"encoding/json"
	"flag"
	"html/template"
	"log"
	"net/http"

	"github.com/mjpitz/mjpitz/apps/emc/internal/catalog/service"
)

//go:embed index.html.tpl
var catalog string

// Spec defines the requirements for hosting a catalog.
type Spec struct {
	Services []service.Spec
}

// Option defines an optional component of the spec.
type Option func(spec *Spec)

// Service registers a known service with the catalog.
func Service(label string, options ...service.Option) Option {
	return func(spec *Spec) {
		spec.Services = append(spec.Services, service.New(label, options...))
	}
}

// Serve provides command line functionality for running the service catalog.
func Serve(options ...Option) {
	addr := flag.String("bind_address", "127.0.0.1:8080", "")
	flag.Parse()

	t := template.Must(template.New("catalog").Parse(catalog))

	spec := Spec{}
	for _, opt := range options {
		opt(&spec)
	}

	http.HandleFunc("/api/v1/services", func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			w.Header().Add("Content-Type", "application/json")
			_ = json.NewEncoder(w).Encode(spec.Services)
		default:
			w.WriteHeader(http.StatusMethodNotAllowed)
		}
	})

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		_ = t.Execute(w, spec)
	})

	log.Printf("serving on %s\n", *addr)
	err := http.ListenAndServe(*addr, http.DefaultServeMux)
	if err != nil {
		panic(err)
	}
}
