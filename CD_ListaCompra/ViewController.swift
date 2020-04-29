//
//  ViewController.swift
//  CD_ListaCompra
//
//  Created by Miguel on 19/04/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    private let idCell = "idCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lista de la compra"
        table.register(UITableViewCell.self, forCellReuseIdentifier: idCell)
        table.dataSource = self
    }

    
    // MARK: - IBActions
    
    @IBAction func onAddBtn(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(title: "Nuevo artículo", message: nil, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Añadir", style: .default) {
            [weak alertVC, weak self] (action:UIAlertAction) in
            if let textField = alertVC?.textFields?.first,
                let item = textField.text, item.trimmingCharacters(in: .whitespaces).isEmpty == false
            {
                Persistator.single.guardarArticulo(item)
                self?.table.insertRows(at: [IndexPath(row: Persistator.single.numeroDeArticulos-1, section: 0)], with: .right)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertVC.addTextField(configurationHandler: nil)
        alertVC.addAction(addAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func onBtnEdit(_ sender: UIBarButtonItem) {
        table.setEditing(table.isEditing == false, animated: true)
    }
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Persistator.single.numeroDeArticulos
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: idCell)!
        cell.textLabel?.text = Persistator.single.nombreArticulo(at: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Persistator.single.borrarArticulo(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            print("undefined")
        }
    }
    

}

