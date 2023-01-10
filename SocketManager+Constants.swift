import Foundation
import CoreLocation

extension SocketIOManager {
    
    enum OnEvent: String {
        case getEstimateFare    = "get_estimate_fare"
        case nearbyDrivers      = "near_by_driver"
    }
    
    enum SocketKeys {
        static let customerId   = "customer_id"
        static let lat          = "lat"
        static let lng          = "lng"
        static let currentLat   = "current_lat"
        static let currentLng   = "current_lng"
        static let bookingId    = "booking_id"
    }
    
    enum EmitEvent {
        case updateLocation(location: CLLocationCoordinate2D, userId: String)
        case getEstimateFare(request: EstimateFareRequest)
        case getNearbyDrivers(userId: String, location: CLLocationCoordinate2D)
        case cancelBookingBeforeAccept(userId: String, bookingId: String)
        
        var eventId: String {
            switch self {
            case .updateLocation:               return "connect_customer"
            case .getEstimateFare:              return "get_estimate_fare"
            case .getNearbyDrivers:             return "near_by_driver"
            case .cancelBookingBeforeAccept:    return "cancel_booking_before_accept"
            }
        }
        
        var params: [String: Any] {
            switch self {
            case .updateLocation(let location, let userId):
                return [
                    SocketKeys.customerId: userId,
                    SocketKeys.lat: location.latitude,
                    SocketKeys.lng: location.longitude
                ]
            case .getEstimateFare(let request):
                return try! request.convertToDict()
            case .getNearbyDrivers(let userId, let location):
                return [
                    SocketKeys.customerId : userId,
                    SocketKeys.currentLat: location.latitude,
                    SocketKeys.currentLng: location.longitude
                ]
            case .cancelBookingBeforeAccept(let userId, let bookingId):
                return [
                    SocketKeys.customerId: userId,
                    SocketKeys.bookingId: bookingId
                ]
            }
    
        }
    }
}

struct EstimateFareRequest: Convertible {
    let customerId: String
    let pickupLat, pickupLng : Double
    let dropLat, dropLng: Double
    
    enum CodingKeys: String, CodingKey {
        case customerId = "customer_id"
        case pickupLat  = "pickup_lat"
        case pickupLng  = "pickup_lng"
        case dropLat    = "dropoff_lat"
        case dropLng    = "dropoff_lng"
    }
    
    init(
        customerId: String,
        pickupLocation: CLLocationCoordinate2D,
        dropOffLocation: CLLocationCoordinate2D
    ) {
        self.customerId = customerId
        self.pickupLat = pickupLocation.latitude
        self.pickupLng = pickupLocation.longitude
        self.dropLat = dropOffLocation.latitude
        self.dropLng = dropOffLocation.longitude
    }
}
