import Foundation
import FirebaseFirestore

extension GoalPostEditViewController {
    
    func validateGoalPost(genre: [String],
                          newThings: String? = nil,
                          expectedResult1: String? = nil,
                          expectedResult2: String? = nil,
                          expectedResult3: String? = nil,
                          execute: @escaping (_ genre: [String], _ newThings: String,
        _ expectedResult1: String, _ expectedResult2: String, _ expectedResult3: String) -> Void) {
        switch GoalPostValidation.validate(genre: genre,
                                           newThings: newThings,
                                           expectedResult1: expectedResult1,
                                           expectedResult2: expectedResult2,
                                           expectedResult3: expectedResult3) {
        case .empty(let str):          self.showError(message: str)
        case .exceeded(let str):       self.showError(message: str)
        case .ok(let genre, let newThings,
                 let expectedResult1, let expectedResult2,
                 let expectedResult3): execute(genre, newThings ?? "", expectedResult1 ?? "", expectedResult2 ?? "", expectedResult3 ?? "")
        }
    }
    
    func createGoalPost(genre: [String],
                        newThings: String,
                        expectedResultField1: String,
                        expectedResultField2: String,
                        expectedResultField3: String,
                        deadline: String, draft: Bool) -> GoalPost {
        return GoalPost(genre: ["genre1": genre[0],
                                "genre2": genre[1]],
                        newThings: newThings,
                        goal: ["goal1": expectedResultField1,
                               "goal2": expectedResultField2,
                               "goal3": expectedResultField3],
                        deadline: deadline, achievedFlag: false,
                        draftFlag: draft, likeCount: 0,
                        commentedCount: 0, authorToken: AppUserDefaults.getAuthToken(),
                        createdAt: FieldValue.serverTimestamp(),
                        updatedAt: FieldValue.serverTimestamp())
    }
}
