#!/usr/bin/env python3

# Copyright (C) 2022 Julian Müller (W13R)
# License: MIT

# A veeery simple templating cli tool using pythons format function


# some imports:

from argparse import ArgumentParser
from json import load
from pathlib import Path


# the actual function that formats the template

def format_template(template:str, variables:dict) -> str:
    try:
        return template.format(**variables)
    except KeyError as e:
        print("An error occured!")
        print(f"Unknown variable: {e.args[0]}")
        exit(1)


# cli and io things

if __name__ == "__main__":

    # command line argument parsing

    argparser = ArgumentParser(description="A very simple formatter that takes a template and a json file containing the variables.")
    argparser.add_argument("-t", "--template", metavar="FILE", help="The path to the template file", required=True, type=str)
    argparser.add_argument("-j", "--json", metavar="FILE", help="The path to the json file containing the variables", required=True, type=str)
    argparser.add_argument("-o", "--out", metavar="FILE", help="The path to the output file", required=True, type=str)
    args = argparser.parse_args()

    # read

    with Path(args.json).open("r") as json_file:
        variables = load(json_file)
    
    with Path(args.template).open("r") as template_file:
        template = template_file.read()
    
    # process the files

    output = format_template(template, variables)

    # write

    with Path(args.out).open("w") as output_file:
        output_file.write(output)
