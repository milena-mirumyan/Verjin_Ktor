//
//  MapViewController.swift
//  Mappa
//
//  Created by Milena Mirumyan on 14.04.25.
//

import UIKit
import MapKit
import CoreLocation

// MARK: - Main Map View Controller

final class MapViewController: UIViewController {
    
    // MARK: Configrations
    
    static let tintColor = UIColor(red: 8.0 / 255.0, green: 121.0 / 255.0, blue: 121.0 / 255.0, alpha: 1)
    static let goldColor = UIColor(red: 239.0 / 255.0, green: 168.0 / 255.0, blue: 76.0 / 255.0, alpha: 1)
    static let cuteRedColor = UIColor(red: 231.0 / 255.0, green: 34.0 / 255.0, blue: 66.0 / 255.0, alpha: 1)
    static let minDistance: Float = 1000
    static let maxDistance: Float = 20000
    static let initialDistance: Float = 10000
    static let distanceStep: Float = 1000
    
    // MARK: UI Components
    
    private var selectedStoreView: MapStoreAnnotationBanner?
    private var selectedStoreViewConstraint: NSLayoutConstraint?
    private var distanceOverlay: MKCircle!
    private let mapView = MKMapView()
    private let searchBar = UISearchBar()
    private let centerCoordinate: CLLocationCoordinate2D
    private let distanceSlider = SteppableSlider()
    private let distanceLabel = UILabel()
    private let locateMeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = tintColor
        button.setTitle("", for: .normal)
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 24
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowOpacity = 0.5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 8
        return button
    }()
    
    // MARK: Properties
    
    private var hasSelectedAnnotation = false
    private var isFirstAppearance = true
    private var preselectedStore: FoodItemModel?
    private var allStores: [FoodItemModel] = []
    private var displayedStores: [FoodItemModel] = []
    private let locationManager = CLLocationManager()
    private var userLocation: CLLocation?
    private var filterDistance = MapViewController.initialDistance {
        didSet {
            updateDistanceLabel(distance: filterDistance)
            filterAnnotations()
        }
    }
    
    init(centerCoordinate: CLLocationCoordinate2D, allStores: [FoodItemModel], preselectedStore: FoodItemModel? = nil) {
        self.centerCoordinate = centerCoordinate
        self.allStores = allStores
        self.preselectedStore = preselectedStore
        self.displayedStores = allStores
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLocationManager()
        filterAnnotations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFirstAppearance {
            isFirstAppearance = false
            
            if let preselectedStore,
               let annotation = mapView.annotations.first(where: { ($0 as? MapStoreAnnotation)?.store.id == preselectedStore.id }) {
                mapView.selectAnnotation(annotation, animated: false)
            }
        }
    }
    
    // MARK: UI Setup
    
    private func setupUI() {
        navigationItem.titleView = searchBar
        view.backgroundColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        
        navigationItem.compactScrollEdgeAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.standardAppearance = appearance
        
        let distanceContainer = UIView()
        distanceContainer.translatesAutoresizingMaskIntoConstraints = false
        distanceContainer.backgroundColor = .white
        view.addSubview(distanceContainer)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        divider.translatesAutoresizingMaskIntoConstraints = false
        distanceContainer.addSubview(divider)
        
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        view.addSubview(mapView)
        
        searchBar.delegate = self
        searchBar.placeholder = "Search by name or category"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.enablesReturnKeyAutomatically = false
        
        distanceSlider.minimumValue = Self.minDistance
        distanceSlider.maximumValue = Self.maxDistance
        distanceSlider.tintColor = Self.goldColor
        distanceSlider.value = Float(filterDistance)
        distanceSlider.addTarget(self, action: #selector(distanceSliderChanged(_:)), for: .valueChanged)
        distanceSlider.translatesAutoresizingMaskIntoConstraints = false
        distanceSlider.isContinuous = false
        distanceSlider.numberOfSteps = Int((Self.maxDistance) / Self.distanceStep) + 1
        distanceSlider.backgroundColor = .white
        distanceSlider.onValueChanged = { [weak self] value in
            self?.updateDistanceLabel(distance: value)
        }
        distanceContainer.addSubview(distanceSlider)
        
        distanceLabel.textAlignment = .center
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceContainer.addSubview(distanceLabel)
        
        locateMeButton.addTarget(self, action: #selector(locateMeButtonTapped), for: .touchUpInside)
        view.addSubview(locateMeButton)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            distanceContainer.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: -8),
            distanceContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            distanceContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            distanceSlider.topAnchor.constraint(equalTo: distanceContainer.topAnchor, constant: 8),
            distanceSlider.leadingAnchor.constraint(equalTo: distanceContainer.leadingAnchor, constant: 16),
            distanceSlider.bottomAnchor.constraint(equalTo: distanceContainer.bottomAnchor, constant: -8),
            
            distanceLabel.leadingAnchor.constraint(equalTo: distanceSlider.trailingAnchor, constant: 8),
            distanceLabel.trailingAnchor.constraint(equalTo: distanceContainer.trailingAnchor, constant: -8),
            distanceLabel.centerYAnchor.constraint(equalTo: distanceSlider.centerYAnchor),
            distanceLabel.widthAnchor.constraint(equalToConstant: 64),
            
            locateMeButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -21),
            locateMeButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -21),
            locateMeButton.widthAnchor.constraint(equalToConstant: 48),
            locateMeButton.heightAnchor.constraint(equalToConstant: 48),
            
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.topAnchor.constraint(equalTo: distanceContainer.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.bringSubviewToFront(distanceContainer)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardBar)))
        updateDistanceLabel(distance: filterDistance)
    }
    
    @objc private func dismissKeyboardBar() {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Location Manager Setup
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Annotations and Filtering
    
    private func filterAnnotations() {
        var filtered = allStores
        if let currentLocation = userLocation {
            filtered = filtered.filter { record in
                let recordLocation = CLLocation(latitude: record.coordinate.latitude,
                                                longitude: record.coordinate.longitude)
                return recordLocation.distance(from: currentLocation) <= Double(filterDistance)
            }
        }
        
        if let searchText = searchBar.text, !searchText.isEmpty {
            filtered = filtered.filter { store in
                return store.storeNameLabel.lowercased().contains(searchText.lowercased()) ||
                store.category.lowercased().contains(searchText.lowercased())
            }
        }
        
        var annotationsToRemove: [MapStoreAnnotation] = []
        var annotationsToAdd: [MapStoreAnnotation] = []
        
        let currentAnnotations = mapView.annotations.compactMap({ $0 as? MapStoreAnnotation })
        for annotation in currentAnnotations {
            if !filtered.contains(where: { $0.id == annotation.store.id }) && (annotation.store.id != preselectedStore?.id) {
                annotationsToRemove.append(annotation)
            }
        }
        
        for store in filtered {
            if !currentAnnotations.contains(where: { $0.store.id == store.id }) {
                let annotation = MapStoreAnnotation(store: store)
                annotation.title = store.storeNameLabel
                annotation.subtitle = store.category
                annotation.coordinate = .init(latitude: store.coordinate.latitude, longitude: store.coordinate.longitude)
                annotationsToAdd.append(annotation)
            }
        }
        
        displayedStores = filtered
        mapView.removeAnnotations(annotationsToRemove)
        mapView.addAnnotations(annotationsToAdd)
    }
    
    // MARK: - UI Actions
    
    @objc private func distanceSliderChanged(_ slider: UISlider) {
        filterDistance = slider.value
        slider.value = Float(filterDistance)
        updateDistanceOverlay()
    }
    
    @objc private func locateMeButtonTapped() {
        if userLocation != nil {
            centerMap()
            updateDistanceOverlay()
        } else {
            let alert = UIAlertController(
                title: "Location Not Available",
                message: "Your current location could not be determined yet.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @objc private func close() {
        navigationController?.dismiss(animated: true)
    }
    
    private func centerMap(location: CLLocationCoordinate2D? = nil, resetRegion: Bool = false) {
        guard let location = location ?? userLocation?.coordinate else { return }
        
        let region = MKCoordinateRegion(center: location,
                                        latitudinalMeters: Double(distanceSlider.value) * 2.1,
                                        longitudinalMeters: Double(distanceSlider.value) * 2.1)
        mapView.setRegion(region, animated: true)
        updateDistanceOverlay()
    }
    
    private func updateDistanceOverlay() {
        guard let location = userLocation, filterDistance == distanceSlider.value else { return }
        
        let newDistanceOverlay = MKCircle(center: location.coordinate, radius: CLLocationDistance(distanceSlider.value + 10))
        if let distanceOverlay {
            mapView.removeOverlay(distanceOverlay)
        }
        
        mapView.addOverlay(newDistanceOverlay)
        distanceOverlay = newDistanceOverlay
    }
    
    private func updateDistanceLabel(distance: Float) {
        distanceLabel.text = "\(Int(distance / 1000)) km"
    }
}

// MARK: - UISearchBarDelegate

extension MapViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterAnnotations()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if userLocation == nil && preselectedStore == nil {
            userLocation = location
            preselectedStore = nil
            centerMap()
        } else {
            userLocation = location
        }
        
        updateDistanceOverlay()
        filterAnnotations()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = Self.tintColor
            circle.fillColor = Self.tintColor.withAlphaComponent(0.2)
            circle.lineWidth = 1
            return circle
        }
        
        return MKPolylineRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let annotationView = MKUserLocationView(annotation: annotation, reuseIdentifier: "user")
            annotationView.tintColor = Self.goldColor
            annotationView.annotation = annotation
            annotationView.isEnabled = false
            return annotationView
        } else {
            let annotationView = MKMarkerAnnotationView()
            annotationView.markerTintColor = Self.tintColor
            annotationView.annotation = annotation
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        hasSelectedAnnotation = true
        (view as? MKMarkerAnnotationView)?.markerTintColor = Self.goldColor
        
        if let coordinate = view.annotation?.coordinate {
            centerMap(location: coordinate)
        }
        
        guard let storeAnnotation = view.annotation as? MapStoreAnnotation else { return }
        let store = storeAnnotation.store
        
        if let selectedStoreView {
            selectedStoreView.update(with: store)
            return
        }
        
        let storeView = MapStoreAnnotationBanner(store: store) { [weak self] store in
            guard let self else { return }
            
            var modifiedStore = store
            modifiedStore.favoriteButton.toggle()
            
            if let index = allStores.firstIndex(where: { $0.id == modifiedStore.id }) {
                allStores[index] = modifiedStore
            }
            
            if let index = displayedStores.firstIndex(where: { $0.id == modifiedStore.id }) {
                displayedStores[index] = modifiedStore
            }
            
            if let annotation = mapView.annotations.first(where: { ($0 as? MapStoreAnnotation)?.store.id == modifiedStore.id }) as? MapStoreAnnotation {
                annotation.store = modifiedStore
            }
            
            if selectedStoreView?.store.id == modifiedStore.id {
                selectedStoreView?.update(with: modifiedStore)
            }
            
        } onSelect: { [weak self] store in
            guard let self else { return }
            
            // TODO: - handle store selection
            print(self, store)
        } onClose: { [weak self] store in
            guard let self else { return }
            
            if let annotation = mapView.annotations.first(where: { ($0 as? MapStoreAnnotation)?.store.id == store.id }) {
                self.mapView.deselectAnnotation(annotation, animated: true)
            }
        }
        
        storeView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(storeView)
        self.view.bringSubviewToFront(storeView)
        self.selectedStoreView = storeView
        
        selectedStoreViewConstraint = storeView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 300)
        NSLayoutConstraint.activate([
            storeView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            storeView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            selectedStoreViewConstraint!,
        ])
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.selectedStoreViewConstraint?.constant = -20
            self.view.layoutIfNeeded()
        })
        
        if store.id != preselectedStore?.id {
            self.preselectedStore = nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        hasSelectedAnnotation = false
        (view as? MKMarkerAnnotationView)?.markerTintColor = Self.tintColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            guard let self, !hasSelectedAnnotation else { return }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.selectedStoreViewConstraint?.constant = 300
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.selectedStoreViewConstraint = nil
                self.selectedStoreView?.removeFromSuperview()
                self.selectedStoreView = nil
            })
        }
        
        self.preselectedStore = nil
    }
}

final class MapStoreAnnotation: MKPointAnnotation {
    var store: FoodItemModel
    
    init(store: FoodItemModel) {
        self.store = store
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class MapStoreAnnotationBanner: UIView {
    private(set) var store: FoodItemModel
    let onFavorite: (FoodItemModel) -> Void
    let onSelect: (FoodItemModel) -> Void
    let onClose: (FoodItemModel) -> Void
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        imageView.clipsToBounds = true
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    let ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = MapViewController.goldColor
        imageView.image = UIImage(systemName: "star.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setImage(UIImage(systemName: "xmark.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24)), for: .normal)
        return button
    }()
    
    init(
        store: FoodItemModel,
        onFavorite: @escaping (FoodItemModel) -> Void,
        onSelect: @escaping (FoodItemModel) -> Void,
        onClose: @escaping (FoodItemModel) -> Void
    ) {
        self.store = store
        self.onFavorite = onFavorite
        self.onSelect = onSelect
        self.onClose = onClose
        super.init(frame: .zero)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 24
        
        self.addSubview(containerView)
        self.clipsToBounds = false
        self.layer.cornerRadius = 24
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 8
        self.backgroundColor = .white
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(ratingLabel)
        containerView.addSubview(ratingImageView)
        containerView.addSubview(closeButton)
        containerView.addSubview(favoriteButton)
        
        favoriteButton.addTarget(self, action: #selector(handleFavoriteTap), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(handleCloseTap), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            subtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            ratingLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            ratingImageView.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -2),
            ratingImageView.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            favoriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            favoriteButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        update(with: store)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func update(with store: FoodItemModel) {
        self.store = store
        
        imageView.image = UIImage(named: store.storeImage)
        titleLabel.text = store.storeNameLabel
        ratingLabel.text = "\(store.rating)"
        subtitleLabel.text = "Pick up at \(store.pickUpTime)"
        
        let colors = store.favoriteButton ? [MapViewController.cuteRedColor, .white] : [.white]
        favoriteButton.setImage(
            UIImage(systemName: "heart.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(paletteColors: colors).applying(UIImage.SymbolConfiguration(pointSize: 24))),
            for: .normal
        )
    }
    
    @objc private func handleTap() {
        onSelect(store)
    }
    
    @objc private func handleFavoriteTap() {
        onFavorite(store)
    }
    
    @objc private func handleCloseTap() {
        onClose(store)
    }
}

final class SteppableSlider: UISlider {
    private var currentIndex: Int = 0
    private var stepValue: Float = 0
    private var isStepEnabled: Bool { stepValue > 0 }
    private var previousValueForFeedback: Float = 0
    
    var onValueChanged: ((Float) -> Void)?
    var useHapticFeedback: Bool = true
    var numberOfSteps: Int = 0 {
        didSet {
            updateStepValue()
        }
    }
    
    override var value: Float {
        get {
            guard isStepEnabled else { return super.value }
            let newStepValue = max(minimumValue, min(maximumValue, round(super.value / stepValue) * stepValue))
            if useHapticFeedback {
                if previousValueForFeedback != newStepValue {
                    previousValueForFeedback = newStepValue
                    
                    let generator = UISelectionFeedbackGenerator()
                    generator.selectionChanged()
                }
            }
            updateCurrentIndex(of: newStepValue)
            return newStepValue
        }
        
        set {
            if isStepEnabled {
                let newStepValue = max(minimumValue, min(maximumValue, round(super.value / stepValue) * stepValue))
                super.value = newStepValue
            } else {
                super.value = newValue
            }
        }
    }
    
    func setIndex(_ index: Int) {
        guard index >= 0, index < numberOfSteps else { return }
        let nextValue = stepValue * Float(index)
        updateCurrentIndex(of: nextValue)
    }
    
    private func updateStepValue() {
        stepValue = numberOfSteps > 1 ? maximumValue / Float(numberOfSteps - 1) : 0
    }
    
    private func updateCurrentIndex(of nextValue: Float) {
        let newIndex = Int(round(nextValue / stepValue))
        guard newIndex != currentIndex else { return }
        
        currentIndex = newIndex
        onValueChanged?(nextValue)
    }
}
