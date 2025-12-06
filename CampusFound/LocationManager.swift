import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var lastLocation: CLLocation?
    @Published var status: CLAuthorizationStatus = .notDetermined
    @Published var isRequesting: Bool = false
    @Published var errorMessage: String?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Call this when user toggles "Share my current location"
    func requestLocationOnce() {
        let current = manager.authorizationStatus
        print("requestLocationOnce - current status: \(current.rawValue)")
        
        switch current {
        case .notDetermined:
            // First time → show system popup
            isRequesting = true
            manager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Already authorized → just request location
            isRequesting = true
            errorMessage = nil
            manager.requestLocation()
            
        case .denied, .restricted:
            // User has denied before or location is restricted
            isRequesting = false
            errorMessage = "Location access is denied. You can enable it in Settings."
            
        @unknown default:
            isRequesting = false
        }
    }
    
    // Called when user responds to the permission popup
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.status = status
            print("didChangeAuthorization: \(status.rawValue)")
            
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                if self.isRequesting {
                    manager.requestLocation()
                }
            case .denied, .restricted:
                self.isRequesting = false
                self.errorMessage = "Location access is denied. You can enable it in Settings."
            case .notDetermined:
                break
            @unknown default:
                break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            self.isRequesting = false
            self.lastLocation = locations.last
            self.errorMessage = nil
            print("didUpdateLocations: \(String(describing: self.lastLocation))")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.isRequesting = false
            self.errorMessage = "Could not get location."
            print("Location error: \(error)")
        }
    }
}
