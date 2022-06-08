//
//  MyPetsVC.swift
//  FinalProject
//
//  Created by Dmitry on 4.05.22.
//

import UIKit
import Firebase

protocol UpdateUIDelegate: AnyObject {
    func insert(item: Entry, at indexPath: IndexPath)
}

protocol MyPetMenuActionDelegare: AnyObject {
    func showPetQRCode(_ pet: Entry)
    func deletePet(at tag: Int)
    func reportMissing(_ pet: Entry)
    func changePetStatus(_ pet: Entry, _ status: String, _ tag: Int)
}

class MyPetsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setupCollectionView()
        fetchUser()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var myPets = [Entry]()
    private var userId = UserSingleton.user().getId()
    private var user: User?
    
    private func registerCells() {
        collectionView.register(UINib(nibName: ReuseIdentifierCell.addPet, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifierCell.addPet)
        collectionView.register(UINib(nibName: ReuseIdentifierCell.myPet, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifierCell.myPet)
    }
    
    private func setupCollectionView() {
        collectionView.setBackgroundColor()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func fetchUser() {
        
        NetworkManager.downloadData(reference: Reference.users,
                                    pathValues: [userId],
                                    modelType: User.self) { [weak self] result in

            guard let self = self else { return }

            switch result {
            case .failure(let error):
                print("Function: \(#function), line: \(#line), error: \(error.localizedDescription)")
            case .success(let user):

                self.user = user
                
                guard let myPetsIdDict = user.myPetsId else { return }
                let myPetsId = Array(myPetsIdDict.values) as [String]
                
                self.fetchMyPets(by: myPetsId)
            }
        }
    }
    
    private func fetchMyPets(by myPetsId: [String]) {
        
        for petId in myPetsId {
            
            NetworkManager.downloadData(reference: Reference.pets,
                                        pathValues: [petId],
                                        modelType: Entry.self) { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .failure(let error):
                    print("Function: \(#function), line: \(#line), error: \(error.localizedDescription)")
                case .success(let pet):
                    self.myPets.append(pet)
                    self.collectionView.insertItems(at: [IndexPath(row: self.myPets.count, section: 0)])
                }
            }
        }
    }
}

// MARK: UICollectionViewDelegate

extension MyPetsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row != myPets.count {
            guard let destVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC else { return }
            destVC.entry = myPets[indexPath.row]
            navigationController?.pushViewController(destVC, animated: true)
        } else {
            guard let destVC = storyboard?.instantiateViewController(withIdentifier: "CreatePetVC") as? CreatePetVC else { return }
            destVC.nextIndexPath = indexPath
            destVC.updateUI = self
            destVC.user = user
            navigationController?.pushViewController(destVC, animated: true)
        }
    }
}

// MARK: UICollectionViewDataSource

extension MyPetsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        myPets.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row != myPets.count {

            guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: ReuseIdentifierCell.myPet, for: indexPath) as? MyPetCell else {
                return UICollectionViewCell()
            }

            cell.delegate = self
            cell.setup(with: myPets[indexPath.row])
            cell.tag = indexPath.row

            return cell
        } else {
            
            guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: ReuseIdentifierCell.addPet, for: indexPath) as? AddPetCell else {
                return UICollectionViewCell()
            }
            cell.tag = indexPath.row
            return cell
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension MyPetsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 1
        let paddingWidth = 15 * (itemsPerRow + 1)
        let avaibleWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = avaibleWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

// MARK: UpdateUIDelegate

extension MyPetsVC: UpdateUIDelegate {
    func insert(item: Entry, at indexPath: IndexPath) {
        myPets.append(item)
        collectionView.insertItems(at: [indexPath])
    }
}

// MARK: MyPetMenuActionDelegare

extension MyPetsVC: MyPetMenuActionDelegare {
    
    
    func showPetQRCode(_ pet: Entry) {
        goToMyPetQRCodeVC(with: pet)
    }
    
    func deletePet(at tag: Int) {
        deleteMyPet(at: tag)
    }
    
    func reportMissing(_ pet: Entry) {
        goToCreatePostVC(with: pet)
    }
    
    func changePetStatus(_ pet: Entry, _ status: String, _ tag: Int) {
        NetworkManager.uploadData(reference: Reference.pets,
                                  pathValues: [pet.uid,
                                               DBCategory.petStatus],
                                  object: status) { [weak self] result in
            switch result {
            case .failure(let error):
                print("Function: \(#function), line: \(#line), error: \(error.localizedDescription)")
            case .success(_):
                self?.updatePetStatusLabel(with: status, at: tag)
            }
        }
    }
    
    private func goToMyPetQRCodeVC(with pet: Entry) {
        guard let destVC = storyboard?.instantiateViewController(withIdentifier: "MyPetQRCodeVC") as? MyPetQRCodeVC else { return }
        destVC.pet = pet
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    private func goToCreatePostVC(with pet: Entry) {
        guard let destVC = storyboard?.instantiateViewController(withIdentifier: "CreatePostVC") as? CreatePostVC else { return }
        destVC.placeholder = pet
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    private func deleteMyPet(at tag: Int) {
        guard let currentCell = collectionView.visibleCells.first(where: { $0.tag == tag }),
              let currentIndexPath = collectionView.indexPath(for: currentCell) else { return }
     
        let pet = myPets[currentIndexPath.row]
        
        NetworkManager.deleteData(reference: Reference.pets,
                                  pathValues: [pet.uid]) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print("Function: \(#function), line: \(#line), error: \(error.localizedDescription)")
            case .success(_):
                
                NetworkManager.deleteData(reference: Reference.users,
                                          pathValues: [self.userId,
                                                       DBCategory.myPetsId,
                                                       pet.uid]) { result in
                    switch result {
                    case .failure(let error):
                        print("Function: \(#function), line: \(#line), error: \(error.localizedDescription)")
                    case .success(_):
                        self.myPets.remove(at: currentIndexPath.row)
                        self.collectionView.deleteItems(at: [currentIndexPath])
                    }
                }
                
            }
        }
    }
    
    private func updatePetStatusLabel(with status: String, at tag: Int) {
        guard let currentCell = collectionView.visibleCells.first(where: { $0.tag == tag }) as? MyPetCell else { return }
        currentCell.petStatusLabel.text = status
    }
}
