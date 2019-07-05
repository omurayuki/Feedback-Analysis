import Foundation

struct GoalDataStoreFactory {
    
    static func createGoalRemoteDataStore() -> GoalRemoteDataStore {
        return GoalRemoteDataStoreImpl()
    }
    
    static func createGoalLocalDataStore() -> GoalLocalDataStore {
        return GoalLocalDataStoreImpl()
    }
}
