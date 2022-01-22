#!/usr/bin/env python3


# Copyright (C) 2022 Julian Müller (W13R)
# All rights reserved.

# Run a comman every n seconds


from argparse import ArgumentParser
from pathlib import Path
from shlex import split
from subprocess import call
from time import sleep
from time import time


if __name__ == "__main__":

    argparser = ArgumentParser(description="Command scheduler - Run a command every n seconds")
    argparser.add_argument("interval", type=int, help="The interval in seconds (minimum: 1)")
    argparser.add_argument("command", type=str, help="The command")
    args = argparser.parse_args()

    command_parts = split(args.command)
    interval = max(1, args.interval)

    last_step = 0

    while True:
        now = time()
        if now >= last_step + interval:
            call(command_parts)
            last_step = now
        sleep(0.5)
