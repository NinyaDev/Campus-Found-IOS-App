import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var lastLocation: CLLocation?
    @Published var status: CLAuthorizationStatus = .notDetermined
    @Published var isRequesting: Bool = false
    @Published var errorMessage: String?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestPermissionIfNeeded() {
        let current = manager.authorizationStatus
        status = current
        
        switch current {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            errorMessage = "Location access is denied. You can enable it in Settings."
        case .authorizedWhenInUse, .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    func requestLocationOnce() {
        isRequesting = true
        requestPermissionIfNeeded()
        
        let current = manager.authorizationStatus
        if current == .authorizedWhenInUse || current == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        isRequesting = false
        lastLocation = locations.last
        errorMessage = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isRequesting = false
        errorMessage = "Could not get location."
        print("Location error:", error)
    }
}
