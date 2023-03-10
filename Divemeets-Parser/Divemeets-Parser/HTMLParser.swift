//
//  HTMLParser.swift
//  Divemeets-Parser
//
//  Created by Spencer Dearman on 3/3/23.
//

import SwiftSoup
import Foundation

final class HTMLParser{
    func parse(html: String) -> String {
        do {
            let document: Document = try SwiftSoup.parse(html)
            guard let body = document.body() else {
                return ""
            }
            let main = try body.getElementsByTag("body").compactMap({try? $0.html()})
            let html = main[0]
            let doc:Document = try SwiftSoup.parse(html)
            //print(doc)
            //print(try doc.getElementsByTag("tbody"))
            //let bodySection = doc.body()
            //print(bodySection!)
            //let tds = try doc.getElementsByTag("tr")
            //print(try tds.text())
            
            let myRows : Elements? = try doc.getElementsByTag("tr")
            try myRows!.forEach({ row in
                print(try row.text())
            })
        }
        catch {
            print("Error Parsing: " + String(describing: error))
        }
        return html
    }
}
