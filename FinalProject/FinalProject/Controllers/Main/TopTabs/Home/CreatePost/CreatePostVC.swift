//
//  AddNewNoticeVC.swift
//  FinalProject
//
//  Created by Dmitry on 21.03.22.
//

import UIKit
import Firebase
import FirebaseSharedSwift

class CreatePostVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle()
        setupCollectionView()
        hideKeyboardWhenTappedAround()
        startKeyboardObserver()
        configureViews()
        setPlaceholder()
        setLightTheme()
    }
    
    @IBOutlet weak var rootScrollView: UIScrollView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet final weak var animalTypeSC: UISegmentedControl!
    @IBOutlet final weak var genderSC: UISegmentedControl!
    @IBOutlet weak var petNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var placeDescriptionLabel: UILabel!
    @IBOutlet final weak var addressTextField: UITextField!
    @IBOutlet final weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var isStolenStackView: UIStackView!
    @IBOutlet weak var isStolenSwitch: UISwitch!
    @IBOutlet weak var phoneDataStackView: UIStackView!
    @IBOutlet final weak var contactNameTextField: UITextField!
    @IBOutlet final weak var countryCodeLabel: UILabel!
    @IBOutlet final weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var specialSignsStackView: UIStackView!
    @IBOutlet weak var specialSignsTextView: UITextView!
    @IBOutlet private final var countryDataStackView: UIStackView!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var characterStackView: UIStackView!
    @IBOutlet weak var characterTextView: UITextView!
    @IBOutlet weak var petHistoryStackView: UIStackView!
    @IBOutlet weak var petHistoryTextView: UITextView!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var iconCameraImageView: UIImageView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    
    @IBOutlet var separatorViewCollection: [UIView]!
    @IBOutlet var textFieldCollection: [UITextField]!
    @IBOutlet var titleLabelCollection: [UILabel]!
    @IBOutlet var textViewCollection: [UITextView]!
    
    var section: Section?
    var placeholder: Entry?
    
    private var address: Address?
    private var photos = [UIImage]()
    
    private func setNavigationTitle() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 42) )
        titleLabel.text = NavigationTitle.createPost
        titleLabel.textColor = SystemColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = SystemFont.titleSemiBold
        self.navigationController?.visibleViewController?.navigationItem.titleView = titleLabel
    }
    
    private func setLightTheme() {
        view.setBackgroundColor()
        animalTypeSC.setLightTheme()
        genderSC.setLightTheme()
        
        addPhotoLabel.setLightTheme(viewStyle: .color, fontStyle: .bodyRegular)
        iconCameraImageView.setLightTheme()
        publishButton.setLightTheme(style: .basic)
        isStolenSwitch.setLightTheme()
        
        separatorViewCollection.forEach { $0.setSeparatorStyle() }
        textFieldCollection.forEach { $0.setLightTheme() }
        textViewCollection.forEach { $0.setLightTheme() }
        titleLabelCollection.forEach { $0.setLightTheme(viewStyle: .basic, fontStyle: .bodySemiBold) }
    }
    
    private func setupCollectionView() {
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        photosCollectionView.setBackgroundColor()
    }
    
    private func configureViews() {
        
        guard let section = section else { return }
        
        switch section {
        case .houseSearch: configureHouseSearchSection()
        case .notice: configureNoticeSection()
        case .lost: configureLostSection()
        }
    }
    
    private func configureHouseSearchSection() {
        hideViews([placeDescriptionLabel,
                  isStolenStackView,
                  specialSignsStackView])
    }
    
    private func configureNoticeSection() {
        hideViews([petNameTextField,
                  ageTextField,
                  isStolenStackView,
                  petHistoryStackView,
                  characterStackView])
        
        placeDescriptionLabel.text = PlaceDescription.notice
    }
    
    private func configureLostSection() {
        hideViews([petHistoryStackView,
                  characterStackView])
        
        placeDescriptionLabel.text = PlaceDescription.lost
    }
    
    private func setPlaceholder() {
        if let pet = placeholder {
            petNameTextField.text = pet.name
            ageTextField.text = pet.age
        }
    }
    
    @IBAction func publishPostAction(_ sender: Any) {
    
        onStartDownloading()
        
        guard let contactName = contactNameTextField.text,
              let number = phoneNumberTextField.text,
              let code = countryCodeLabel.text,
              !photos.isEmpty else {
            
            onStopDownloading()
            return
        }
        
        var status = ""
        switch section {
        case .lost:
            status = isStolenSwitch.isOn ? Status.stolen.title : Status.lost.title
        case .notice:
            status = Status.notice.title
        case .houseSearch:
            status = Status.houseSearch.title
        default: return 
        }
        
        let phoneNumber = PhoneNumber(code: code, number: number)
        let contact = Contact(name: contactName,
                              phoneNumber: phoneNumber)
                
        NetworkManager.uploadPhotos(photos: photos) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                self.onStopDownloading()
                print("Function: \(#function), line: \(#line), error: \(error.localizedDescription)")
            
            case .success(let arrayPhotoUrl):
                
                guard let section = self.section,
                      let address = self.address else { return }
                
                let post = self.configurePost(arrayPhotoUrl: arrayPhotoUrl, address: address, contact: contact, status: status)
                  
                self.upload(post, into: section)
            }
        }
    }
    
    private func upload(_ post: Entry, into section: Section) {
        
        NetworkManager.uploadData(reference: Reference.posts,
                                  pathValues: [section.title, post.uid],
                                  object: post) { result in
            switch result {
            case .success(_):
                
                NetworkManager.uploadData(reference: Reference.users,
                                          pathValues: [UserSingleton.user().getId(),
                                                       DBCategory.myPostsId,
                                                       post.uid],
                                          object: post.uid) { result in
                    switch result {
                    case .success(_):
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        print("Function: \(#function), line: \(#line), error: \(error.localizedDescription)")
                    }
                }
                
                self.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                self.onStopDownloading()
                print("Function: \(#function), line: \(#line), error: \(error.localizedDescription)")
            }
        }
    }
    
    private func onStartDownloading() {
        self.view.isUserInteractionEnabled = false
        blurView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    private func onStopDownloading() {
        self.view.isUserInteractionEnabled = true
        blurView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
    
    private func showDownloadError() {
        onStopDownloading()
        showAlertDownloadError { action in
            if action.title == Constants.cancel {
                self.publishPostAction(self)
            }
        }
    }
    
    @IBAction func addPhotoAction(_ sender: Any) {
        if photos.count < 5 {
            
            takePhotoAction { action in
                switch action.title {
                case PhotoAction.openCamera: self.getImage(fromSourceType: .camera)
                case PhotoAction.openLibrary: self.getImage(fromSourceType: .photoLibrary)
                default: return
                }
            }
        }
    }
    
    private func configurePost(arrayPhotoUrl: [String],
                                address: Address,
                                contact: Contact,
                                status: String) -> Entry {
        
        let gender = Gender.allCases[genderSC.selectedSegmentIndex]
        let animalType = AnimalType.allCases[animalTypeSC.selectedSegmentIndex]
        let name = petNameTextField.text ?? ""
        let breed = breedTextField.text ?? ""
        let age = ageTextField.text ?? ""

        return Entry(uid: UUID().uuidString,
                     ownerId: nil,
                     type: animalType.rawValue,
                     name: name.isEmpty ? Constants.noName : name,
                     breed: breed.isEmpty ? Constants.noBreed : breed,
                     gender: gender.rawValue,
                     age: age.isEmpty ? Constants.noAge : age,
                     specialSigns: specialSignsTextView.text,
                     history: petHistoryTextView.text,
                     character: characterTextView.text,
                     arrayPhotoUrl: arrayPhotoUrl,
                     contact: contact,
                     status: status,
                     address: address)
    }
    
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    private func startKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        rootScrollView.contentInset = contentInsets
        rootScrollView.scrollIndicatorInsets = contentInsets
    }

    @objc private func keyboardWillHide() {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        rootScrollView.contentInset = contentInsets
        rootScrollView.scrollIndicatorInsets = contentInsets
    }
    
    @IBAction func showMapTapAction(_ sender: Any) {
        guard let mapVC = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
  
        mapVC.getAddress = { address in
            self.address = address
            self.addressTextField.text = address.addressString
        }
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @IBAction func showCountryCodeSelectionTapAction(_ sender: Any) {
        showAlertForSelectCountry(handler: { currentRow in
            
            let countryPhoneCodes = CountryPhoneCode.allCases.sorted(by: { $0.description < $1.description })
            let countryPhoneCode = countryPhoneCodes[currentRow]
            self.countryCodeLabel.text = countryPhoneCode.rawValue
            self.countryFlagImageView.image = UIImage(named: countryPhoneCode.countryCode)
        })
    }
    
    deinit {
        print("\(CreatePostVC.description()) closed")
    }
}

// MARK: UICollectionViewDataSource

extension CreatePostVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifierCell.defaultId, for: indexPath) as? PhotoViewCell else { return UICollectionViewCell() }

        cell.tag = indexPath.row
        cell.configure(with: photos[indexPath.row])
        cell.delegate = self
        
        return cell
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension CreatePostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let photo = info[.originalImage] as? UIImage else { return }
        
        self.photos.append(photo)
        
        dismiss(animated: true, completion: nil)
        
        photosCollectionView.insertItems(at: [IndexPath(row: photos.count - 1, section: 0)])
        photosCollectionView.isHidden = false
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension CreatePostVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

// MARK: DeletePhotoDelegate

extension CreatePostVC: DeletePhotoDelegate {
    
    func deletePhoto(at tag: Int) {
        
        guard let currentCell = photosCollectionView.visibleCells.first(where: { cell in cell.tag == tag }),
              let currentIndexPath = photosCollectionView.indexPath(for: currentCell) else { return }
        
        photos.remove(at: currentIndexPath.row)
        photosCollectionView.deleteItems(at: [currentIndexPath])
        
        if photos.isEmpty {
            photosCollectionView.isHidden = true
        }
    }
}
