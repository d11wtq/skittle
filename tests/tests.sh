#!/bin/bash

# test suite is just a dependency
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
$DIR/../needy.sh example
