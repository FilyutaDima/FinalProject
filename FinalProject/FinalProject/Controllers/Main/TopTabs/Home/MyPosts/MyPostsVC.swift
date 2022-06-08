//
//  MyPostsVC.swift
//  FinalProject
//
//  Created by Dmitry on 11.05.22.
//

import UIKit

class MyPostsVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        gridView.setBackgroundColor()
        gridView.delegate = self
        gridView.dataSource = self
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUser()
    }
    
    @IBOutlet weak var gridView: UICollectionView!
    
    private var userId = UserSingleton.user().getId()
    private var user: User?
    var myPosts = [Entry]()
    
    private func registerCell() {
        gridView.register(UINib(nibName: ReuseIdentifierCell.gridItem, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifierCell.gridItem)
    }
    
    func fetchUser() {
        NetworkManager.downloadData(reference: Reference.users,
                                    pathValues: [userId],
                                    modelType: User.self) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print("Function: \(#function), line: \(#line), error: \(error.localizedDescription)")
            case .success(let user):
                
                self.user = user
                
            }
        }
    }
    
    private func fetchMyPosts(by arrayMyPostsId: [String]) {
        for id in arrayMyPostsId {
        }
    }
}

// MARK: UICollectionViewDelegate

extension MyPostsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let post = myPosts[indexPath.row]
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC else { return }
        detailVC.entry = post
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: UICollectionViewDataSource

extension MyPostsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        myPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifierCell.gridItem, for: indexPath) as? GridItemCell else { return UICollectionViewCell() }
        
        let post = myPosts[indexPath.row]
        cell.configure(with: post)
        
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension MyPostsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let paddingWidth = 15 * (itemsPerRow + 1)
        let avaibleWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = avaibleWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem + 70)
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

