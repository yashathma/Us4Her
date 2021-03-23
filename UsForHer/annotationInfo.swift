//
//  annotationInfo.swift
//  UsForHer
//
//  Created by Ben Levy on 3/20/21.
//

import SwiftUI
import Firebase
import MapKit

struct annotationInfo: View {
    
     var displayedInfo : MKAnnotation
    
    //var enabled : Bool
    
    
    let screenSize = UIScreen.main.bounds.size
    
    public func getColor(_ input: String)-> Color{
      
        if(input=="Following/Stalking"){
            return Color.yellow
        }
        if(input == "Suspicious Behaviour"){
            return Color.blue
        }
        if(input == "Verbal Assault/Cat Call" ){
            return Color.red
        }
        return Color.gray
    }
    

    func hoursFromIncident(_ input: mapAnnotation) -> String{
        let incidentTimestamp : Double = Double(input.time.seconds)
        let curTimestamp : Double = Double(Timestamp.init().seconds)
        
        let difTimestamp = curTimestamp - incidentTimestamp
        
        let difHours = difTimestamp / 3600
        
        let roundedDif = (difHours).rounded()
        let convertedToInt : Int64 = Int64(roundedDif)
        if(convertedToInt == 0){
            return "Within the Last Hour"
        }
        return "\(convertedToInt) hours ago"

    }

    
//    lazy var contentView: VIew
 
    var body: some View {
       // if(enabled){
            let title: String = (displayedInfo.title ?? "") ?? ""
            let description: String = (displayedInfo.subtitle ?? "") ?? ""
        ZStack{
            Rectangle() //creating rectangle for incident report
                .fill(getColor(title))
                .frame(width: 364, height: 264)
                .cornerRadius(20.0)
            
            Rectangle() //creating rectangle for incident report
                .fill(Color.white)
                .frame(width: 352, height: 252)
                .cornerRadius(14.0)
            
            HStack{
                Spacer()
                Text(title)
                    .fontWeight(.bold)
                Spacer()
            }
            //title
            .font(.title)
            .foregroundColor(Color.black)
            .position(x: (screenSize.width/2), y: 340)
            
            HStack{
                Text(description)
                    .frame(width: 340, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
//            Text("\(hoursFromIncident(displayedInfo))")
//                .fontWeight(.thin)
//                .position(x: (screenSize.width/2), y: 530)

      //  }
            Button(action: {
                actionSheet(displayedInfo)
            }, label: {
                Text("Share")
            })
            .position(x: UIScreen.main.bounds.size.width - 60, y: 530.0)
            
            Text("\(hoursFromIncident(displayedInfo as! mapAnnotation))")
                .fontWeight(.thin)
                .position(x: 100, y: 530)
            
        }
        
    }
    
    func actionSheet(_ choosen: MKAnnotation) {
        let position = choosen.coordinate
        let latString = "\(String(describing: position.latitude))"
        let longString = "\(String(describing: position.longitude))"
        let posString = "\(latString),\(longString)"
        
        let choosenpin = choosen
        
        var titleString = "\(String(describing: choosenpin.title)))"
        let descriptionString = "\(String(describing: choosenpin.subtitle)))"
        
        let titleEnd =  titleString.index(titleString.endIndex, offsetBy: -3)
        let titleStart = titleString.index(titleString.startIndex, offsetBy: 18)
        let titleRange = Range(uncheckedBounds: (lower: titleStart, upper: titleEnd))
        let titleFinal = titleString[titleRange]
    
        let descriptionStart = descriptionString.index(descriptionString.startIndex, offsetBy: 18)
        let descriptionEnd =  descriptionString.index(descriptionString.endIndex, offsetBy: -3)
        let descriptionRange = Range(uncheckedBounds: (lower: descriptionStart, upper: descriptionEnd))
        let descriptionFinal = descriptionString[descriptionRange]

            print(titleFinal)
        print(descriptionFinal)
        let items: [Any] = ["Watch out! There is a \(titleFinal) incident that may affect you! Here's some more info: \(descriptionFinal) and the location:", URL(string: "http://maps.google.com/maps/search/?api=1&query=\(posString)")! ]
           let av = UIActivityViewController(activityItems: items, applicationActivities: nil)
           UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
       }
}

struct annotationInfo_Preivews: PreviewProvider{
    static var previews: some View{
        annotationInfo(displayedInfo: MKMarkerAnnotationView.init() as! MKAnnotation)
    }
}


