#!/usr/bin/env python3
"""Build the Cognito Lambda zips that are committed next to their sources.

The zips are committed because Terrakube runs each step in a fresh work dir, so
a zip generated during plan (data "archive_file") is missing during apply.

Run from the repository root after changing any Lambda source:

    python3 lambda/build.py

Output is deterministic (sorted entries, fixed timestamps and permissions), so
rebuilding unchanged sources produces identical zips and no Terraform diff.
"""

import os
import sys
import zipfile

LAMBDAS = {
    "vic": [
        "amplify_login_create_auth_challenge",
        "amplify_login_define_auth_challenge",
        "amplify_login_verify_auth_challenge_response",
        "amplify_login_custom_message",
    ],
    "ngohub": [
        "amplify_login_create_auth_challenge",
        "amplify_login_define_auth_challenge",
        "amplify_login_verify_auth_challenge_response",
        "amplify_login_custom_message",
        "login_pre_authentication_check",
    ],
}

FIXED_DATE_TIME = (1980, 1, 1, 0, 0, 0)


def build(source_dir, output_path):
    files = []
    for root, dirs, names in os.walk(source_dir):
        dirs.sort()
        for name in sorted(names):
            files.append(os.path.join(root, name))

    with zipfile.ZipFile(output_path, "w") as archive:
        for path in files:
            info = zipfile.ZipInfo(os.path.relpath(path, source_dir), FIXED_DATE_TIME)
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o644 << 16
            with open(path, "rb") as f:
                archive.writestr(info, f.read())


def main():
    base = os.path.dirname(os.path.abspath(__file__))
    for app, names in LAMBDAS.items():
        for name in names:
            source_dir = os.path.join(base, app, name)
            output_path = os.path.join(base, app, f"{name}.zip")
            if not os.path.isdir(source_dir):
                sys.exit(f"missing Lambda source: {source_dir}")
            build(source_dir, output_path)
            print(os.path.relpath(output_path, os.path.dirname(base)))


if __name__ == "__main__":
    main()
