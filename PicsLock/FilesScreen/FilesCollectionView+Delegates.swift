import UIKit

extension FilesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return files.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "files_cell_Id", for: indexPath) as! FilesCollectionViewCell
    
    if let img = UIImage(contentsOfFile: files[indexPath.row].path.relativePath) {
      cell.composeView(withImage: img)
      cell.name = files[indexPath.row].name
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let index = indexPath.row

    self.currentIndex = index
    
    let detailViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    detailViewController.setViewControllers([orderedViewControllers[index]], direction: .forward, animated: true, completion: nil)
    detailViewController.dataSource = self
    
    let transition = CATransition()
    transition.duration = 0.1
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    transition.type = kCATransitionFade
    self.navigationController?.view.layer.add(transition, forKey: nil)
    self.navigationController?.pushViewController(detailViewController, animated: false)
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = UIScreen.main.bounds.width / 3 - 16
    
    return CGSize(width: width, height: width+30)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 5.0
  }
}


// MARK: UIPageViewControllerDataSource
extension FilesViewController: UIPageViewControllerDataSource {
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return orderedViewControllers.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return currentIndex
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
      if let index = orderedViewControllers.firstIndex(of: viewController) {
          if index > 0 {
            let index = index - 1
            currentIndex = index
            return orderedViewControllers[index]
          } else {
            let index = orderedViewControllers.count - 1
            currentIndex = index
            return orderedViewControllers[index]
          }
      }

      return nil
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
      if let index = orderedViewControllers.firstIndex(of: viewController) {
          if index < orderedViewControllers.count - 1 {
              let index = index + 1
              currentIndex = index
              return orderedViewControllers[index]
          } else {
            let index = 0
            currentIndex = index
            return orderedViewControllers[index]
          }
      }

      return nil
  }
  
}
