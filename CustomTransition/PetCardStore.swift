
import UIKit

struct PetCardStore {

    static func defaultPets() -> [PetCard] {
        return parsePets()
    }

    private static func parsePets() -> [PetCard] {

        guard let filePath = NSBundle.mainBundle().pathForResource("Pets", ofType: "plist"), dictionary = NSDictionary(contentsOfFile: filePath), petData = dictionary["Pets"] as? [[String : String]] else {
            return []
        }

        let pets = petData.map { dict -> PetCard? in

            guard let name = dict["name"] else {
                return nil
            }

            guard let description = dict["description"] else {
                return nil
            }

            guard let imageName = dict["image"], image = UIImage(named: imageName) else {
                return nil
            }

            return PetCard(name: name, description: description, image: image)
        }

        let filtered = pets.flatMap({$0})
        
        return filtered
    }
    
}