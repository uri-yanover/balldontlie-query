# `balldontlie-query`

[BallDontLie](https://www.balldontlie.io) is a great API to fetch basketball data, which can be used for various data science (toy) projects.

This repo contains the implementations necessary to access the API data without going into the technical details of how to properly access the API.

A Python implementation is provided that's supposed to work on most recent Linuxes (stock Python>=3.6), and a PowerShell implementation is provided for Windows system.

The enclosed scripts are runnable as command-line apps, so they may be used from other programming languages in the following paradigm:

```python
from json import loads
from subprocess import check_output
from sys import executable  # get path of Python interpreter
from pprint import pprint  # only necessary for printing in this example

# need to be strings for subprocess
year = '2019'
month = '5'   

output = check_output((executable, '/path/to/games.py', year, month))
parsed_output = loads(output)
# et voilà !

pprint(parsed_output)
```