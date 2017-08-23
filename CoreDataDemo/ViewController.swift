//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Manav on 22/08/17.
//  Copyright © 2017 Manav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var names = [Person]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        names = Database.DBinstance.fetchNames()
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return names.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = names[indexPath.row].name
        print(names[indexPath.row])
        return cell
    }
}


extension ViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let removeAction = UITableViewRowAction(style: .destructive, title: "") { action, indexPath in
            Database.DBinstance.deleteNames(withRow: indexPath.row)
            tableView.performBatchUpdates({
                self.names.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .middle)
            }, completion: nil)
        }
        
        let img: UIImage = UIImage(named: "remove")!
        let imgSize: CGSize = tableView.frame.size
        UIGraphicsBeginImageContext(imgSize)
        img.draw(in: CGRect(x: 20, y: 7.5, width: 30, height: 30))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        removeAction.backgroundColor = UIColor(patternImage: newImage)
        return [removeAction]
    }
}
