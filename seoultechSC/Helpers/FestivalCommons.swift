import Foundation
import CoreLocation

class FestivalCommons {
    static let shared = FestivalCommons()
    
    let stampList = [
        Stamp(name: "game", location: CLLocationCoordinate2D(latitude: 37.6319, longitude: 127.079)),
        Stamp(name: "yard", location: CLLocationCoordinate2D(latitude: 37.632310, longitude: 127.077111)),
        Stamp(name: "stage", location: CLLocationCoordinate2D(latitude: 37.6294, longitude: 127.0787)),
        Stamp(name: "bungeobang", location: CLLocationCoordinate2D(latitude: 37.633061, longitude: 127.078598)),
        Stamp(name: "photo", location: CLLocationCoordinate2D(latitude: 37.633930, longitude: 127.077845)),
    ]

    private init(){}
}
