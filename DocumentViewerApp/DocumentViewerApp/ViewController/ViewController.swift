//
//  ViewController.swift
//  DocumentViewerApp
//
//  Created by MAC on 13/04/19.
//  Copyright © 2019 PiyushVyas. All rights reserved.
//

import UIKit
import QuickLook

class ViewController: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var tblDoc: UITableView!
    
    //MARK:- Variable
    var arrDoc : [String] = []
    var fileURLs = [NSURL]()
    let quickLookController = QLPreviewController()
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrDoc = ["AppCoda-PDF.pdf",
                  "AppCoda-Pages.pages",
                  "AppCoda-Word.docx",
                  "AppCoda-Keynote.key",
                  "AppCoda-Text.txt",
                  "AppCoda-Image.jpeg"]
        self.prepareFileURLs()
        quickLookController.dataSource = self
        
    }
    
    //MARK:-
    func prepareFileURLs() {
        for file in arrDoc {
            let fileParts = file.components(separatedBy: ".")
            if let fileURL = Bundle.main.url(forResource: fileParts[0], withExtension: fileParts[1]) {
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    fileURLs.append(fileURL as NSURL)
                }
            }
        }
    }
    func extractAndBreakFilenameInComponents(fileURL: NSURL) -> (fileName: String, fileExtension: String) {
        // Break the NSURL path into its components and create a new array with those components.
        let fileURLParts = fileURL.path!.components(separatedBy: "/")
        
        // Get the file name from the last position of the array above.
        let fileName = fileURLParts.last
        
        // Break the file name into its components based on the period symbol (".").
        let filenameParts = fileName?.components(separatedBy: ".")
        
        // Return a tuple.
        return (filenameParts![0], filenameParts![1])
    }
    
    func getFileTypeFromFileExtension(fileExtension: String) -> String {
        var fileType = ""
        
        switch fileExtension {
        case "docx":
            fileType = "Microsoft Word document"
            
        case "pages":
            fileType = "Pages document"
            
        case "jpeg":
            fileType = "Image document"
            
        case "key":
            fileType = "Keynote document"
            
        case "pdf":
            fileType = "PDF document"
            
            
        default:
            fileType = "Text document"
            
        }
        
        return fileType
    }
    
    // MARK:- Button action
    @IBAction func btnTitleAction(_ sender: UIButton) {
        //-> Action
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, QLPreviewControllerDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 10
        //return arrDoc.count
        return fileURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblDoc.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //cell.textLabel?.text = "Title - \(indexPath.row)"
        //cell.detailTextLabel?.text = "Sub-title - \(indexPath.row)"
        
        //Title
        let currentFileParts = extractAndBreakFilenameInComponents(fileURL: fileURLs[indexPath.row])
        cell.textLabel?.text = currentFileParts.fileName
        
        //SubTitle
        cell.detailTextLabel?.text = getFileTypeFromFileExtension(fileExtension: currentFileParts.fileExtension)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if QLPreviewController.canPreview(fileURLs[indexPath.row]) {
            quickLookController.currentPreviewItemIndex = indexPath.row
            //navigationController?.pushViewController(quickLookController, animated: true)
            self.present(quickLookController, animated: true, completion: nil)
        }
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return fileURLs.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return fileURLs[index]
    }
    
}
