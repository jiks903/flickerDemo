//
//  ViewController.swift
//  DemoZeoauto
//
//  Created by Jeegnesh Solanki on 08/03/25.
//

import UIKit



class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collHome: UICollectionView!
    
    private var images: [FlickrImage] = []
    private let fetcher = ImageFetcher()
    private var currentPage = 1
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchImages(page: currentPage)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width / 3 - 10, height: view.frame.width / 3 - 10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        collHome.collectionViewLayout = layout
        
        collHome.dataSource = self
        collHome.delegate = self
        let nib = UINib(nibName: "ImageCell", bundle: nil)
        collHome.register(nib, forCellWithReuseIdentifier: "ImageCell")

    }
    
    private func fetchImages(page: Int) {
        guard !isLoading else { return }
        isLoading = true
        
        fetcher.fetchImages(page: page) { [weak self] newImages in
            guard let self = self else { return }
            self.isLoading = false
            
            if let newImages = newImages {
                self.images.append(contentsOf: newImages)
                self.collHome.reloadData()
            }
        }
    }
    
    
    
}
// MARK: UICollectionView DataSource & Delegate
extension ViewController{
    // MARK: UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
         let imageInfo = images[indexPath.item]
        cell.actLoader.startAnimating()
         if let url = imageInfo.imageUrl {
             fetcher.loadImage(from: url) { image in
                 cell.imgView.image = image
                 cell.actLoader.stopAnimating()
             }
         }
         
         // Load more images when reaching last 5 items
         if indexPath.item == images.count - 5 {
             currentPage += 1
             //fetchImages(page: currentPage)
         }
         
         return cell
     }
    
    // MARK: Infinite Scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight * 2, !isLoading {
            currentPage += 1
            fetchImages(page: currentPage)
        }
    }
    //MARK: Select image
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImageInfo = images[indexPath.item]
        
        guard let url = selectedImageInfo.imageUrl else { return }
        
        fetcher.loadImage(from: url) { [weak self] image in
            //MARK: check image not NIL
            guard let self = self, let image = image else { return }
            
             let imageViewerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageViewerViewController") as! ImageViewerViewController
             imageViewerVC.image = image
             present(imageViewerVC, animated: true, completion: nil)
            
        }
    }
    // MARK: Release old images when scrolling stops
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let imageCell = cell as? ImageCell {
            imageCell.imgView.image = nil // Free memory
        }
    }
}


