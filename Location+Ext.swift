import CoreLocation
import Foundation

extension CLLocationCoordinate2D {
    func bearing(to point: CLLocationCoordinate2D) -> Double {
        func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
        func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }

        let lat1 = degreesToRadians(latitude)
        let lon1 = degreesToRadians(longitude)

        let lat2 = degreesToRadians(point.latitude)
        let lon2 = degreesToRadians(point.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        let degree = radiansToDegrees(radiansBearing)
        return (degree >= 0) ? degree : (360 + degree)
    }

    var clLocation: CLLocation {
        .init(latitude: latitude, longitude: longitude)
    }

    var stringValue: String {
        return "\(latitude),\(longitude)"
    }

    init?(latString: String?, lngString: String?) {
        guard let latStr = latString, let lngStr = lngString,
              let lat = Double(latStr), let lng = Double(lngStr)
        else {
            return nil
        }
        self.init(latitude: lat, longitude: lng)
    }

    var isValidPoints: Bool {
        return latitude != 0 || longitude != 0
    }
    
    func getNewCoordinates(to: CLLocationCoordinate2D) -> [CLLocationCoordinate2D] {
        let distance = self.distance(to: to)
        var coordinates: [CLLocationCoordinate2D] = []
        let coordinateCount = Double(distance / 30)
        if coordinateCount < 1 {
            return []
        }
        let latitudeDiff = self.latitude - to.latitude
        let longitudeDiff = self.longitude - to.longitude
        let latMultiplier = latitudeDiff / (coordinateCount + 1)
        let longMultiplier = longitudeDiff / (coordinateCount + 1)
        for index in 1...Int(coordinateCount) {
            let lat  = self.latitude - (latMultiplier * Double(index))
            let long = self.longitude - (longMultiplier * Double(index))
            let point = CLLocationCoordinate2D(latitude: lat.rounded(toPlaces: 5), longitude: long.rounded(toPlaces: 5))
            coordinates.append(point)
        }
        return coordinates
    }
    
    func distance(to destination: CLLocationCoordinate2D) -> Double {
        return CLLocation(coordinate: self)
            .distance(from: CLLocation(coordinate: destination))
    }
}

extension CLLocation {
    
    func getAddress(_ completion: @escaping CLGeocodeCompletionHandler) {
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
    }
    
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude.rounded(toPlaces: 5), longitude: coordinate.longitude.rounded(toPlaces: 5))
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return (lhs.latitude.rounded(toPlaces: 5)
                == rhs.latitude.rounded(toPlaces: 5))
        && (lhs.longitude.rounded(toPlaces: 5)
            == rhs.longitude.rounded(toPlaces: 5))
    }
}
