//
//  DetailsViewController.swift
//  MyTvSeriesList
//
//  Created by Burak Afyonlu on 19.01.2023.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var seasonText: UITextField!
    @IBOutlet weak var imdbText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveClicked: UIButton!
    
    var chosenSeries = ""
    var chosenSeriesId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(selectImage))
        view.addGestureRecognizer(imageTapRecognizer)
        
        if chosenSeries != "" {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Series")
            let idString = chosenSeriesId?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        
                        if let name = result.value(forKey: "name") as? String {
                            nameText.text = name
                        }
                        if let season = result.value(forKey: "season") as? Int {
                            seasonText.text = "\(season) Season"
                        }
                        if let imdb = result.value(forKey: "imdb") as? Double {
                            imdbText.text = "IMDB :  \(imdb)"
                        }
                        if let imageData = result.value(forKey: "image") as? Data {
                            let image = UIImage(data: imageData)
                            imageView.image = image
                            
                        }
                    }
                }
                
            } catch {
                print("Error")
            }
            saveClicked.isHidden = true
            saveClicked.isEnabled = false
            nameText.isEnabled = false
            seasonText.isEnabled = false
            imdbText.isEnabled = false
        }
    }
    
    @objc func hideKeyboard() {
        
        view.endEditing(true)
        
    }
    
    @objc func selectImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
        
    }
    
    @IBAction func saveClicked(_ sender: Any) {
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newSeries = NSEntityDescription.insertNewObject(forEntityName: "Series", into: context)
        newSeries.setValue(nameText.text!, forKey: "name")
        
        if let season = Int(seasonText.text!) {
            newSeries.setValue(season, forKey: "season")
        }
        if let imdb = Double(imdbText.text!) {
            newSeries.setValue(imdb, forKey: "imdb")
        }
        newSeries.setValue(UUID(), forKey: "id")
        let data = imageView.image!.jpegData(compressionQuality: 0.5)
        newSeries.setValue(data, forKey: "image")
        
        do {
            try context.save()
        } catch {
            print("Error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    } 
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        saveClicked.isEnabled = true
    }
    
}
