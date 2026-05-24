import Foundation

class TaskAutomation {
    struct Task {
        let id: UUID = UUID()
        let name: String
        let steps: [String]
        let priority: Priority
        
        enum Priority {
            case low, medium, high, critical
        }
    }
    
    private var tasks: [UUID: Task] = [:]
    private var executionHistory: [ExecutionRecord] = []
    
    struct ExecutionRecord {
        let taskId: UUID
        let startTime: Date
        let endTime: Date
        let status: Status
        let results: [String]
        
        enum Status {
            case success, partial, failed
        }
    }
    
    func createTask(name: String, steps: [String], priority: Task.Priority = .medium) -> UUID {
        let task = Task(name: name, steps: steps, priority: priority)
        tasks[task.id] = task
        return task.id
    }
    
    func executeTask(_ taskId: UUID, executor: @escaping (String) async -> String) async -> ExecutionRecord {
        guard let task = tasks[taskId] else {
            return ExecutionRecord(
                taskId: taskId,
                startTime: Date(),
                endTime: Date(),
                status: .failed,
                results: ["Task not found"]
            )
        }
        
        let startTime = Date()
        var results: [String] = []
        var status: ExecutionRecord.Status = .success
        
        for step in task.steps {
            let result = await executor(step)
            results.append(result)
        }
        
        let record = ExecutionRecord(
            taskId: taskId,
            startTime: startTime,
            endTime: Date(),
            status: status,
            results: results
        )
        
        executionHistory.append(record)
        return record
    }
}
