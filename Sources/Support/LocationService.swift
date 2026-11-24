import Foundation
import CoreLocation
import Combine

/// 一次性定位（记下故障发生位置）
final class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var coordinate: CLLocationCoordinate2D?
    @Published var statusText: String = "未定位"

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestOnce() {
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            statusText = "定位中…"
            manager.requestLocation()
        default:
            statusText = "未授权定位"
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus == .authorizedAlways {
            statusText = "定位中…"
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        coordinate = location.coordinate
        statusText = String(format: "已定位 %.5f, %.5f", location.coordinate.latitude, location.coordinate.longitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        statusText = "定位失败"
    }
}
