//
//  LostCVC.swift
//  FinalProject
//
//  Created by Dmitry on 20.03.22.
//

import Firebase
import FirebaseSharedSwift
import UIKit

class GridVC: BaseVC {
    
    @IBOutlet var gridView: UICollectionView!
    var section: Section?
    var posts = [Entry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridView.setBackgroundColor()
        configureDatabase()
        registerCell()
        gridView.delegate = self
        gridView.dataSource = self
    }
    
    private func configureDatabase() {
        guard let section = section else { return }
        
        Reference.posts.child(section.title).observe(.childAdded) { [weak self] snapshot in
            guard let self = self,
                  let postDict = snapshot.value as? [String: Any],
                  let post = try? FirebaseDataDecoder().decode(Entry.self, from: postDict) else { return }
            self.posts.append(post)
            let indexPath = IndexPath(row: self.posts.count - 1, section: 0)
            self.gridView.insertItems(at: [indexPath])
        }
    }
    
    private func registerCell() {
        gridView.register(UINib(nibName: ReuseIdentifierCell.gridItem, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifierCell.gridItem)
    }

    deinit {
        print("\(GridVC.description()) closed")
    }
}

// MARK: UICollectionViewDelegate

extension GridVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC else { return }

        detailVC.section = section
        detailVC.entry = post
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: UICollectionViewDataSource

extension GridVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifierCell.gridItem, for: indexPath) as? GridItemCell else { return UICollectionViewCell() }

        let post = posts[indexPath.row]
        cell.configure(with: post)
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension GridVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let paddingWidth = 15 * (itemsPerRow + 1)
        let avaibleWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = avaibleWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem + 80)
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
