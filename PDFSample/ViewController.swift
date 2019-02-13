//
//  ViewController.swift
//  PDFSample
//
//  Created by Waseel ASP Ltd. on 7/27/1437 AH.
//  Copyright © 1437 Waseel ASP Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var pageSize:CGSize!
    @IBOutlet weak var txtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnGeneratePDF(sender: AnyObject) {
        
        pageSize = CGSizeMake (850, 1100)
        
        let fileName: NSString = "kindle.pdf"
        
        let path:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let documentDirectory: AnyObject = path.objectAtIndex(0)
        
        let pdfPathWithFileName = documentDirectory.stringByAppendingPathComponent(fileName as String)
        
        self.generatePDFs(pdfPathWithFileName)
        
        //lines written to get the document directory path for the generated pdf file.
        
        if let documentsPath = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first?.path {
            
            print(documentsPath)
            
            // “var/folder/…/documents\n” copy the full path
            
        }
    }

    func generatePDFs(filePath: String) {
        
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil)
        
        //UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 768, 1024), nil)
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil)
        
        //toPDF()
        
        //self.drawBackground()
        
        //self.drawImage()
        
        //self.drawText()
        
        self.drawPageNumber(1)
        
        self.drawText2()
        
        UIGraphicsEndPDFContext()
        
    }
    
    // draw the custom background view to display the text and image in pdf.
    
    func drawBackground () {
        
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
    
        let rect:CGRect = CGRectMake(0, 0, pageSize.width, pageSize.height)
        
        CGContextSetFillColorWithColor(context, UIColor.brownColor().CGColor)
        
        CGContextFillRect(context, rect)
        
    }
    
    // draw the custom textview to display the text enter into it into pdf.
    // modified
    func drawText2(){
        
        /*let context:CGContextRef = UIGraphicsGetCurrentContext()!
        
        let font = UIFont(name: "HelveticaNeue-CondensedBold", size: CGFloat(15))!
        
        CGContextSetFillColorWithColor(context, UIColor.orangeColor().CGColor)
        
        let textRect : CGRect = CGRectMake(10, 50, 1014, 20)
        
         CGContextFillRect(context, textRect)*/
        
        var myString : NSString = "Dr. Sulaiman Al Habibaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbccccccccccccccccccccccccccccccccccddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeee eeeeeeeeeeffffffffffffffffffffffffffffffffffffffffffffffff"
        myString = "\(myString)\n"
        myString = "\(myString)______________________________________________________________"
        myString = "\(myString)\n"
        myString = "\(myString)12/12/2016"
        let currentText: CFAttributedStringRef  = CFAttributedStringCreate(nil, myString, nil)
        
        let framesetter: CTFramesetterRef = CTFramesetterCreateWithAttributedString(currentText);
        
        var done = false
        var currentRange : CFRange  = CFRangeMake(0, 0);
        repeat {
            currentRange = self.renderPageWithTextRange(currentRange, framesetter: framesetter)
        if currentRange.location == CFAttributedStringGetLength(currentText) {
            done = true;
        }
            
        } while !done
        /*
        let paraStyle = NSMutableParagraphStyle()
        
        paraStyle.lineSpacing = 6.0
        
        let fieldFont = UIFont(name: "Helvetica Bold", size: 15)
        
        let parameters: NSDictionary = [ NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle , NSFontAttributeName: fieldFont!]
        
        myString.drawInRect(textRect, withAttributes: parameters as? [String : AnyObject])
        */
    }
    
    // draw the custom textview to display the text enter into it into pdf.
    // original
    func drawText(){
        
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        
        let font = UIFont(name: "HelveticaNeue-UltraLight", size: CGFloat(20))!
        
        CGContextSetFillColorWithColor(context, UIColor.orangeColor().CGColor)
        
        let textRect : CGRect = CGRectMake(10, 50, ((self.txtView).frame).size.width, ((self.txtView).frame).size.height)
        
        let myString : NSString = "Dr. Sulaiman Al Habib"
        
        let paraStyle = NSMutableParagraphStyle()
        
        paraStyle.lineSpacing = 6.0
        
        let fieldFont = UIFont(name: "Helvetica Bold", size: 15)
        
        let parameters: NSDictionary = [ NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle , NSFontAttributeName: fieldFont!]
        
        myString.drawInRect(textRect, withAttributes: parameters as? [String : AnyObject])
        
    }
    
    // draw the custom image to display into pdf with the given text you enter into textview
    
    func drawImage(){
        
        let imgRect:CGRect = CGRectMake(284, 50, 200, 200)
        
        let image : UIImage = UIImage(named:"logo")!
        
        image.drawInRect(imgRect)
        
    }
    
    func renderPageWithTextRange(var currentRange: CFRange, framesetter: CTFramesetterRef) -> CFRange {
        // Get the graphics context.
        let currentContext : CGContextRef = UIGraphicsGetCurrentContext()!;
        
        // Put the text matrix into a known state. This ensures
        // that no old scaling factors are left in place.
        CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
        
        // Create a path object to enclose the text. Use 72 point
        // margins all around the text.
        let frameRect : CGRect  = CGRectMake(72, 72, 468, 648);
        let framePath : CGMutablePathRef  = CGPathCreateMutable();
        CGPathAddRect(framePath, nil, frameRect);
        
        // Get the frame that will do the rendering.
        // The currentRange variable specifies only the starting point. The framesetter
        // lays out as much text as will fit into the frame.
        let frameRef : CTFrameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, nil);
        //CGPathRelease(framePath);
        
        // Core Text draws from the bottom-left corner up, so flip
        // the current transform prior to drawing.
        CGContextTranslateCTM(currentContext, 0, 792);
        CGContextScaleCTM(currentContext, 1.0, -1.0);
        
        // Draw the frame.
        CTFrameDraw(frameRef, currentContext);
        
        // Update the current range based on what was drawn.
        currentRange = CTFrameGetVisibleStringRange(frameRef);
        currentRange.location += currentRange.length;
        currentRange.length = 0;
        //CFRelease(frameRef);
        
        return currentRange;
    }
    
    func drawPageNumber(pageNum: Int)
    {
        let pageString : NSString = NSString(format: "Page %d", pageNum)
        let theFont = UIFont(name: "Helvetica Bold", size: 12)
       
        let _ : CGSize = CGSizeMake(612, 72);
        let textAttributes = [NSFontAttributeName: theFont!]
        
        let pageStringSizeRect : CGRect  = pageString.boundingRectWithSize(CGSizeMake(320, 2000), options: .UsesLineFragmentOrigin, attributes: textAttributes, context: nil)
        
        let pageStringSize: CGSize = pageStringSizeRect.size
        
        
        let stringRect : CGRect  = CGRectMake(((612.0 - pageStringSize.width) / 2.0),
            720.0 + ((72.0 - pageStringSize.height) / 2.0),
            pageStringSize.width,
            pageStringSize.height);
        
        let parameters: NSDictionary = [ NSFontAttributeName:theFont!]
        pageString.drawInRect(stringRect, withAttributes: parameters as? [String : AnyObject])
        
    }

}

