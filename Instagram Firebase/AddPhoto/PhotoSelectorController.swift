//
//  PhotoSelectorController.swift
//  Instagram Firebase
//
//  Created by max on 04.04.2022.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        setupNavigationButtons()
        
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        DispatchQueue.main.async {
            self.fetchPhotos()
        }
        
    }
    
    var selectedImage: UIImage?
    var images = [UIImage]()
    var assets = [PHAsset]()
    
    fileprivate func assetsFetchOption() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    fileprivate func fetchPhotos() {
        
        let fetchOption = PHFetchOptions()
        fetchOption.fetchLimit = 10
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        PHPhotoLibrary.shared().register(self)
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
              let fetchedImageAssets = PHAsset.fetchAssets(with: .image, options: fetchOption)
              fetchedImageAssets.enumerateObjects { (phAsset, index, stop) in
                let imageRequestOptions = PHImageRequestOptions()
                imageRequestOptions.isSynchronous = true
                PHImageManager.default().requestImage(
                  for: phAsset,
                  targetSize: CGSize(width: 200, height: 200),
                  contentMode: .aspectFit,
                  options: imageRequestOptions) { (image, info) in
                    guard let image = image else { return }
                    self.images.append(image)
                    self.assets.append(phAsset)
                    
                    if self.selectedIndex == nil {
                      self.selectedIndex = 0
                    }
                    
                    if index == fetchedImageAssets.count - 1 {
                      DispatchQueue.main.async {
                        print("fetch successfully")
                        self.collectionView.reloadData()
                      }
                    }
                }
            }
            default: ()
            }
        }
    }
    
    var selectedIndex: Int?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard selectedIndex != indexPath.item else { return }
        selectedIndex = indexPath.item
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    var header: PhotoSelectorHeader?
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeader
        
        self.header = header
        
        if let selectedIndex = selectedIndex {
            header.photoImageView.image = images[selectedIndex]
          
          PHImageManager.default().requestImage(for: assets[selectedIndex], targetSize: CGSize(width: 2000, height: 2000), contentMode: .default, options: nil) { (image, info) in
            guard let image = image else { return }
            if self.selectedIndex == selectedIndex {
              header.photoImageView.image = image
            }
          }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
//        cell.backgroundColor = .blue
        
        cell.photoImageView.image = images[indexPath.item]
        
        return cell
    }
    
    fileprivate func setupNavigationButtons() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNext() {
        let sharePhotoController = SharePhotoController()
        sharePhotoController.modalPresentationStyle = .fullScreen
        sharePhotoController.selectedImage = header?.photoImageView.image
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
}

extension PhotoSelectorController: PHPhotoLibraryChangeObserver {
  
  func photoLibraryDidChange(_ changeInstance: PHChange) {
    
  }
}
