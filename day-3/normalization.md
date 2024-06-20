### Normalization

For in-depth analysis, got through the slides here:
https://www.db-book.com/slides-dir/PDF-dir/ch7.pdf

To reduce dependencies between different columns in a table.
To store it in a logical and structured way.

#### Why?
- To reduce the data redundancy
- To improve the data consistency (or integrity) on updates
- Flexibility (changing schema)

Let's take the example of the following table:

```mermaid
erDiagram
    enrolments {
        string studentId
        string studentName
        string courseId
        string courseName
        string instructorId
        string instructorName
        string instructorOffice
        int year
        String season
        string[] studentPhones
        string[] instructorPhones
    }
```

Above, an example of transitive dependency is this:
- Student name (A) depends on Student Id (B)
- Student id (B) depends on the year and season (C).
  > Meaning that, one student taking a particular course
  > (ex, OS course in year 2024 Spring) depends on the year and Season.

A -> B -> C : A -> C

We need to split this table.


### 1NF

Flat data -> no arrays or lists

```mermaid
erDiagram
    enrolments {
        string studentId
        string studentName
        string courseId
        string courseName
        string instructorId
        string instructorName
        string instructorOffice
        int year
        String season
    }
    
    phoneNumbers {
        string userId
        string phoneNumber
    }
    
    enrolments zero or more to zero or more phoneNumbers : contains
```

## 2NF

```mermaid
classDiagram
    class Student {
        +String id
        +String name
    }
    
    class Instructor {
        +String id
        +String name
        +String office
    }
    
    class Subject {
        +String id
        +String name
    }
    
    class Course {
        +String id
        +String subjectId
        +String year
%%        Semester is autumn or spring
        +String semester
    }
    
    class Enrolments {
        String courseId
        String studentId
    }
    
    class Undertakings {
        +String courseId
        +String instructorId
    }
    
    Enrolment --> Student
    Enrolment --> Subject
    Enrolment --> Instructor
```

- There are multiple students, teachers, courses.
- One student can enroll in multiple courses in each semester.
- One or more teachers undertake the course on a particular year's semester.

Semester:
2024-Autumn
2024-Spring
Year 2024
Semester Autumn / Spring

### Transitive dependency

A <- B <- C : Transitive property C -> A.

```mermaid
erDiagram
    students {
        string id
        string name
    }
    
    instructors {
        string id
        string name
        string office
    }
    
    subjects {
        string id
        string name
    }
    
    courses {
        string id
        string subjectId
        string year
%%        Semester is autumn or spring
        string semester
    }
    
    enrolments {
        string courseId
        string studentId
    }
    
    undertakings {
        string courseId
        string instructorId
    }
    
    phoneNumbers {
        string userId
        string phoneNumber
    }
    
    students zero or one to zero or more phoneNumbers : contains
    instructors zero or one to zero or more phoneNumbers : contains
    
    instructors one or more to zero or more courses : undertakings
    
    students zero or more to zero or more courses : enrolments
    courses zero or more to one subjects : contains
```
