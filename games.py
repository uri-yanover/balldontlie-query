#!/usr/bin/env python3
import urllib.request
import urllib.parse
import json
import sys
from typing import List
from calendar import monthrange


def get_game_data(year: int, month: int) -> List[dict]:
    if year < 1900:
        raise ValueError('Year must be an integer greater than 1900')
    if month < 1 or month > 12:
        raise ValueError('Month must be an integer in the range 1..12')

    # Creating a PoolManager instance for sending requests.
    page = 0
    result = []
    last_day = monthrange(year, month)[1]

    start_date = f'{year:04d}-{month:02d}-01'
    end_date = f'{year:04d}-{month:02d}-{last_day:02d}'

    # Sending a GET request and getting back response as HTTPResponse object.
    while True:
        url_string = urllib.parse.urlunparse(
            urllib.parse.ParseResult(scheme='https', netloc='www.balldontlie.io', path='/api/v1/games',
                                     params='', query=urllib.parse.urlencode(
                                         (('start_date', start_date),
                                          ('end_date', end_date),
                                          ('page', page),
                                          ('per_page', 100))
                                     ), fragment=''))

        with urllib.request.urlopen(url_string) as resp:
            if resp.status != 200:
                raise RuntimeError(f"Received invalid status {resp.status}")

            # Print the returned data.
            parsed = json.loads(resp.read())
            result.extend(parsed.get('data', []))
            page = parsed.get("meta", {}).get("next_page")

        if page is None:
            break
    return result


if __name__ == '__main__':
    if len(sys.argv) != 3:
        raise RuntimeError(f'{sys.argv[0]} <year> <month>')
    print(json.dumps(get_game_data(
        int(sys.argv[1]), int(sys.argv[2])), indent=4))
