-- 1. Create the database
CREATE DATABASE LibraryDB;
GO


USE LibraryDB;
GO


CREATE TABLE Authors (
    AuthorID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Bio NVARCHAR(MAX)
);
GO


CREATE TABLE Books (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    AuthorID INT NOT NULL,
    ISBN NVARCHAR(20),
    Genre NVARCHAR(50),
    PublishedYear INT,
    CopiesAvailable INT DEFAULT 0,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);
GO


CREATE TABLE Members (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20),
    MembershipDate DATE DEFAULT GETDATE()
);
GO

CREATE TABLE Loans (
    LoanID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    LoanDate DATE DEFAULT GETDATE(),
    DueDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);
GO

INSERT INTO Authors (Name, Bio) VALUES
('J.K. Rowling', 'British author, best known for the Harry Potter series.'),
('George Orwell', 'English novelist and essayist.'),
('Jane Austen', 'English novelist known for her romantic fiction.');
GO

INSERT INTO Books (Title, AuthorID, ISBN, Genre, PublishedYear, CopiesAvailable) VALUES
('Harry Potter and the Philosopher''s Stone', 1, '9780747532699', 'Fantasy', 1997, 5),
('1984', 2, '9780451524935', 'Dystopian', 1949, 3),
('Pride and Prejudice', 3, '9780141439518', 'Romance', 1813, 4);
GO

INSERT INTO Members (FullName, Email, Phone) VALUES
('Alice Johnson', 'alice@example.com', '1234567890'),
('Bob Smith', 'bob@example.com', '0987654321');
GO

INSERT INTO Loans (MemberID, BookID, DueDate) VALUES
(1, 1, DATEADD(DAY, 14, GETDATE())),
(2, 2, DATEADD(DAY, 14, GETDATE()));
GO


SELECT 
    b.BookID,
    b.Title, 
    a.Name AS Author, 
    b.Genre, 
    b.PublishedYear, 
    b.CopiesAvailable
FROM Books b
JOIN Authors a ON b.AuthorID = a.AuthorID;
GO


SELECT * FROM Members;
GO


SELECT 
    l.LoanID,
    m.FullName AS Member,
    b.Title AS Book,
    l.LoanDate,
    l.DueDate,
    l.ReturnDate
FROM Loans l
JOIN Members m ON l.MemberID = m.MemberID
JOIN Books b ON l.BookID = b.BookID
WHERE l.ReturnDate IS NULL;
GO


SELECT 
    l.LoanID,
    m.FullName AS Member,
    b.Title AS Book,
    l.DueDate
FROM Loans l
JOIN Members m ON l.MemberID = m.MemberID
JOIN Books b ON l.BookID = b.BookID
WHERE l.ReturnDate IS NULL AND l.DueDate < GETDATE();
GO


SELECT 
    Title, 
    CopiesAvailable 
FROM Books 
WHERE CopiesAvailable > 0;
GO
