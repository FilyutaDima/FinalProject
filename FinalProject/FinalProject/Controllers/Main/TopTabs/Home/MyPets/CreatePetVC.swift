//
//  CreatePetVC.swift
//  FinalProject
//
//  Created by Dmitry on 11.05.22.
//

import UIKit
import Firebase

class CreatePetVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationTitle()
        setupCollectionView()
        setupPetOwnerContact()
        hideKeyboardWhenTappedAround()
        setLightTheme()
        startKeyboardObserver()
    }

    @IBOutlet weak var rootScrollView: UIScrollView!
    @IBOutlet weak var animalTypeSC: UISegmentedControl!
    @IBOutlet weak var genderSC: UISegmentedControl!
    @IBOutlet weak var petNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var placeDescriptionLabel: UILabel!
    @IBOutlet final weak var addressTextField: UITextField!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var contactNameTextField: UITextField!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var specialSignsTextView: UITextView!
    @IBOutlet weak var characterTextView: UITextView!
    @IBOutlet weak var petHistoryTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var iconCameraImageView: UIImageView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    
    @IBOutlet var separatorViewCollection: [UIView]!
    @IBOutlet var textFieldCollection: [UITextField]!
    @IBOutlet var titleLabelCollection: [UILabel]!
    @IBOutlet var textViewCollection: [UITextView]!
    
    
    var updateUI: UpdateUIDelegate?
    var nextIndexPath: IndexPath?
    var user: User?
    private let userId = UserSingleton.user().getId()
    private var address: Address?
    
    private var photos = [UIImage]()
    
    @IBAction func showCountryCodeSelectionTapAction(_ sender: Any) {
        showAlertForSelectCountry(handler: { currentRow in
            
            let countryPhoneCodes = CountryPhoneCode.allCases.sorted(by: { $0.description < $1.description })
            let countryPhoneCode = countryPhoneCodes[currentRow]
            self.countryCodeLabel.text = countryPhoneCode.rawValue
            self.countryFlagImageView.image = UIImage(named: countryPhoneCode.countryCode)
        })
    }
    
    private func setNavigationTitle() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 42) )
        titleLabel.text = NavigationTitle.createPet
        titleLabel.textColor = SystemColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = SystemFont.titleSemiBold
        self.navigationController?.visibleViewController?.navigationItem.titleView = titleLabel
    }
    
    private func setLightTheme() {
        view.setBackgroundColor()
        animalTypeSC.setLightTheme()
        genderSC.setLightTheme()
        saveButton.setLightTheme(style: .basic)
        addPhotoLabel.setLightTheme(viewStyle: .color, fontStyle: .bodyRegular)
        iconCameraImageView.setLightTheme()
        countryCodeLabel.setLightTheme(viewStyle: .basic, fontStyle: .bodyRegular)
        
        textFieldCollection.forEach { $0.setLightTheme() }
        textViewCollection.forEach { $0.setLightTheme() }
        titleLabelCollection.forEach {
            $0.setLightTheme(viewStyle: .basic, fontStyle: .bodySemiBold)
        }
        separatorViewCollection.forEach { $0.setSeparatorStyle()
        }
    }
    
    private func setupCollectionView() {
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        photosCollectionView.setBackgroundColor()
    }
    
    private func setupPetOwnerContact() {
        
        guard let user = user else { return }
        contactNameTextField.text = user.contact.name
        countryCodeLabel.text = user.contact.phoneNumber.code
        phoneNumberTextField.text = user.contact.phoneNumber.number
        
        if let countryPhoneCode = CountryPhoneCode.allCases.first(where: { $0.rawValue == user.contact.phoneNumber.code }) {
            countryFlagImageView.image = UIImage(named: countryPhoneCode.countryCode)
        }
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        onStartDownloading()
        
        guard let contactName = contactNameTextField.text,
              let number = phoneNumberTextField.text,
              let code = countryCodeLabel.text,
              let address = address else {
            
            onStopDownloading()
            return
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
                let pet = self.configureEntry(arrayPhotoUrl: arrayPhotoUrl, address: address, contact: contact)
                self.upload(pet)
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
    
    private func configureEntry(arrayPhotoUrl: [String],
                                address: Address,
                                contact: Contact) -> Entry {
        
        let gender = Gender.allCases[genderSC.selectedSegmentIndex]
        let animalType = AnimalType.allCases[animalTypeSC.selectedSegmentIndex]
        let name = petNameTextField.text ?? ""
        let breed = breedTextField.text ?? ""
        let age = ageTextField.text ?? ""

        return Entry(uid: UUID().uuidString,
                     ownerId: UserSingleton.user().getId(),
                     type: animalType.rawValue,
                     name: name.isEmpty ? Constants.noName : name,
                     breed: breed.isEmpty ? Constants.noBreed : breed,
                     gender: gender.rawValue,
                     age: age.isEmpty ? Constants.noAge : age,
                     specialSigns: specialSignsTextView.text,
                     history: petHistoryTextView.text,
                     character: characterTextView.text,
                     arrayPhotoUrl: arrayPhotoUrl,
                     contact: contact, address: address)
    }
    
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    private func upload(_ pet: Entry) {
   
        NetworkManager.uploadData(reference: Reference.pets, pathValues: [pet.uid], object: pet) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                self.onStopDownloading()
                print("Function: \(#function), line: \(#line), error: \(error.localizedDescription)")
            case .success:
                
                NetworkManager.uploadData(reference: Reference.users,
                                          pathValues: [self.userId,
                                                       DBCategory.myPetsId,
                                                       pet.uid],
                                          object: pet.uid) { result in
                    switch result {
                    case .success(_):
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        print("Function: \(#function), line: \(#line), error: \(error.localizedDescription)")
                    }
                }
                
                if let updateUI = self.updateUI,
                   let nextIndexPath = self.nextIndexPath {
                    updateUI.insert(item: pet, at: nextIndexPath)
                }
                
                self.onStopDownloading()
                self.navigationController?.popViewController(animated: true)
            }
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
    
    @IBAction func showMapTapAction(_ sender: Any) {
        guard let mapVC = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
  
        mapVC.getAddress = { address in
            self.address = address
            self.addressTextField.text = address.addressString
        }
        navigationController?.pushViewController(mapVC, animated: true)
    }
}

// MARK: UICollectionViewDataSource

extension CreatePetVC: UICollectionViewDataSource {
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

extension CreatePetVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let photo = info[.originalImage] as? UIImage else { return }
        
        self.photos.append(photo)
        
        dismiss(animated: true, completion: nil)
        
        photosCollectionView.insertItems(at: [IndexPath(row: photos.count - 1, section: 0)])
        photosCollectionView.isHidden = false
    }
}

// MARK: DeletePhotoDelegate

extension CreatePetVC: DeletePhotoDelegate {
    
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

extension CreatePetVC: UICollectionViewDelegateFlowLayout {
    
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

