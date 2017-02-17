import Foundation
import IOKit.ps

let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array

let description = IOPSGetPowerSourceDescription(snapshot, sources[0]).takeRetainedValue() as Dictionary

// Apple provides Current Capacity from 0.0 to 100.0
// so it's a good indicator of battery %
print(description[kIOPSCurrentCapacityKey] as! Int)
