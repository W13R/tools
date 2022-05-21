#!/usr/bin/env python3

# Copyright (C) 2022 Julian Müller (W13R)
# License: MIT


from argparse import ArgumentParser
from shlex import split
from shutil import which
from subprocess import run
from urllib.parse import urlsplit


git_clone = "clone {url} {dirname}"


if __name__ == "__main__":

    ap = ArgumentParser(description="Backup remote git repo")
    ap.add_argument("url", type=str, help="HTTPS URL from the git repo to clone from")
    args = ap.parse_args()

    git_exec = which("git")

    if git_exec is None:
        raise Exception("Couldn't find git executable!")

    url = args.url
    url_components = urlsplit(url)
    dirname = f"{url_components.netloc}{url_components.path}".replace("/", "_")

    run(
        split(f"{git_exec} {git_clone.format(url=url, dirname=dirname)}")
    )
