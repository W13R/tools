#!/usr/bin/env python3

# Copyright (C) 2022 Julian Müller (W13R)
# All rights reserved.


# This script downloads the markdown file of a hedgedoc document
# This only works with hedgedoc instances secured with keycloak


import requests
import argparse

from html import unescape
from getpass import getpass
from pathlib import Path


if __name__ == "__main__":

    # parse cmdline args
    ap = argparse.ArgumentParser(description="Hedgedoc Downloader (Keycloak Authentication)")
    ap.add_argument("url", type=str, help="The url of the hedgedoc document")
    ap.add_argument("username", type=str, help="login username")
    ap.add_argument("-o", "--output", type=str, help="output file path")
    ap.add_argument("-p", "--password", type=str, help="login password (will be asked for on the commandline if omitted)")
    args = ap.parse_args()

    dl_url = args.url.rstrip("#")\
            .rstrip("/")\
                .replace("/download", "")\
                    .replace("?both", "")\
                        .replace("?edit", "")\
                            .replace("?view", "") + "/download"
    
    username = args.username
    output_fp = args.output
    
    if args.password is None:
        password = getpass()
    else:
        password = args.password

    # session
    s = requests.Session()

    print("Authenticating...")

    # login page
    url_parts = requests.utils.urlparse(dl_url)
    login_url = f"{url_parts.scheme}://{url_parts.netloc}/auth/oauth2"
    auth_page_req = s.get(
        login_url,
        headers = {
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36"
        }
    )

    # get authenticate url from html
    auth_page_content = auth_page_req.content.decode()
    substr1 = '<form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="'
    substr2 = '"'
    first_form_action = auth_page_content.find(substr1) + len(substr1)
    first_quotes_after_form_action = auth_page_content.find(substr2, first_form_action)
    authenticate_url = unescape(auth_page_content[first_form_action:first_quotes_after_form_action])

    # authenticate
    authenticate_api_req = s.post(
        authenticate_url,
        data = f"username={username}&password={password}&credentialId=",
        headers = {
            "content-type": "application/x-www-form-urlencoded",
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36"
        }
    )

    if "/authenticate?" in requests.utils.urlparse(authenticate_api_req.url).path or b"Invalid username or password" in authenticate_api_req.content:
        exit("Authentication failed.")
    
    print("Downloading...")

    # download md document
    document_dl_req = s.get(dl_url)
    document = document_dl_req.content.decode()

    # get filename from content-disposition header if not specified in args
    if output_fp is None:
        output_fp = requests.utils.unquote(
            document_dl_req.headers["content-disposition"].replace("attachment; filename=", "")
        ).replace("/", "_").replace("\\", "_").replace("  ", " ")

    # save md document
    with Path(output_fp).open("w") as f:
        f.write(document)
    
    print(f"Saved to '{Path(output_fp).absolute().__str__()}'")
