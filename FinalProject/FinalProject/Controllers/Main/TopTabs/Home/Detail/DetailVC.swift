//
//  DetailVC.swift
//  FinalProject
//
//  Created by Dmitry on 13.04.22.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseSharedSwift

enum Direction {
    case up
    case down
}

class DetailVC: BaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        scrollView.delegate = self
        setup()
        setLightTheme()
    }
   
    override func viewDidLayoutSubviews() {
        isAnimationContactViewDown = true
    }
    
    @IBOutlet weak var pageControlBlurView: UIVisualEffectView!
    @IBOutlet weak var currentPhotoNumberLabel: UILabel!
    @IBOutlet weak var numberOfPhotosLabel: UILabel!
    @IBOutlet weak var dateInfoBlurView: UIVisualEffectView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var galleryContainerView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var petNameLabel: UILabel!
    
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var breedView: UIView!
    @IBOutlet weak var breedLabel: UILabel!
    
    @IBOutlet weak var placeDescriptionLabel: UILabel!
    @IBOutlet weak var addressStackView: UIStackView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var characterStackView: UIStackView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var specialSingsStackView: UIStackView!
    @IBOutlet weak var specialSignsLabel: UILabel!
    @IBOutlet weak var petHistoryStackView: UIStackView!
    @IBOutlet weak var petHistoryLabel: UILabel!
    @IBOutlet weak var contactViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet var separatorViewCollection: [UIView]!
    @IBOutlet var coloredViewCollection: [UIView]!
    @IBOutlet var helpTextLabelCollection: [UILabel]!
    @IBOutlet var titleLabelCollection: [UILabel]!
    @IBOutlet var coloredTitleLabelCollection: [UILabel]!
    
    var section: Section?
    var entry: Entry?
    var isFollowingALink: Bool = false
    private var phoneNumber: String?
    var arrayPhoto = [UIImage]()
    private var isAnimationContactViewDown = true
    
    
    @IBAction func callActionButton(_ sender: Any) {
        
        if let phoneNumber = phoneNumber,
           let url = URL(string: "\(Constants.headerUrlTel)\(phoneNumber)") {
            
            UIApplication.shared.open(url)
        }
    }
    
    private func setup() {
        guard let entry = entry else { return }
        
        generateNavigationTitle(with: entry)
        configureViews(with: entry)
    }
    
    private func setLightTheme() {
        petNameLabel.setLightTheme(viewStyle: .basic, fontStyle: .headerSemiBold)
        titleLabelCollection.forEach { $0.setLightTheme(viewStyle: .basic, fontStyle: .bodyRegular) }
        helpTextLabelCollection.forEach { $0.setLightTheme(viewStyle: .auxiliary, fontStyle: .bodyRegular)}
        coloredViewCollection.forEach { $0.backgroundColor = SystemColor.lightOrange }
        coloredTitleLabelCollection.forEach { $0.setLightTheme(viewStyle: .color, fontStyle: .bodySemiBold)}
        separatorViewCollection.forEach { $0.setSeparatorStyle() }
        callButton.setLightTheme(style: .basic)
        
    }
    
    private func generateNavigationTitle(with entry: Entry) {
        
        var title = ""
        
        if let post = entry as? Post {
            guard let section = section else { return }
            
            switch section {
            case .lost:
                title = post.isStolen ? NavigationTitle.petStolen : NavigationTitle.petLost
            case .notice:
                title = NavigationTitle.petNotice
            case .houseSearch:
                title = NavigationTitle.petHouseSearch
            }
        } else if let _ = entry as? Pet {
            title = NavigationTitle.myPet
        }
        
        setNavigationTitle(title)
    }
    
    private func setNavigationTitle(_ title: String) {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 42) )
        titleLabel.text = title
        titleLabel.textColor = SystemColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = SystemFont.titleSemiBold
        self.navigationController?.visibleViewController?.navigationItem.titleView = titleLabel
    }
    
    private func configureViews(with entry: Entry) {
        
        if let post = entry as? Post {
            
            let genderText = Gender.allCases.first(where: { gender in gender.rawValue == post.pet.gender})?.description
            
            insertText(post.date.convertToString(), into: dateLabel, andShow: dateInfoBlurView)
            insertText(post.pet.name, into: petNameLabel, andShow: petNameLabel)
            insertText(post.pet.age, into: ageLabel, andShow: ageView)
            insertText(genderText, into: genderLabel, andShow: genderView)
            insertText(post.pet.breed, into: breedLabel, andShow: breedView)
            insertText(post.pet.character, into: characterLabel, andShow: characterStackView)
            insertText(post.pet.specialSigns, into: specialSignsLabel, andShow: specialSingsStackView)
            insertText(post.pet.history, into: petHistoryLabel, andShow: petHistoryStackView)
            insertText(post.address.addressString, into: addressLabel, andShow: addressStackView)
            
            contactNameLabel.text = post.contact.name
            let phoneNumberString = "\(post.contact.phoneNumber.code)\(post.contact.phoneNumber.number)"
            self.phoneNumber = phoneNumberString
            
            addMarkerToMap(with: post.address.latitude, post.address.longitude)
            mapView.isHidden = false
            
            if let section = section {
                
                var placeDescriptionText = ""
                
                if section == .lost && post.isStolen {
                    placeDescriptionText = PlaceDescription.stolen
                } else if section == .lost && !post.isStolen {
                    placeDescriptionText = PlaceDescription.lost
                } else if section == .notice {
                    placeDescriptionText = PlaceDescription.notice
                }
                
                insertText(placeDescriptionText, into: placeDescriptionLabel, andShow: placeDescriptionLabel)
                
            }
            
            configurePageControl(with: post.pet.arrayPhotoUrl.count)
            
        } else if let pet = entry as? Pet {
            
            if isFollowingALink {
                petStatusCheck(pet.status)
                isFollowingALink = false
            }
            
            let genderText = Gender.allCases.first(where: { gender in gender.rawValue == pet.gender})?.description
            insertText(pet.name, into: petNameLabel, andShow: petNameLabel)
            insertText(pet.age, into: ageLabel, andShow: ageView)
            insertText(genderText, into: genderLabel, andShow: genderView)
            insertText(pet.breed, into: breedLabel, andShow: breedView)
            insertText(pet.character, into: characterLabel, andShow: characterStackView)
            insertText(pet.history, into: petHistoryLabel, andShow: petHistoryStackView)
            
            if let petOwnerContact = pet.petOwnerContact {
                contactNameLabel.text = petOwnerContact.name
                let phoneNumberString = "\(petOwnerContact.phoneNumber.code)\(petOwnerContact.phoneNumber.number)"
                self.phoneNumber = phoneNumberString
            }
            
            
            configurePageControl(with: pet.arrayPhotoUrl.count)
        }
    }
    
    private func petStatusCheck(_ status: String) {
        switch status {
        case PetStatus.normal:
            return
        case PetStatus.lost:
            showAlarm(.lost)
        case PetStatus.stolen:
            showAlarm(.stolen)
        default:
            return
        }
    }
    
    private func showAlarm(_ alarm: Alarm) {
        let alert = UIAlertController(title: alarm.title, message: alarm.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oк", style: .default))
        present(alert, animated: true)
    }
    
    private func configurePageControl(with numberOfPages: Int) {
        pageControlBlurView.isHidden = false
        currentPhotoNumberLabel.text = 1.description
        numberOfPhotosLabel.text = numberOfPages.description
    }
    
    private func animatingContactView(_ direction: Direction) {

        var constantY: CGFloat = 0

        switch direction {
        case .up: constantY = -200
        case .down: constantY = 200
        }

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
        var contactViewFrame = self.contactView.frame
        contactViewFrame.origin.y += constantY
        self.contactView.frame = contactViewFrame
      }, completion: nil)
    }
    
    private func addMarkerToMap(with latitude: Double, _ longitude: Double) {
        let marker = GMSMarker()
        let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        marker.appearAnimation = .pop
        marker.position = locationCoordinate
        
        if let scaledMarker = #imageLiteral(resourceName: "mark.png").scale(toSize: CGSize(width: 50, height: 50)) {
            marker.icon = scaledMarker
        }
        
        DispatchQueue.main.async {
            marker.map = self.mapView
        }
        
        mapView.camera = GMSCameraPosition(
            target: locationCoordinate,
            zoom: 15,
            bearing: 0,
            viewingAngle: 0
        )
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.goToGalleryPageVC {
            
            guard let destinationVC = segue.destination as? GalleryPageVC else { return }
            
            destinationVC.delegate = self
            
            if let post = entry as? Post {
                destinationVC.arrayPhotoUrl = post.pet.arrayPhotoUrl
            } else if let pet = entry as? Pet {
                destinationVC.arrayPhotoUrl = pet.arrayPhotoUrl
            }
        }
    }
    
    deinit {
        print("\(DetailVC.description()) closed")
    }
}

extension DetailVC: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        
        if !completed { return }
        
        currentPhotoNumberLabel.text = pageViewController.viewControllers!.first!.view.tag.description
    }
}

extension DetailVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let translationY = scrollView.panGestureRecognizer.translation(in: scrollView.superview).y
        
        let offsetY = scrollView.contentOffset.y
        if  (0...200).contains(offsetY) {
            
            if translationY > 0 && !isAnimationContactViewDown {
                animatingContactView(.up)
                isAnimationContactViewDown.toggle()
            } else if translationY < 0 && isAnimationContactViewDown {
                animatingContactView(.down)
                isAnimationContactViewDown.toggle()
            }
            
        }
    }
}
