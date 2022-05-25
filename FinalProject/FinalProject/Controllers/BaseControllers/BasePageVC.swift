//
//  BasePageVC.swift
//  FinalProject
//
//  Created by Dmitry on 3.05.22.
//

import UIKit

protocol PageConfigurator {
    func setViewControllers(_ arrayVC: [UIViewController], at position: Int, completion: @escaping () -> Void)
}

class BasePageVC: UIPageViewController, PageConfigurator {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
    }
    
    var orderedViewControllers = [UIViewController]()
    
    func setViewControllers(_ arrayVC: [UIViewController], at position: Int = 0, completion: @escaping () -> Void) {
        
        orderedViewControllers = arrayVC
        setViewControllers([orderedViewControllers[position]],
                           direction: .forward,
                           animated: true) { isSuccess in
            
            completion()
            
        }
    }
}

extension BasePageVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else { return nil }

        guard orderedViewControllers.count > previousIndex else { return nil }

        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else { return nil }

        guard orderedViewControllersCount > nextIndex else { return nil }

        return orderedViewControllers[nextIndex]
    }
}

