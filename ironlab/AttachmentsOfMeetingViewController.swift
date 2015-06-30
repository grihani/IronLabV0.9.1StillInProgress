//
//  AttachmentsOfMeetingViewController.swift
//  IronLab
//
//  Created by CSC CSC on 12/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit
import MobileCoreServices
import QuickLook

class AttachmentsOfMeetingViewController: UIViewController{
    
    @IBOutlet var documentsTableView: UITableView! {
        didSet {
            documentsTableView.dataSource = self
            documentsTableView.delegate = self
            
        }
    }
    @IBOutlet var previewView: UIView! {
        didSet {
            
        }
    }
    
    var correspondenceFileIcon : [String: String] = [
        "xlsx": "excelIcon",
        "xls": "excelIcon",
        "pdf": "pdfIcon",
        "docx": "wordIcon",
        "doc": "wordIcon",
        "ppt": "powerPointIcon",
        "pptx": "powerPointIcon",
        "jpg": "Images",
        "png": "Images",
        "bmp": "Images",
        "gif": "Images",
        
    ]
    static let allOtherFiles = "allFilesIcon"
    
    // MARK: - Models
    
    var meeting: MeetingsModel!
    
    // MARK: - Compounded values
    
    var documents: [String] {
        let pathToDocumentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let meetingDocumentDirectory = pathToDocumentsFolder.stringByAppendingPathComponent("/Meetings/\(self.meeting.idMeeting)")
        if NSFileManager.defaultManager().fileExistsAtPath(meetingDocumentDirectory) {
            if let directoryContents =  NSFileManager.defaultManager().contentsOfDirectoryAtPath(meetingDocumentDirectory, error: nil) {
                return directoryContents as! [String]
            }
        }
        return []
    }
    
    var documentsURL: [NSURL] {
        let pathToDocumentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let meetingDocumentDirectory = pathToDocumentsFolder.stringByAppendingPathComponent("/Meetings/\(self.meeting.idMeeting)")
        var docsPaths: [NSURL] = []
        if NSFileManager.defaultManager().fileExistsAtPath(meetingDocumentDirectory) {
            if let directoryContents =  NSFileManager.defaultManager().contentsOfDirectoryAtPath(meetingDocumentDirectory, error: nil) {
                for content in directoryContents {
                    docsPaths.append(NSURL(fileURLWithPath: meetingDocumentDirectory.stringByAppendingPathComponent("/\(content)"))!)
                }
            }
        }
        println(docsPaths)
        return docsPaths
    }
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - import files action
    
    @IBAction func importFiles(sender: UIBarButtonItem) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeContent as String, kUTTypeData as String], inMode: UIDocumentPickerMode.Import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        presentViewController(documentPicker, animated: true, completion: nil)
    }
    
    @IBOutlet var disableEnable: UIButton!
    @IBAction func stopUserInteraction(sender: UIButton) {
        if let superView = self.view.superview as? UIScrollView{
            superView.scrollEnabled = !superView.scrollEnabled
            if superView.scrollEnabled {
                disableEnable.setImage(UIImage(named: "enableGesture"), forState: .Normal)
            } else {
                disableEnable.setImage(UIImage(named: "disableTouch"), forState: .Normal)
            }
        }
    }
    
    // MARK: - Files functions
    
    func deleteDocument(index: Int) {
        NSFileManager.defaultManager().removeItemAtURL(documentsURL[index], error: nil)
    }
    
}

extension AttachmentsOfMeetingViewController: UIDocumentPickerDelegate {
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        if controller.documentPickerMode == UIDocumentPickerMode.Import {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let documentPath = url.path!
                let documentName = documentPath.lastPathComponent
                
                let fileManager = NSFileManager.defaultManager()
                var error: NSError? = NSError()
                let pathToDocumentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
                let meetingDocumentDirectory = pathToDocumentsFolder.stringByAppendingPathComponent("/Meetings/\(self.meeting.idMeeting)")
                if !fileManager.fileExistsAtPath(meetingDocumentDirectory) {
                    if fileManager.createDirectoryAtPath(meetingDocumentDirectory, withIntermediateDirectories: true, attributes: nil, error: &error) {
                        println("created")
                    }
                }
                let storePath = meetingDocumentDirectory.stringByAppendingPathComponent("/").stringByAppendingPathComponent(documentName)
                var fileCopyError: NSError? = NSError()
                
                if fileManager.moveItemAtPath(documentPath, toPath: storePath, error: &fileCopyError) {
                    println("done copying")
                    self.documentsTableView.reloadData()
                }
                else {
                    println("impossible to copy")
                }
            })
        }
    }
}

extension AttachmentsOfMeetingViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("documents", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = documents[indexPath.row]
        let pathExtension = documents[indexPath.row].pathExtension
        if correspondenceFileIcon[pathExtension] != nil {
            let image = UIImage(named: correspondenceFileIcon[pathExtension]!)
            cell.imageView?.image = image
        }
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "delete") { (action, indexPath) -> Void in
            self.deleteDocument(indexPath.row)
            tableView.reloadData()
        }
        
        return [deleteAction]
        
    }
}

extension AttachmentsOfMeetingViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let preview = QLPreviewController()
        preview.dataSource = self
        preview.currentPreviewItemIndex = indexPath.row
        self.presentViewController(preview, animated: false, completion: nil)
    }
}

extension AttachmentsOfMeetingViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController!) -> Int {
        return documentsURL.count
    }
    func previewController(controller: QLPreviewController!, previewItemAtIndex index: Int) -> QLPreviewItem! {
        return documentsURL[index]
    }
}