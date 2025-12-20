#!/usr/bin/env python

import time
import psutil

# Returns the current disk usage percentage
def get_uptime():
    current = time.time()
    boot = psutil.boot_time()

    return f"{int(current - boot) // 60} mins"

if __name__ == "__main__":
    print(get_uptime())
