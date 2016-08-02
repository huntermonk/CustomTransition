
import UIKit

struct PetCardStore {

    static func defaultPets() -> [PetCard] {
        return parsePets()
    }

    private static func parsePets() -> [PetCard] {

        guard let filePath = NSBundle.mainBundle().pathForResource("Pets", ofType: "plist"), dictionary = NSDictionary(contentsOfFile: filePath), petData = dictionary["Pets"] as? [[String : String]] else {
            return []
        }

        let pets = petData.map { dict -> PetCard in
            return PetCard(name: dict["name"]!, description: dict["description"]!, image: UIImage(named: dict["image"]!)!)
        }
        
        return pets
    }
    
}