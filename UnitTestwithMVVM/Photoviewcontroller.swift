//
//  Photoviewcontroller.swift
//  UnitTestwithMVVM
//
//  Created by Knoxpo MacBook Pro on 24/12/20.
//

import UIKit
import SDWebImage

class Photoviewcontroller: UIViewController
{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actiivityIndicator: UIActivityIndicatorView!
    
    
    
    
    lazy var viewModel: PhotoListViewModel = {
        
        
        return PhotoListViewModel()
        
        
    }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        initVM()
        
        
    }
    
    func initView()
    {
        
        self.navigationItem.title = "populer"
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        
        
    }
    func initVM() {
        
        // Naive binding
        viewModel.showalertClouse = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLOADING ?? false
                if isLoading {
                    self?.actiivityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 0.0
                    })
                }else {
                    self?.actiivityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableviewClouser = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.initfech()

    }
    
    func showAlert( _ message: String)
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
}

extension Photoviewcontroller: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCellIdentifier", for: indexPath) as? PhotoListTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.photoListCellViewModel = cellVM
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        self.viewModel.userPressed(at: indexPath)
        if viewModel.isAllowSeque {
            return indexPath
        }else {
            return nil
        }
    }

}

extension Photoviewcontroller {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
      //  if let vc = segue.destination as? PhotoDetailViewController,
       //     let photo = viewModel.selectedPHOTOS {
         //   vc.imageUrl = photo.image_url
      //  }
    //}
}

class PhotoListTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descContainerHeightConstraint: NSLayoutConstraint!
    var photoListCellViewModel : photoListCellViewModel? {
        didSet {
            nameLabel.text = photoListCellViewModel?.titleText
            descriptionLabel.text = photoListCellViewModel?.descText
            mainImageView?.sd_setImage(with: URL( string: photoListCellViewModel?.imageUrl ?? "" ), completed: nil)
            dateLabel.text = photoListCellViewModel?.dataText
        }
    }
}

