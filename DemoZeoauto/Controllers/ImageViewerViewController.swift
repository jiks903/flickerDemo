//
//  ImageViewerViewController.swift
//  DemoZeoauto
//
//  Created by Jeegnesh Solanki on 08/03/25.
//

import UIKit

class ImageViewerViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var scView: UIScrollView!
    
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupScrollView()
        setupImageView()
        setupCloseButton()
    }
    
     func setupScrollView() {
        scView.delegate = self
        scView.minimumZoomScale = 1.0
        scView.maximumZoomScale = 4.0
        scView.showsVerticalScrollIndicator = false
        scView.showsHorizontalScrollIndicator = false
    }
    
    private func setupImageView() {
        imgView.image = image
        imgView.contentMode = .scaleAspectFit
        imgView.frame = scView.bounds
    }
    
    private func setupCloseButton() {
        btnClose.setTitle("✕", for: .normal)
        btnClose.tintColor = .white
        btnClose.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        btnClose.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
}
