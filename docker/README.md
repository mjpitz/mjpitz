# Docker

This directory contains the various docker containers that I build maintain, primarily for my own use.

- [catalog](catalog) - A service catalog listing out various services and links associated with them.
- [drone-server](drone-server) - An unrestricted Drone.IO server image intended for personal use.
- [presto](presto) - A minimal PrestoDB deployment intended to be backed by S3.
- [redis](redis) - A canonical Redis image for managing in-memory data structures.
- [redis-raft](redis-raft) - A Redis deployment that's backed by RAFT instead of its traditional replication mechanisms.
- [rspamd](rspamd) - Boxes rspamd into a container for use as a sidecar with maddy.
- [taky](taky) - An open source TAK Server implementation in python.

## License

Due to the variance in licensing between systems, this directory is not licensed itself. Instead, see the `image.conf` 
file in each directory for the licensing associated with that container.
