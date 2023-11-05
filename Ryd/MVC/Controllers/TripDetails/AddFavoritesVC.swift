//
//  AddFavoritesVC.swift
//  Ryd Driver
//
//  Created by Prepladder on 23/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
import GooglePlaces

class AddFavoritesVC: UIViewController {

    @IBOutlet weak var txtFavorite: ACFloatingTextfield!
    @IBOutlet weak var btnAdd: UIButton!
    var objApi = ApiManager()
    var objAddLocation : AddFavoriteResponse?
    var locationCordinates : CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()

      //  addBackButton(str: "")
        //txtFavorite.becomeFirstResponder()
        self.makeborderr(sender: btnAdd)
    }
    
    @objc func makeborderr(sender: UIButton){
        sender.layer.cornerRadius = 12
        sender.layer.masksToBounds = true
        sender.layer.borderWidth = 2.0
        sender.layer.borderColor = UIColor.appColor.cgColor
    }
    
    @IBAction func addFavoriteAction(_ sender: Any) {
        let nameStr = txtFavorite.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if nameStr == ""{
            self.view.makeToast(AlertMessage.emptyFavorite.localized, duration: 3.0, position: .bottom)
        } else {
            if Reachability.isConnectedToNetwork(){
                showActivityIndicator(view: self.view, targetVC: self)
                callAddFavoritesLocation(locationName: nameStr, lat: "\(/self.locationCordinates?.latitude)", long: "\(/self.locationCordinates?.longitude)")
            }else {
                print(AlertMessage.noInternet.localized)
                self.view.makeToast(AlertMessage.noInternet.localized, duration: 3.0, position: .bottom)
            }

        }
    }



}

extension AddFavoritesVC {

    func callAddFavoritesLocation(locationName : String, lat: String, long: String){

        let params = [
            "location": locationName,
            "lat": lat,
            "lng": long
        ] as [String : Any]


        print("Change Password PARAMS => ", params)


        self.objApi.addFavorites(parameters: params, completion: { (response) in
            hideActivityIndicator(view: self.view)
            print(response.result.value)
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(AddFavoriteResponse.self, from: /response.data)
                    if loginResponse.status == true {
                        print(loginResponse)
                        self.navigationController?.popViewController(animated: true)
                    }else {
                        self.view.makeToast(/loginResponse.message, duration: 3.0, position: .bottom)
                    }

                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                break
            case .failure(_):
                print("response.result.error ",response.result.error as Any)
                break
            }

        })

    }

    @IBAction func textFieldTapped(_ sender: Any) {
        txtFavorite.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    }



extension AddFavoritesVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        print(place)
        txtFavorite.text = place.formattedAddress
        self.locationCordinates = place.coordinate
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}



//
//import UIKit
//import GooglePlaces
//
//class AddFavoritesVC: UIViewController,UISearchBarDelegate{
//
//    var resultsViewController: GMSAutocompleteResultsViewController?
//    var searchController: UISearchController?
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        resultsViewController = GMSAutocompleteResultsViewController()
//        resultsViewController?.delegate = self
//
//        searchController = UISearchController(searchResultsController: resultsViewController)
//        searchController!.searchResultsUpdater = resultsViewController
//
//        // Put the search bar in the navigation bar.
//        searchController!.searchBar.sizeToFit()
//        self.navigationItem.titleView = searchController?.searchBar
//
//        // When UISearchController presents the results view, present it in
//        // this view controller, not one further up the chain.
//        self.definesPresentationContext = true
//
//        // Prevent the navigation bar from being hidden when searching.
//        searchController!.hidesNavigationBarDuringPresentation = false
//        searchController!.searchBar.keyboardAppearance = UIKeyboardAppearance.dark
//        searchController!.searchBar.barStyle = .black
//
//        let filter = GMSAutocompleteFilter()
////        filter.country = "LK" //put your country here
//        filter.type = .establishment
//        resultsViewController?.autocompleteFilter = filter
//
//
//        searchController?.searchBar.showsCancelButton = true
//        searchController?.searchBar.delegate = self
//
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//
//        super.viewDidAppear(animated)
//        //self.searchController?.active = true
//        self.searchController!.searchBar.becomeFirstResponder()
//
//    }
//
//
//    func didPresentSearchController(searchController: UISearchController) {
//        self.searchController!.searchBar.becomeFirstResponder()
//    }
//
//
//}
//// Handle the user's selection.
//extension AddFavoritesVC: GMSAutocompleteResultsViewControllerDelegate {
//
//    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
//        print("Error: ", error)
//    }
//
//    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,didAutocompleteWith place: GMSPlace) {
//
//        // Do something with the selected place.
//        print("Pickup Place name: ", place.name)
//        print("Pickup Place address: ", place.formattedAddress)
//        print("Pickup Place attributions: ", place.placeID)
//    }
//
//
////    func resultsController(resultsController: GMSAutocompleteResultsViewController,
////                           didFailAutocompleteWithError error: NSError){
////        // TODO: handle the error.
////        print("Error: ", error.description)
////    }
//
//    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//
//    func didUpdateAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//
//
//}
