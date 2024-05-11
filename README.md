## Netlink
An iOS SDK to do HTTP network calls. </br>
Netlink is a lightweight CocoaPod for making HTTP network calls in Swift. It provides simple methods to perform GET and POST requests, parsing the response into <b>generic Swift models or structs.</b>

## Installation
You can easily integrate Netlink into your project using CocoaPods. Add the following line to your Podfile:

```ruby
pod 'Netlink', '~> 1.0'
```
Then, run pod install from the terminal.

## Usage
### GET Request
To perform a GET request using Netlink, call the get method:

```swift
NetLink.get(urlString: "https://example.com/api/data", queryItems: ["param": "value"], headers: ["Authorization": "Bearer token"])
    .sink(receiveCompletion: { completion in
        // Handle completion (success or failure)
    }, receiveValue: { response: YourModelType in
        // Handle successful response
    })
    .store(in: &cancellables)
```

### POST Request
To perform a POST request using Netlink, call the post method:

```swift
NetLink.post(urlString: "https://example.com/api/post", queryItems: nil, headers: nil, payload: ["key": "value"])
    .sink(receiveCompletion: { completion in
        // Handle completion (success or failure)
    }, receiveValue: { response: YourModelType in
        // Handle successful response
    })
    .store(in: &cancellables)
```

##### Note: `queryItems` and `headers` are optional parameters in the `get` and `post` function

## Example: Todo Model
Here's an example of how you can use Netlink with a Todo model:

```swift
import Foundation
import Combine

class Apiservice {
    
    // Function to fetch data via GET request
    func getData<T>(urlString: String, responseType: T.Type) -> Future<T, Error> where T: Codable {
        return NetLink.get(urlString: urlString)
    }
    
    // Function to send data via POST request
    func sendData<T>(urlString: String, payload: [String: Any], responseType: T.Type) -> Future<T, Error> where T: Codable {
        return NetLink.post(urlString: urlString, payload: payload)
    }
}
```

And here's how you can use these functions:
```swift
struct TodoItem: Codable {
    let id: Int
    let title: String
    let completed: Bool
}


class SomeClass {
    private var storage = Set<AnyCancellable>()
    private let apiService = Apiservice()
    
    func fetchTodoItem() {
        apiService.getData(urlString: "https://jsonplaceholder.typicode.com/todos/1", responseType: TodoItem.self)
            .receive(on: DispatchQueue.main)
            .clubIntoResult()
            .sink { result in
                switch result {
                case .success(let todoItem):
                    // Handle successful response
                    print(todoItem)
                case .failure(let error):
                    // Handle error
                    print(error)
                }
            }
            .store(in: &storage)
    }
    
    func createTodoItem() {
        let newTodo: [String: Any] = ["title": "New Todo", "completed": false]
        apiService.sendData(urlString: "https://jsonplaceholder.typicode.com/todos", payload: newTodo, responseType: TodoItem.self)
            .receive(on: DispatchQueue.main)
            .clubIntoResult()
            .sink { result in
                switch result {
                case .success(let createdTodo):
                    // Handle successful response
                    print(createdTodo)
                case .failure(let error):
                    // Handle error
                    print(error)
                }
            }
            .store(in: &storage)
    }
}
```

### Note 
Netlink provides a Publisher extension `clubIntoResult()` </br>
clubIntoResult() operator in Combine transforms a Publisher's output stream into a Result type, encapsulating both success and failure cases, simplifying uniform result handling.

```swift
public extension Publisher {
    /// Puts success and failure streams in `Result`. In some publishers like `Future` both sink methods were required to get sucess and failure values
    /// to avoid that, this operator clubs both the streams in Result type so that you can get both success and failure as success wrapped in `Result`
    func clubIntoResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self
            .map { .success($0) }
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }
}
```
