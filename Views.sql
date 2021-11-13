CREATE OR ALTER VIEW dbo.QuestionsWithUsers
AS 
	SELECT
	P.Id As PostID,
	P.OwnerUserId As UserId,
	U.DisplayName As UserName,
	P.CreationDate,
	P.Body
	FROM
	dbo.Posts P INNER JOIN dbo.Users U
	ON P.OwnerUserId = U.Id
	WHERE P.PostTypeId = 1 -- 1 Question
GO

CREATE UNIQUE CLISTERED INDEX Post_IX ON dbo.QuestionsWithUsers(PostId)

SELECT * FROM dbo.QuestionsWithUsers;
