#!/usr/bin/python3 -u

import json
import sys

def decode_ansi_escape(message):
    if isinstance(message, list):
        byte_string = bytes(message)
        return byte_string.decode('utf-8', errors='backslashreplace')
    else:
        return message

def process_journal_json():
    for line in sys.stdin:
        try:
            log_entry = json.loads(line.strip())
            if 'MESSAGE' in log_entry:
                log_entry['MESSAGE'] = decode_ansi_escape(log_entry['MESSAGE'])
            print(json.dumps(log_entry, ensure_ascii=False))
        except json.JSONDecodeError as e:
            continue

if __name__ == "__main__":
    process_journal_json()
