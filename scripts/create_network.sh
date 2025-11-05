#!/usr/bin/env bash
set -e
podman network inspect cybernet >/dev/null 2>&1 || podman network create cybernet
