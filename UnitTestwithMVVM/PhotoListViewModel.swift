//
//  PhotoListViewModel.swift
//  UnitTestwithMVVM
//
//  Created by Knoxpo MacBook Pro on 24/12/20.
//

import Foundation
class PhotoListViewModel
{
    let apiservise: APIServiceProtocol
    private var photos: [Photo] = [Photo]()
    
    private var cellViewModel: [photoListCellViewModel] = [photoListCellViewModel]()
    {
        didSet
        {
            
            self.reloadTableviewClouser?()
            
        }
        
        
    }
    
    var isLOADING: Bool = false
    {
        didSet
        {
            self.updateLoadingStatus?()
            
        }
        
    }
    
    var alertMessage: String?
    {
        didSet{
            self.showalertClouse?()
            
        }
        
    }
    
    var numberOfCells: Int
    {
        return cellViewModel.count
        
    }
    var isAllowSeque: Bool = false
    var selectedPHOTOS: Photo?
    var reloadTableviewClouser: (()->())?
    var showalertClouse: (()->())?
    var updateLoadingStatus: (()->())?
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiservise = apiService
    }
    
    func initfech()
    {
        self.isLOADING = true
        apiservise.fetchPopularPhoto { [weak self] (success, photos, error) in
            self?.isLOADING = false
            if let error = error{
                
                self?.alertMessage = error.rawValue
                
            }
            else
            {
                self?.processFetchPhoto(photos: photos)
                
            }
            
            
            
            
            
        }
        
        
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> photoListCellViewModel {
        return cellViewModel[indexPath.row]
    }
    
    
    func createCellViewModel( photo: Photo ) -> photoListCellViewModel {

        //Wrap a description
        var descTextContainer: [String] = [String]()
        if let camera = photo.camera {
            descTextContainer.append(camera)
        }
        if let description = photo.description {
            descTextContainer.append( description )
        }
        let desc = descTextContainer.joined(separator: " - ")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return photoListCellViewModel( titleText: photo.name,
                                       descText: desc,
                                       imageUrl: photo.image_url,
                                       dataText: dateFormatter.string(from: photo.created_at) )
    }
    
    
    private func processFetchPhoto( photos: [Photo])
    {
        self.photos = photos
        
        var vms = [photoListCellViewModel]()
        for photo in photos
        {
            vms.append( createCellViewModel(photo: photo))
            
        }
        self.cellViewModel = vms
        
    }
    
    
    
}



extension PhotoListViewModel{
    
    func userPressed(at indexPath: IndexPath )
    {
        let photo = self.photos[indexPath.row]
        if photo.for_sale
        {
            self.isAllowSeque = true
            self.selectedPHOTOS = photo
            
        }
        else{
            
            self.isAllowSeque = false
            self.selectedPHOTOS = nil
            self.alertMessage = "This item not for sale"
            
        }
        
        
    }
    
    
    
    
    
}


struct photoListCellViewModel
{
    let titleText: String
    let descText: String
    let imageUrl: String
    let dataText: String
    
}
