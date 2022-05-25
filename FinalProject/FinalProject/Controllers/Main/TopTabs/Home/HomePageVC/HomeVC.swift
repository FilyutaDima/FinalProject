//
//  HomeVC.swift
//  FinalProject
//
//  Created by Dmitry on 27.04.22.
//

import UIKit
import paper_onboarding

private let reuseIdentifier = "Cell"

class HomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
        tabView.dataSource = self
        tabView.delegate = self
        tabView.setBackgroundColor()
//        showOnboarding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isFirstPage {
            currentPageIndex = 0
            isFirstPage = false
        }
    }
    
    @IBOutlet weak var ondoardingView: PaperOnboarding!
    @IBOutlet weak var tabView: UICollectionView!
    @IBOutlet weak var containerPageVC: UIView!
    
    private var pageVC: HomePageVC!
    
    private func showOnboarding() {
        
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: ondoardingView,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
          }
        
        onboardingItem(at: 0)
    }
    
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
  
          return [
              OnboardingItemInfo(informationImage: UIImage(named: "screneLogo")!,
                                 title: "title",
                                 description: "description",
                                 pageIcon: UIImage(systemName: "house.fill")!,
                                 color: UIColor.blue,
                                 titleColor: UIColor.green,
                                 descriptionColor: UIColor.black,
                                 titleFont: UIFont(name: "Rubik-Regular", size: 125)!,
                                 descriptionFont: UIFont(name: "Rubik-Regular", size: 14)!),
  
              OnboardingItemInfo(informationImage: UIImage(named: "homePage")!,
                                 title: "title",
                                 description: "description",
                                 pageIcon: UIImage(systemName: "house.fill")!,
                                 color: UIColor.blue,
                                 titleColor: UIColor.green,
                                 descriptionColor: UIColor.black,
                                 titleFont: UIFont(name: "Rubik-Regular", size: 125)!,
                                 descriptionFont: UIFont(name: "Rubik-Regular", size: 14)!),
  
              OnboardingItemInfo(informationImage: UIImage(named: "myPets")!,
                                 title: "title",
                                 description: "description",
                                 pageIcon: UIImage(systemName: "house.fill")!,
                                 color: UIColor.blue,
                                 titleColor: UIColor.green,
                                 descriptionColor: UIColor.black,
                                 titleFont: UIFont(name: "Rubik-Regular", size: 125)!,
                                 descriptionFont: UIFont(name: "Rubik-Regular", size: 14)!),
          ][index]
       }
    
    private func registerCell() {
        tabView.register(UINib(nibName: "TabViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private var isFirstPage: Bool = true
    private var currentPageIndex: Int! {
        
        willSet {
            guard let newValue = newValue,
                  let currentCell = tabView.cellForItem(at: IndexPath(row: newValue, section: 0)) as? TabViewCell else { return }
                    currentCell.setSelection()
        }
        didSet {
            guard let oldValue = oldValue,
                  let previousCell = tabView.cellForItem(at: IndexPath(row: oldValue, section: 0)) as? TabViewCell else { return }
            previousCell.resetSelection()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.goToHomePageVC {
            
            guard let pageVC = segue.destination as? HomePageVC else { return }
            self.pageVC = pageVC
            self.pageVC.delegate = self
        }
    }
}

extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TabViewCell else { return UICollectionViewCell() }
        
        cell.configure(with: indexPath.row)
        
        return cell
    }
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        pageVC.goToNextVC(at: indexPath.row) { [weak self] in
            self?.currentPageIndex = indexPath.row
        }
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 3
        let paddingWidth = 20 * (itemsPerRow + 1)
        let avaibleWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = avaibleWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 50)
    }
}

extension HomeVC: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        
        if !completed { return }
        self.currentPageIndex = pageViewController.viewControllers!.first!.view.tag
    }
}
