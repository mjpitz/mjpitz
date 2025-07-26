# Digital Ocean Infrastructure

This directory contains configurations and resources for services hosted in DigitalOcean's cloud platform. DigitalOcean provides reliable cloud infrastructure that I use for various public-facing services.

## Overview

In addition to my at-home cluster, I maintain several resources in DigitalOcean. The service has generally provided good support, though I experienced a data loss incident with an early bug in their Kubernetes CSI driver that affected my MySQL database.

## Directory Structure

- [admin](admin/) - Administrative configurations and resources
- [mya](mya/) - Personal project assets and configurations

## Component Details

### [Admin](admin/)

Contains administrative resources and configurations, including:
- Access management
- Platform configuration
- Monitoring setups

### [Mya](mya/)

Personal project resources hosted in DigitalOcean, including:
- Application deployments
- Service configurations
- Project-specific resources

## Management

Resources are primarily managed through:
- DigitalOcean's web interface
- Configuration files in this repository
- API-based automation where applicable

## Getting Started

To work with these resources, you'll need:
1. DigitalOcean account access
2. Appropriate API tokens
3. Understanding of the specific resources being managed
