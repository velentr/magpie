#!/bin/sh

# SPDX-FileCopyrightText: 2023 Brian Kubisiak <brian@kubisiak.com>
#
# SPDX-License-Identifier: GPL-3.0-only

export PATH="${PATH}:${PWD}"

exec "$@"
