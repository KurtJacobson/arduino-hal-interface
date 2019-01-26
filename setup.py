#!/usr/bin/env python

from setuptools import setup, find_packages

with open("README.md", "r") as fh:
    long_description = fh.read()

setup(
    name='halintf',
    version='1.0',
    description='Arduino Interface for LinuxCNC HAL',
    author='Jeff Epler',
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://emergent.unpythonic.net/01198594294",
    download_url="https://github.com/kurtjacobson/halintf/tarball/master",
    packages=find_packages(),
    include_package_data=True,
    entry_points={
        'console_scripts': [
            'halintf=halintf:main',
        ]
    },
    install_requires=[
      'pyserial',
    ],
)