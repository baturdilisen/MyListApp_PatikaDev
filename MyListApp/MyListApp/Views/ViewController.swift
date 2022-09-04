//
//  ViewController.swift
//  MyListApp
//
//  Created by Batuş on 3.09.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var alertController = UIAlertController()
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    @IBAction func didRemoveBarButtonItemTapped(_ sender: UIBarButtonItem) {
        presentAlert(title: "Warning",
                     message: "Are you sure about to delete all items?",
                     defaultButtonTitle: "Yes",
                     cancelButtonTitle: "Cancel") { _ in
            self.data.removeAll()
            self.tableView.reloadData()
        }
        
    }
    
    @IBAction func didAddBarButtonItemTapped(_ sender: UIBarButtonItem) {
        presentAddAlert()
    }
    
    
    func presentAddAlert() {
        presentAlert(title: "Add New Item",
                     message: nil,
                     defaultButtonTitle: "Add",
                     cancelButtonTitle: "Cancel", isTextFieldAvailable: true, defaultButtonHandler: { _ in
            let inputText = self.alertController.textFields?.first?.text
            if inputText != "" {
                self.data.append((inputText)!)
                self.tableView.reloadData()
            }
            else {
                self.presentWarningAlert()
            }
        })
        
    }
    
    func presentWarningAlert() {
        let alertController = UIAlertController(title: "Warning",
                                                message: "Blank item cannot be add",
                                                preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true)
        
        presentAlert(title: "Warning!",
                     message: "Blank item cannot be add!",
                     cancelButtonTitle: "OK!")
    }
    
    func presentAlert(title: String?,
                      message: String?,
                      preferredStyle: UIAlertController.Style = .alert,
                      defaultButtonTitle: String? = nil,
                      cancelButtonTitle: String?,
                      isTextFieldAvailable: Bool = false,
                      defaultButtonHandler: ((UIAlertAction) -> Void)? = nil) {
        
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: preferredStyle)
        
        if defaultButtonTitle != nil {
            let defaultButton = UIAlertAction(title: defaultButtonTitle,
                                              style: .default,
                                              handler: defaultButtonHandler)
            alertController.addAction(defaultButton)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        if isTextFieldAvailable {
            alertController.addTextField()
        }
        
        
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)         // Bu yaklaşımı yaptık çünkü kod/UI tarafındaki değişikliklerden UI/kod tarafının da haberi olmasını istiyoruz.
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal,
                                              title: "Delete") { _, _, _ in
            self.data.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        
        deleteAction.backgroundColor = .systemRed
        
        let editAction = UIContextualAction(style: .normal,
                                              title: "Edit") { _, _, _ in
            self.presentAlert(title: "Edit Item",
                              message: nil,
                              defaultButtonTitle: "Edit",
                              cancelButtonTitle: "Cancel",
                              isTextFieldAvailable: true,
                              defaultButtonHandler: { _ in
                let inputText = self.alertController.textFields?.first?.text
                if inputText != "" {
                    self.data[indexPath.row] = inputText!
                    self.tableView.reloadData()
                }
                else {
                    self.presentWarningAlert()
                }
            })
            
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return config
    }
}
