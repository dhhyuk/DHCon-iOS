//
//  GalleryViewController.swift
//  DHCon
//
//  Created by 김동혁 on 03/01/2019.
//  Copyright © 2019 김동혁. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class GalleryViewController: UIViewController, SelectImageCollectionViewDelegate {
    public static func Create(initialization: ((GalleryViewController) -> Void)? = nil) -> UIViewController {
        guard let navVC = UIStoryboard(name: "Gallery", bundle: Bundle.main).instantiateInitialViewController() as? UINavigationController else {
            return UIViewController()
        }
        
        if let galleryVC = navVC.topViewController as? GalleryViewController {
            initialization?(galleryVC)
        }
        
        return navVC
    }
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var barClose: UIBarButtonItem!
    @IBOutlet weak var cvImages: SelectImageCollectionView!
    
    public var completionSelect: ((UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        
        let photos = PHPhotoLibrary.authorizationStatus()
        switch photos {
        case .authorized:
            self.setupPhotosData()
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                guard status == .authorized else {
                    return
                }
                DispatchQueue.main.async {
                    self.setupPhotosData()
                }
            }
            
        default:
            break
        }
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2509803922, green: 0.2509803922, blue: 0.3529411765, alpha: 1),
            NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 32)!
        ]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        
        let closeView = CloseView()
        closeView.backgroundColor = UIColor.clear
        closeView.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
        closeView.isUserInteractionEnabled = true
        closeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(barCloseClick(_:))))
        self.barClose.customView = closeView
        
        self.cvImages.selectImageDelegate = self
    }
    
    private func setupPhotosData() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.cvImages.allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
    }
    
    
    // MARK: - Selectors
    
    @objc func barCloseClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func selectImageCollectionView(_ collectionView: SelectImageCollectionView, didSelectImageAt image: UIImage) {
        self.navigationController?.show(CropperViewController.Create(initialization: { (cropperVC) in
            cropperVC.image = image
        }), sender: nil)
        /*self.completionSelect?(image)
        self.dismiss(animated: true, completion: nil)*/
    }
}


protocol SelectImageCollectionViewDelegate {
    func selectImageCollectionView(_ collectionView: SelectImageCollectionView, didSelectImageAt image: UIImage)
}

class SelectImageCollectionView: UICollectionView,
        UICollectionViewDelegate, UICollectionViewDataSource,
        UICollectionViewDelegateFlowLayout {
    
    var allPhotos: PHFetchResult<PHAsset>? {
        didSet {
            return reloadData()
        }
    }
    var imageManager = PHCachingImageManager()
    
    var selectImageDelegate: SelectImageCollectionViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        register(UINib(nibName: "SelectImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SelectImageCollectionCell")
        
        self.setupCollectionViews()
    }
    
    private func setupCollectionViews() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        
        collectionViewLayout = flowLayout
        
        delegate = self
        dataSource = self
    }
    
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSources
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allPhotos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectImageCollectionCell", for: indexPath) as! SelectImageCollectionCell
        guard let allPhotos = self.allPhotos else {
            return cell
        }
        
        let asset = allPhotos.object(at: indexPath.item)
        cell.representedAssetIdentifier = asset.localIdentifier
        
        self.imageManager.requestImage(for: asset, targetSize: CGSize(width: 250, height: 250), contentMode: PHImageContentMode.aspectFill, options: nil) { (image, _) in
            guard cell.representedAssetIdentifier == asset.localIdentifier else {
                return
            }
            cell.image.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let assets = self.allPhotos, assets.count > 0 else { return }
        
        let asset = assets.object(at: indexPath.item)
        
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.resizeMode = .exact
        options.deliveryMode = .highQualityFormat
        
        self.imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: PHImageContentMode.aspectFill, options: options) { (image, _) in
            guard let image = image else { return }
            
            DispatchQueue.main.async {
                self.selectImageDelegate?.selectImageCollectionView(self, didSelectImageAt: image)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = collectionView.bounds.width / 3 - 0.5
        return CGSize(width: length, height: length)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
}
