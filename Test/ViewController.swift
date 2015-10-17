//
//  ViewController.swift
//  Test
//
//  Created by David Brown on 20/09/2015.
//  Copyright (c) 2015 Davie. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, NSXMLParserDelegate {
    var mutableData:NSMutableData  = NSMutableData();

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBOutlet weak var resultfield: UILabel!

    @IBOutlet weak var button2: UIButton!
    

    @IBAction func button2click(sender: AnyObject) {
        CallWebServiceOnDavies();
    }
    @IBOutlet weak var textfield2: UILabel!
    var didStartElement = 0
    var didEndElement = 0
    var foundCharacters = 0
    var text=""
    var element:String = "CelsiusToFahrenheitResult";
    var recordingElementValue:Bool=false
     var currentElementName:NSString = ""
    
    
    
    // This doesn't work yet - calling a WCF service.
    func CallWebServiceOnDavies(){
        
        // This would likely be taken from an input.
        //let celcius = textfield.text;
        
        //let celcius =  textfield.text!;
        
        
        
        
        let soapMessage = "<s:Envelope xmlns:s='http://schemas.xmlsoap.org/soap/envelope/'> <s:Header><Action s:mustUnderstand='1' xmlns='http://schemas.microsoft.com/ws/2005/05/addressing/none'>http://tempuri.org/IService1/GetData</Action></s:Header><s:Body><GetData xmlns='http://tempuri.org/'><value>10</value></GetData></s:Body>"
        
        print(soapMessage);
        let urlString =  "http://davie-PC.local/TestWebService/Service1.svc"
        let url = NSURL(string: urlString)
        let theRequest = NSMutableURLRequest(URL: url!)
        let msgLength = String(soapMessage.characters.count)
        
        
        
        // this doesn't work for calling a WCF service
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        theRequest.addValue("http://tempuri.org/", forHTTPHeaderField: "SOAPAction")
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        NSURLConnection(request: theRequest, delegate: self, startImmediately: true)
        // Do NOT call start since the above call will start the connection
        
        
    }
    
  func CallWebService(){
    
    // This would likely be taken from an input.
    //let celcius = textfield.text;
   
    let celcius =  textfield.text!;
    
    let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><CelsiusToFahrenheit xmlns='http://www.w3schools.com/webservices/'><Celsius>\(celcius)</Celsius></CelsiusToFahrenheit></soap:Body></soap:Envelope>"
    
    print(soapMessage);
    let urlString =  "http://www.w3schools.com/webservices/tempconvert.asmx?op=CelsiusToFahrenheit"
    let url = NSURL(string: urlString)
    let theRequest = NSMutableURLRequest(URL: url!)
    let msgLength = String(soapMessage.characters.count)
    
   
    
    
    
    theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
    theRequest.addValue(msgLength, forHTTPHeaderField: "Content-Length")
    theRequest.addValue("http://www.w3schools.com/webservices/CelsiusToFahrenheit", forHTTPHeaderField: "SOAPAction")
    theRequest.HTTPMethod = "POST"
    theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    
    NSURLConnection(request: theRequest, delegate: self, startImmediately: true)
    // Do NOT call start since the above call will start the connection

    
    }
    
    @IBAction func Clicked(sender: AnyObject) {
        
        CallWebService();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
       
        print(response);
        
        if let httpResponse = response as? NSHTTPURLResponse {
            
            // Just printing the status code here.
            print("error \(httpResponse.statusCode)")

             
        }
        
        // We got a response to set the length of the data to zero since we will be adding to this
        // if we actually got any data back.
        mutableData.length = 0;
  
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        mutableData.appendData(data)
    
    }
    
    // Parse the result right after loading
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        
        
       // var urlString =  "http://www.w3schools.com/xml/note.xml"
        //var url = NSURL(string: urlString)
        
        
        print(mutableData)
        
        let xmlParser = NSXMLParser(data: mutableData)
      
        //var xmlParser = NSXMLParser(contentsOfURL: url);
        xmlParser.delegate = self
        xmlParser.shouldProcessNamespaces = false
        xmlParser.shouldReportNamespacePrefixes = false
        xmlParser.shouldResolveExternalEntities = false
        xmlParser.parse()
    }

    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        didStartElement += 1
        
        print(elementName);
        
        if elementName==element{
            recordingElementValue=true
        }
        
        currentElementName = elementName
        
    }

    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        didEndElement += 1
        
        if elementName==element{
            recordingElementValue=false
        }
        
        
    }
    

    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        
        foundCharacters += 1
        
        //println("found chars: @", string);
        print("found chars: \(string)");
        resultfield.text = string
        if currentElementName == "CelsiusToFahrenheitResult" {
           //println("Result: @" ,string)
        }
        
        
        if recordingElementValue{
            text+=string           //println(string);
        }
        
        

    }
    
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print("parseErrorOccurred: \(parseError)")
    }
    
}



