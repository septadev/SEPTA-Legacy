// Septa. 2017

import Foundation

class GeoCompare {
    // compares two points
    class func point(_ p1: Double, _ p2: Double) -> Bool {
        return abs(abs(p1) - abs(p2)) < 0.000001
    }
}
