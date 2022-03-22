#!/usr/bin/env python

from __future__ import print_function
import json as JSON
from os.path import isfile, join as path_join
from os import listdir, environ as ENV
import re
from subprocess import check_call, check_output
import sys
### Some things must be manually installed on Python2.7
if sys.version_info.major == 2:
    input = raw_input
    try:
        from configparser import ConfigParser
    except(ImportError):
        raise ImportError("Must pip install configparser for Python 2.x")
else:
    from configparser import ConfigParser

class AwsCliSso:
    """A class to collect AWS CLI SSO functionality.

    Collected functionality for AWS CLI SSO interaction.

    Attributes:
        sso_dir: The AWS SSO cache directory.
        config: The parsed AWS config file.
        creds_file: The path to the AWS credentials file.
        creds: The parsed (and modified) AWS credentials file.
        profiles: List of profile names from config.
        profile: The config section for the logged in profile.
    """
    CACHE_REGEX = re.compile(r"^[0-9a-f]+\.json$")
    AWS_PREFIX = ("aws", "--no-cli-pager", "--no-cli-auto-prompt")
    AWS_LOGIN = AWS_PREFIX + ("sso", "login", "--profile")
    AWS_GET_CREDS = AWS_PREFIX + ("sso", "get-role-credentials", "--access-token")
    SSO_KEYS = set(("sso_start_url", "sso_account_id", "sso_role_name", "sso_region"))
    ROLE_CREDS_MAPPING = {
        "accessKeyId": "aws_access_key_id",
        "sessionToken": "aws_session_token",
        "secretAccessKey" : "aws_secret_access_key"
    }

    def __init__(self):
        aws_dir = path_join(ENV["HOME"], ".aws")
        self._ = AwsCliSso
        self.sso_dir = path_join(aws_dir, "sso", "cache")
        config_file = path_join(aws_dir, "config")
        self.creds_file = path_join(aws_dir, "credentials")
        self.config = ConfigParser()
        self.creds = ConfigParser()
        self.config.read(config_file)
        self.profiles = [s[8:] for s in self.config.sections() if s.startswith("profile ")]
        self.profile = None
        self.creds.read(self.creds_file)
        if not self.creds.has_section("default"):
            self.creds.add_section("default")

    def set_profile(self, profile_name):
        section = self.config["profile " + profile_name]
        missing = self._.SSO_KEYS - set(section.keys())
        if len(missing) > 0:
            raise RuntimeError(
                "Missing configuration values for profile '%s': %s" % (
                    profile_name, ", ".join(missing)))
        check_call(self._.AWS_LOGIN + (profile_name,))
        self.profile = section

    def update_creds(self):
        cache_files = self.get_cache_files()
        if len(cache_files) != 1:
            raise RuntimeError("Unexpected difficulty finding access token JSON")
        with open(cache_files[0]) as file:
            token = JSON.load(file).get("accessToken")
        if token is None:
            raise RuntimeError("Unexpected difficulty finding access token JSON")
        role_creds_data = check_output(self._.AWS_GET_CREDS + (
            token,
            "--region", self.profile["sso_region"],
            "--account-id", self.profile["sso_account_id"],
            "--role-name", self.profile["sso_role_name"]
        ))
        role_creds = JSON.loads(role_creds_data).get("roleCredentials")
        if role_creds is None:
            raise RuntimeError("Unexpected difficulty getting role credentials")
        mapping = self._.ROLE_CREDS_MAPPING
        missing = set(mapping.keys()) - set(role_creds.keys())
        if len(missing) > 0:
            raise RuntimeError(
                "Missing values for role credentials: %s" % ", ".join(missing))
        for role_creds_key,cred_key in mapping.items():
            self.creds.set("default", cred_key, role_creds[role_creds_key])

    def write_creds(self):
        with open(self.creds_file, "w") as creds_file:
            self.creds.write(creds_file)

    def setup_creds_for_profile(self, profile_name):
        self.set_profile(profile_name)
        self.update_creds()
        self.write_creds()

    def get_cache_files(self):
        files = listdir(self.sso_dir)
        files = filter(self._.CACHE_REGEX.match, files)
        files = map(lambda f: path_join(self.sso_dir, f), files)
        files = filter(isfile, files)
        return list(files)



if __name__ == "__main__":
    from argparse import ArgumentParser
    parser = ArgumentParser(
        description="Use SSO to log into AWS and establish session credentials.")
    parser.add_argument("profile",
                        help="regular expression to select or filter profiles",
                        nargs='?')
    args = parser.parse_args()
    aws = AwsCliSso()
    profiles = list(aws.profiles)
    if args.profile is not None:
        profile_regex = re.compile(args.profile)
        profiles = [p for p in profiles if profile_regex.search(p)]
    profile_count = len(profiles)
    if profile_count == 0:
        print("No profiles found.", file=sys.stderr)
        sys.exit(1)
    if profile_count == 1:
        profile = profiles[0]
    else:
        selection = 0
        while selection < 1 or selection > profile_count:
            for n, p in enumerate(profiles):
                print("\t%2d. %s" % (n+1, p))
            selection = input("Selection (or q to quit): ")
            if selection == "q":
                sys.exit(0)
            try:
                selection = int(selection)
            except:
                selection = 0
        profile = profiles[selection-1]
    aws.setup_creds_for_profile(profile)

