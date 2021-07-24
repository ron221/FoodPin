//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Ron Yeh on 2021/7/23.
//

import UIKit

class RestaurantTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurantNames, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)

    }

    var restaurantNames = ["Cafe Deadend", "Homie", "Teakha", "Cafe Loisl", "Petite Oyster", "For Kee Restaurant", "Po's Atelier", "Bourke Street Bakery", "Haigh's Chocolate", "Palamino Espresso", "Upstate", "Traif", "Five Leaves",  "Confessional", "Barrafina", "Donostia", "Royal Oak"]
    
    var restaurantImages = ["cafedeadend", "homei", "teakha", "cafeloisl", "petiteoyster", "forkeerestaurant", "posatelier", "bourkestreetbakery", "haighschocolate", "palominoespresso", "upstate", "traif", "fiveleaves", "confessional", "barrafina", "donostia", "royaloak"]
    
    var restaurantLocations = ["Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Sydney", "Sydney", "Sydney", "New York", "New York", "New York", "New York", "London", "London", "London"]
    
    var restaurantTypes = ["Coffee & Tea Shop", "Cafe", "Tea House", "Austrian / Casual Drink", "French", "Bakery", "Bakery", "Chocolate", "Cafe", "Americam / Seafood", "American", "American", "Coffee & Tea", "Spanish", "Spanish", "Spanish", "Britsh"]
    enum Section {
        case all
    }
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, String> {
        let cellIdentifier = "datacell"
        
        let dataSource = UITableViewDiffableDataSource<Section, String>(
            tableView: tableView, cellProvider: {
                tableView, indexPath, restaurantName in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
                
                cell.nameLabel.text = self.restaurantNames[indexPath.row]
                cell.thumbnailImageView.image = UIImage(named: self.restaurantImages[indexPath.row])
                cell.locationLabel.text = self.restaurantLocations[indexPath.row]
                cell.typeLable.text = self.restaurantTypes[indexPath.row]

                cell.heartImageView.isHidden = self.restaurantIsFavorite[indexPath.row] ? false : true
                return cell
            }
        )
        return dataSource
    }
    
    lazy var dataSource = configureDataSource()
    var restaurantIsFavorite = Array(repeating: false, count: 17)
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Create options for action list
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        
        // Add actions into action list
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        // Display action list
//        present(optionMenu, animated: true, completion: nil)
        
        // Add reserve restaurant action
        let reserveActionHandler = { (action:UIAlertAction!) -> Void in
            
            let alertMessage = UIAlertController(title: "Not available yet", message: "Sorry, this feature is not available yet. Please try later", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
        
        let reserveAction = UIAlertAction(title: "Reserve a table", style: .default, handler: reserveActionHandler)
        optionMenu.addAction(reserveAction)
        
        // Mark as favourite action
        let favouriteAction = UIAlertAction(title: "Mark as favourite", style: .default, handler:{
            (action:UIAlertAction!) -> Void in
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
//            cell?.accessoryType = .checkmark
//            cell?.tintColor = .systemYellow
            cell.heartImageView.isHidden = self.restaurantIsFavorite[indexPath.row]
            
            self.restaurantIsFavorite[indexPath.row] = true
        })
        
        // Remove from favourite action
        let removeFromFavouriteAction = UIAlertAction(title: "Remove from favourite", style: .default, handler:{
            (action:UIAlertAction!) -> Void in
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
//            cell?.accessoryType = .none
//            cell?.tintColor = .systemYellow
            cell.heartImageView.isHidden = self.restaurantIsFavorite[indexPath.row]
            self.restaurantIsFavorite[indexPath.row] = false
        })
        if self.restaurantIsFavorite[indexPath.row] == false {
            optionMenu.addAction(favouriteAction)
        } else {
            optionMenu.addAction(removeFromFavouriteAction)
        }
        
        present(optionMenu, animated: true, completion: nil)
        
        // To cancel row selection
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
