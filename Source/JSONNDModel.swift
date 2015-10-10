// The MIT License (MIT)

// Copyright (c) 2015 JohnLui <wenhanlv@gmail.com> https://github.com/johnlui

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//  JSONNDModel.swift
//  JSONNeverDie
//
//  Created by 吕文翰 on 15/10/3.
//

import Foundation

public class JSONNDModel: NSObject {
    
    public var JSONNDObject: JSONND!
    
    public required init(JSONNDObject json: JSONND) {
        self.JSONNDObject = json
        super.init()
        
        let mirror = Mirror(reflecting: self)
        if mirror.superclassMirror()?.children.count == 0 {
            return
        }
        for (k, v) in AnyRandomAccessCollection(mirror.children)! {
            if let key = k {
                let json = self.JSONNDObject[key]
                var valueWillBeSet: AnyObject?
                switch v {
                case _ as String:
                    valueWillBeSet = json.stringValue
                case _ as Int:
                    valueWillBeSet = json.intValue
                case _ as Float:
                    valueWillBeSet = json.floatValue
                case _ as Bool:
                    valueWillBeSet = json.boolValue
                case _ as JSONNDModel:
                    if let cls = NSClassFromString("JSONNeverDieExample." + key.capitalizedString) as? JSONNDModel.Type {
                        valueWillBeSet = cls.init(JSONNDObject: json)
                    }
                default:
                    break
                }
                self.setValue(valueWillBeSet, forKey: key)
            }
        }
    }
    
    public var jsonString: String? {
        get {
            return self.JSONNDObject?.jsonString
        }
    }
    public var jsonStringValue: String {
        get {
            return self.jsonString ?? ""
        }
    }
}
