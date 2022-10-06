#!/bin/bash

RUN_PORT=${PORT:-8030}

PORT=$RUN_PORT julia server.jl