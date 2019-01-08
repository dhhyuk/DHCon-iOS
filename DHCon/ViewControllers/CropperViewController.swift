//
//  CropperViewController.swift
//  DHCon
//
//  Created by 김동혁 on 09/01/2019.
//  Copyright © 2019 김동혁. All rights reserved.
//

import UIKit

class CropperViewController: UIViewController, UIScrollViewDelegate {
    public static func Create(initialization: ((CropperViewController) -> Void)? = nil) -> UIViewController {
        guard let cropperVC = UIStoryboard(name: "Gallery", bundle: Bundle.main)
            .instantiateViewController(withIdentifier: "CropperViewController") as? CropperViewController else {
            return UIViewController()
        }
        
        initialization?(cropperVC)
        
        return cropperVC
    }
    
    
    // MARK: - IBOutlets

    @IBOutlet weak var viewCropContainer: UIView!
    @IBOutlet weak var viewCropScroll: UIScrollView!
    @IBOutlet weak var imageTarget: UIImageView!
    @IBOutlet weak var imageTargetWidth: NSLayoutConstraint!
    @IBOutlet weak var imageTargetHeight: NSLayoutConstraint!
    
    
    var image: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews()
        self.setupTargetImage()
        
        self.viewCropScroll.minimumZoomScale = 1.0
        self.viewCropScroll.minimumZoomScale = 10.0
        self.viewCropScroll.delegate = self
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2509803922, green: 0.2509803922, blue: 0.3529411765, alpha: 1),
            NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 32)!
        ]
    }
    
    private func setupTargetImage() {
        guard let image = self.image else {
            return
        }
        
        DispatchQueue.main.async {
            self.imageTarget.image = image
            
            let widthPoint = image.size.width
            let heightPoint = image.size.height
            
            if heightPoint / 120 > widthPoint / 120 {
                let ratio = heightPoint / widthPoint
                self.imageTargetWidth.constant = 120
                self.imageTargetHeight.constant = 120 * ratio
                self.viewCropScroll.contentOffset = CGPoint(
                    x: 0,
                    y: self.imageTargetHeight.constant / 2 - 120 / 2)
            }
            else {
                let ratio = widthPoint / heightPoint
                self.imageTargetWidth.constant = 120 * ratio
                self.imageTargetHeight.constant = 120
                self.viewCropScroll.contentOffset = CGPoint(
                    x: self.imageTargetWidth.constant / 2 - 120 / 2,
                    y: 0)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.viewCropScroll.updateConstraints()
        self.imageTarget.updateConstraints()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageTarget
    }
}
