#!/usr/bin/env python

import sys
import psutil

# Returns the current CPU usage percentage
def get_cpu_temperature(temperatures=None):
    if "k10temp" in temperatures:
        for entry in temperatures["k10temp"]:
            if entry.label == "Tctl":
                return f"{entry.current - 7.5}°C"
            
def get_gpu_temperature(temperatures=None):
    if "amdgpu" in temperatures:
        for entry in temperatures["amdgpu"]:
            if entry.label == "edge":
                return f"{entry.current}°C"

if __name__ == "__main__":
    temperatures = psutil.sensors_temperatures()
    
    if sys.argv[1] == "cpu":
        print(get_cpu_temperature(temperatures))
    elif sys.argv[1] == "gpu":
        print(get_gpu_temperature(temperatures))
